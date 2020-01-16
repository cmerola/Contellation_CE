#!/bin/bash
#Borrowed from anacron
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin



#################
# Configuration #
#---------------#################################################################################
#											        #
#   This includes all the settings that you will need to configure the script on general    	#
#   linux systems running perl. Do not install this script into the cron until you have	    	#
#   verified your configuration in this section. Enjoy!					        #
#												#
#################################################################################################

EMAIL="example"
CHASE_PHONE="example"



# DEBUGGING TOOLS
#SET 30 SECOND CRON
# */1 * * * * ( sleep 30 ; /bin/script.sh )
#Uncomment to enable
#ECHO=$(#)
var=$((var+1))

# MYSQL CONNECTION INFORMATION
MYSQL_DB='example'
MYSQL_HOST='example'
MYSQL_PORT='example'
MYSQL_USER='example'
MYSQL_PASS='example'


RDS_MYSQL_ENDPOINT="example";
RDS_MYSQL_USER="example";
RDS_MYSQL_PASS="example";
RDS_MYSQL_BASE="example";

mysql -h $RDS_MYSQL_ENDPOINT -u $RDS_MYSQL_USER -p$RDS_MYSQL_PASS -D $RDS_MYSQL_BASE -e 'quit';

if [[ $? -eq 0 ]]; then
    echo "MySQL connection: OK";


#MySQL Shortcut CMD
QUERY_HOST_INFORMATION='mysql -h '$RDS_MYSQL_ENDPOINT' -u '$RDS_MYSQL_USER' -p'$RDS_MYSQL_PASS' -D '$RDS_MYSQL_BASE''
#QUERY_HOST_INFORMATION2='mysql --host="$MYSQL_HOST" --port=$MYSQL_PORT --user="$MYSQL_USER" --password="$MYSQL_PASS" --database="$MYSQL_DB"'

# NOTIFICATION CONTACTS
#ADMIN="example@mail.com"
#ADMINSMS="example@mail.com"
#ADMIN="example@mail.com"
#ADMINSMS="example@mail.com"

# EMAIL PROGRAM
MAIL="/bin/mail"

# log directories
log_location="/var/log/"

#################
#    Cool Commands       #
#---------------#################################################################################
#
#  Number of connections per port
#  netstat -tuna | awk -F':+| +' 'NR>2{print $5}' | cut -d: -f1 | sort | uniq -c | sort -n
#
#
#
##################################################################################################################


###########
#    GENERAL    #
#---------------#################################################################################
#											                                                   	#
#   This includes all general system information found on all systems.                        	#
#                                                                                              	#
#   -HOSTNAME   -OS   -CPU    -RAM    -PROCESSES    -IP    -SCRIPT_INFO                         #
#												                                                #
#################################################################################################

#----------------------------
#    GENERAL INFORMATION
#----------------------------

# server hostname
HOSTNAME=$(hostname)
#echo "Hostname: $HOSTNAME"

UNAME=$(uname -a)
#echo "$UNAME"

PLATFORM=$(uname -a | less | awk '{ print $13 }')
#echo "PLATFORM: $PLATFORM"

OS=$(cat /etc/*release | head -1)
#echo "Operating System: $OS"

KERNEL=$(uname -r)
#echo "Kernel: $KERNEL"

# system uptime
UPTIME=$(uptime | awk -F'( |,|:)+' '{print $6" " $7" and",$8,"minutes"}')
#echo "Uptime: $UPTIME"

# system uptime
LAST_UPDATED=$(date +'%Y-%m-%d %H:%M:%S')
#echo "Last Updated (DB): $LAST_UPDATED"
#echo ""

# lookup the name of this script
SCRIPTNAME=`basename $0`
#echo "Script Name: $SCRIPTNAME"

# lookup the script location
SCRIPTLOC="${PWD}/"
#echo "Script Location: $SCRIPTLOC"


#--------------------------------------
#    DISK / HDD / SSD INFORMATION
#--------------------------------------

# primary disk
DISK_PRIMARY=$(df -P / | awk 'END{print $1}' | sed 's|.*/||')
printf "Primary Disk: $DISK_PRIMARY\n"
# Read IOPS
DISK_IOPS_READ=$(iostat -dx 1 3 ${DISK_PRIMARY} | grep -w ${DISK_PRIMARY} | awk '{ print $4; }' | tail -n 1)
printf "READ IOPS: $DISK_IOPS_READ\n"
# Write IOPS
DISK_IOPS_WRITE=$(iostat -dx 1 3 ${DISK_PRIMARY} | grep -w ${DISK_PRIMARY} | awk '{ print $5; }' | tail -n 1)
printf "WRITE IOPS: $DISK_IOPS_READ\n"
# Total IOPS
DISK_IOPS_TOTAL=$(iostat -d 1 3 ${DISK_PRIMARY} | grep -w ${DISK_PRIMARY} | awk '{ print $2; }' | tail -n 1)
printf "TOTAL IOPS: $DISK_IOPS_TOTAL\n"
# Total Latency
DISK_LATENCY=$(iostat -dx 1 3 ${DISK_PRIMARY} | grep -w ${DISK_PRIMARY} | awk '{ print $10; }' | tail -n 1)
printf "DISK LATENCY: $DISK_LATENCY\n"
# Total Utilized
DISK_UTILIZED=$(iostat -dx 1 3 ${DISK_PRIMARY} | grep -w ${DISK_PRIMARY} | awk '{ print $14; }' | tail -n 1 | sed 's|.*/||')
printf "DISK UTILIZED: $DISK_UTILIZED\n"

#--------------------------------------
#    MAIL - EXIM
#--------------------------------------

#mail_stats=$(whmapi1 emailtrack_stats)

mail_stats_total=$(whmapi1 emailtrack_stats | grep SENDCOUNT | awk '{ print $2; }')
printf "Mail Sent: $mail_stats_total\n"
mail_stats_inprogress=$(whmapi1 emailtrack_stats | grep INPROGRESSCOUNT | awk '{ print $2; }')
printf "In Progress Mail: $mail_stats_inprogress\n"
mail_stats_success=$(whmapi1 emailtrack_stats | grep SUCCESSCOUNT | awk '{ print $2; }')
printf "Successful Mail: $mail_stats_success\n"
mail_stats_failed=$(whmapi1 emailtrack_stats | grep -w FAILCOUNT | awk '{ print $2; }')
printf "Failed Mail: $mail_stats_failed\n"
mail_stats_deferred=$(whmapi1 emailtrack_stats | grep DEFERCOUNT | awk '{ print $2; }')
printf "Deferred Mail: $mail_stats_success\n"


#echo ""
# Moved this script to a new location?? Do your testing here via cli, just uncomment the two lines below and possibly comment the stuff at the bottom to prevent email spam durring testing
#cmdtest="$(df -hP | egrep '/amavis' | awk '{ print $6 "_:_" $5 }')"
#echo $cmdtest


#--------------------------------------
#    CPU INFORMATION
#--------------------------------------

#CPU_LOAD_EXACT=$(top -b -n2 -p 1 | fgrep "Cpu(s)" | tail -1 | awk -F'id,' -v prefix="$prefix" '{ split($1, vs, ","); v=vs[length(vs)]; sub("%", "", v); printf "%s%.1f%%\n", prefix, 100 - v }')
#CPU_LOAD_CURRENT_OLD=$(top -d 0.01 -b -n2 | grep "Cpu(s)"|tail -n 1 | awk '{print $2 + $4}')
CPU_LOAD_CURRENT=$(uptime | grep -ohe 'load average[s:][: ].*' | awk '{ print $3 }' | sed s'/.$//')
#echo $CPU_LOAD_CURRENT
CPU_USED_PERCENT=$(top -b -n2 -p 1 | fgrep "Cpu(s)" | tail -1 | awk -F'id,' -v prefix="$prefix" '{ split($1, vs, ","); v=vs[length(vs)]; sub("%", "", v); printf "%s%.1f%%\n", prefix, 100 - v }' | sed s'/.$//')
#echo "$PARTITIONS"

#--------------------------------------
#    RAM/MEMORY  INFORMATION
#--------------------------------------
#Memory
MEMORY_TOTAL=$(free -t -m | head -n 2 | tail -n 1 | awk '{print $2}')
MEMORY_AVAILABLE=$(free -t -m | head -n 2 | tail -n 1 | awk '{print $7}')
MEMORY_USED=$(free -t -m | head -n 2 | tail -n 1 | awk '{print $3}')
MEMORY_FREE=$(free -t -m | head -n 2 | tail -n 1 | awk '{print $4}')
MEMORY_SHARED=$(free -t -m | head -n 2 | tail -n 1 | awk '{print $5}')
MEMORY_CACHED=$(free -t -m | head -n 2 | tail -n 1 | awk '{print $6}')
MEMORY_USED_PERCENT=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
# Swap
MEMORY_SWAP_TOTAL=$(free -t -m | tail -n 2 | head -n 1 | awk '{print $2}')
MEMORY_SWAP_USED=$(free -t -m | tail -n 2 | head -n 1 | awk '{print $3}')
MEMORY_SWAP_FREE=$(free -t -m | tail -n 2 | head -n 1 | awk '{print $4}')

#--------------------------------------
#    RUNNING PROCESSES
#--------------------------------------

PROCESS_LIST_RAW=$(top -n 1 -b)
#echo "$PROCESS_LIST_RAW"
#OLD# PROCESS_LIST_TOP_20_CPU=$(ps aux | sort -rk 3,3 | head -n 20)
PROCESS_LIST_TOP_20_CPU=$(ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 20)
#echo "$PROCESS_LIST_TOP_20_CPU"
#OLD# PROCESS_LIST_TOP_20_MEM=$(ps aux | sort -rk 4,4 | head -n 20)
PROCESS_LIST_TOP_20_MEM=$(ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 20)
#echo "$PROCESS_LIST_TOP_20_MEM"

PROCESS_TREE_RAW=$(pstree)
#PROCESS_TREE_RAW=$(top -n 1 -b)
#echo "$PROCESS_TREE_RAW"

#--------------------------------------
#    Software - Apache
#--------------------------------------

# Check if apache is installed
software_status_apache_cmd=$(systemctl status httpd.service)
if [[ "$software_status_apache_cmd" == *"is running"* ]] || [[ "$software_status_apache_cmd" == *"active (running)"* ]]; then
        
        software_is_installed_apache="1"
		#echo $software_is_installed_apache
	
	software_apache_status="1"
	#echo $software_apache_status
	
	software_apache_process_count=$(ps aux | grep -E '(apache|httpd)' | wc -l)
	software_apache_connected_ip_count=$(netstat -tuna | awk -F':+| +' 'NR>2{print $5}' | cut -d: -f1 | sort | uniq -c | sort -n | grep -w -E '80|443' | awk '{print $1}' | paste -sd+ | bc)
	software_php_process_count=$(ps aux | grep -E '(php)' | grep -v grep | wc -l)

else
	
        software_is_installed_apache="0"
		#echo $software_is_installed_apache
        software_apache_status="0"
		
		#echo $software_status_apache
       
fi

software_apache_version=$(apachectl -v | cut -d " " -f 3- | head -1)
#software_apache_version=null
#echo $software_apache_version

software_apache_built=$(ps -eo comm,etime | grep httpd | cut -d " " -f 2- | sed -e 's/^[ \t]*//' | awk '{ print length(), $0 | "sort -n" }' | grep -v "defunct" | tail -1 | cut -d " " -f 2-)
#echo $software_apache_built

# Check config
check_apache_conf=$(apachectl configtest 2>&1)
#echo "Result of checking apache config: $check_conf_result"

if [[ "$check_apache_conf" == *"Syntax OK"* ]] ; then
        #echo "config is good"
        apache_conf_status="Syntax OK"
		apache_alert="0"
		#		echo "Syntax OK"
        #echo $apache_conf_status

else
	apache_alert="1"
	#echo "Apache conf is bad"
	apache_conf_status="Error - See verbose_apache_conf_test for details"
	#echo $apache_conf_status
	
	# send errors to the db under: software_apache_config_report
	
       #echo -e "$EMAIL" | $MAIL -s "Apache conf is broken"
       #mail -s "Apache conf is broken" $EMAIL
fi

        #software_apache_config_report=$(apachectl configtest)
        #echo $software_apache_config_report
		#		echo $apache_alert
if [ "$apache_alert" -eq 1 ] ; then
        comment="empty"
		#echo "config is good"
		#		echo "Sent notification email"
        #echo -e "WHM Apache Died - Manual Intervention Needed!" | $MAIL -s "Apache Died on $HOSTNAME" "$CHASE_PHONE"
#		/usr/sbin/sendmail "$CHASE_PHONE" <<EOF
#subject:$subject
#from:$from
#
#Example Message
#EOF
        #echo $apache_conf_status

else
		#do nothing
		 comment="empty"
		#echo "Apache is okay!"
fi

#--------------------------------------
#    Software - exim
#--------------------------------------
#software_exim_installed=$(command -v exim >/dev/null 2>&1)
# Check if apache is installed
if command -v exim >/dev/null; then
#echo "exim is installed"
	if ps waux | grep exim | grep -v 'grep' > /dev/null; then
        
		software_exim_running="1"
		#echo $software_exim_installed
		#echo $software_exim_installed
		#echo "see exim is installed"
		#echo "did not match is running condition"
	
		#software_exim_status=$(exim status)
		software_exim_queue=$(exim -bpc)
		if exim -bp | exiqsumm | grep -v empty > /dev/null; then
		#echo $software_exim_queue
		#echo "see exim is installed"
		comment="null"
		else 
		comment="null"
		echo "see exim is not installed"
		software_exim_running="0"
		software_exim_queue="0"
		fi
	#echo $software_exim_status
	#echo $software_exim_queue
	fi
else
	software_exim_installed="0"
		#echo $software_exim_installed
        software_exim_status="exim is NOT running"
		
		#echo "exim not installed"
fi

#software_exim_version=$(exim status)
#software_exim_version=null
#echo $software_exim_version

#software_exim_built=$(exim status)
#echo $software_exim_built

# Check config
#check_exim_conf=$(exim status 2>&1)
#echo "Result of checking exim config: $check_conf_result"

#if [[ "$check_exim_conf" == *"Syntax OK"* ]] ; then
 #       #echo "config is good"
  #      exim_conf_status="Syntax OK"
#		exim_alert="0"
#		#		echo "Syntax OK"
 #       #echo $exim_conf_status
#
#else
#	exim_alert="1"
#	#echo "exim conf is bad"
#	exim_conf_status="Error - See verbose_exim_conf_test for details"
#	#echo $exim_conf_status
#	
##	# send errors to the db under: software_exim_config_report
##	
    #   #echo -e "$EMAIL" | $MAIL -s "exim conf is broken"
     #  #mail -s "exim conf is broken" $EMAIL
#fi

        #software_exim_config_report=$(eximctl configtest)
        #echo $software_exim_config_report
		#		echo $exim_alert
#if [ "$exim_alert" -eq 1 ] ; then
#        comment="empty"
		#echo "config is good"
		#		echo "Sent notification email"
        #echo -e "WHM exim Died - Manual Intervention Needed!" | $MAIL -s "exim Died on $HOSTNAME" "$CHASE_PHONE"
#		/usr/sbin/sendmail "$CHASE_PHONE" <<EOF
#subject:$subject
#from:$from
#
#Example Message
#EOF
        #echo $exim_conf_status

#else
		#do nothing
#		 comment="empty"
		#echo "exim is okay!"
#fi
#################################

#--------------------------------------
#    NETWORKING
#--------------------------------------

IPADDRESS_LIST_ALL=$(/sbin/ifconfig | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")
#echo "$IPADDRESS_LIST_ALL"
IPADDRESS_ETH0=$(/sbin/ifconfig | head -n 2 | tail -n 1 | awk '{ print $2"\n"$4"\n"$6}')
#echo "$IPADDRESS_ETH0"

##################
#      DISK      #
#----------------################################################################################
#											                                                   	#
#   This includes general disk information found on all systems.                              	#
#                                                                                              	#
#   -IO     -LATENCY      -ALL PARTITIONS w/AVAILABLE SPACE     -SMART                          #
#												                                                #
#################################################################################################

#--------------------------------------
#    DISK/PARTITION(s)  INFORMATION
#--------------------------------------

# ROOT PARTITION
#iostat=$(iostat -m | tail -n+5)
#echo "$iostat"

#echo ""

# Be sure to update the $availablespace directory
AVAILABLESPACE=$(df -hP | egrep '/amavis' | awk '{ print $4 }')
TOTALSPACE=$(df -hP | egrep '/amavis' | awk '{ print $2 }')
USEDSPACE=$(df -hP | egrep '/amavis' | awk '{ print $3 }')

# LIST ALL PARTITIONS

PARTITION_LIST_RAW=$(df -hP)
#echo "$PARTITIONS"

# LIST INDIVIDUAL PARTITIONS
disk_a_mounted_name=$(df -h | sed -e 1d | awk '{print $6,$5,$4}' | sort -n | head -n 1 | awk '{print $1}')
disk_a_used_percent=$(df -h | sed -e 1d | awk '{print $6,$5,$4}' | sort -n | head -n 1 | awk '{print $2}' | sed 's/.$//')
disk_a_available=$(df -h | sed -e 1d | awk '{print $6,$5,$4}' | sort -n | head -n 1 | awk '{print $3}')
disk_b_mounted_name=$(df -h | sed -e 1d | awk '{print $6,$5,$4}' | sort -n | sed -n '2{p;q}' | awk '{print $1}')
disk_b_used_percent=$(df -h | sed -e 1d | awk '{print $6,$5,$4}' | sort -n | sed -n '2{p;q}' | awk '{print $2}' | sed 's/.$//')
disk_b_available=$(df -h | sed -e 1d | awk '{print $6,$5,$4}' | sort -n | sed -n '2{p;q}' | awk '{print $3}')
disk_c_mounted_name=$(df -h | sed -e 1d | awk '{print $6,$5,$4}' | sort -n | sed -n '3{p;q}' | awk '{print $1}')
disk_c_used_percent=$(df -h | sed -e 1d | awk '{print $6,$5,$4}' | sort -n | sed -n '3{p;q}' | awk '{print $2}' | sed 's/.$//')
disk_c_available=$(df -h | sed -e 1d | awk '{print $6,$5,$4}' | sort -n | sed -n '3{p;q}' | awk '{print $3}')
disk_d_mounted_name=$(df -h | sed -e 1d | awk '{print $6,$5,$4}' | sort -n | sed -n '4{p;q}' | awk '{print $1}')
disk_d_used_percent=$(df -h | sed -e 1d | awk '{print $6,$5,$4}' | sort -n | sed -n '4{p;q}' | awk '{print $2}' | sed 's/.$//')
disk_d_available=$(df -h | sed -e 1d | awk '{print $6,$5,$4}' | sort -n | sed -n '4{p;q}' | awk '{print $3}')
disk_e_mounted_name=$(df -h | sed -e 1d | awk '{print $6,$5,$4}' | sort -n | sed -n '5{p;q}' | awk '{print $1}')
disk_e_used_percent=$(df -h | sed -e 1d | awk '{print $6,$5,$4}' | sort -n | sed -n '5{p;q}' | awk '{print $2}' | sed 's/.$//')
disk_e_available=$(df -h | sed -e 1d | awk '{print $6,$5,$4}' | sort -n | sed -n '5{p;q}' | awk '{print $3}')
disk_f_mounted_name=$(df -h | sed -e 1d | awk '{print $6,$5,$4}' | sort -n | sed -n '6{p;q}' | awk '{print $1}')
disk_f_used_percent=$(df -h | sed -e 1d | awk '{print $6,$5,$4}' | sort -n | sed -n '6{p;q}' | awk '{print $2}' | sed 's/.$//')
disk_f_available=$(df -h | sed -e 1d | awk '{print $6,$5,$4}' | sort -n | sed -n '6{p;q}' | awk '{print $3}')
disk_g_mounted_name=$(df -h | sed -e 1d | awk '{print $6,$5,$4}' | sort -n | sed -n '7{p;q}' | awk '{print $1}')
disk_g_used_percent=$(df -h | sed -e 1d | awk '{print $6,$5,$4}' | sort -n | sed -n '7{p;q}' | awk '{print $2}' | sed 's/.$//')
disk_g_available=$(df -h | sed -e 1d | awk '{print $6,$5,$4}' | sort -n | sed -n '7{p;q}' | awk '{print $3}')
disk_h_mounted_name=$(df -h | sed -e 1d | awk '{print $6,$5,$4}' | sort -n | sed -n '8{p;q}' | awk '{print $1}')
disk_h_used_percent=$(df -h | sed -e 1d | awk '{print $6,$5,$4}' | sort -n | sed -n '8{p;q}' | awk '{print $2}' | sed 's/.$//')
disk_h_available=$(df -h | sed -e 1d | awk '{print $6,$5,$4}' | sort -n | sed -n '8{p;q}' | awk '{print $3}')
disk_i_mounted_name=$(df -h | sed -e 1d | awk '{print $6,$5,$4}' | sort -n | sed -n '9{p;q}' | awk '{print $1}')
disk_i_used_percent=$(df -h | sed -e 1d | awk '{print $6,$5,$4}' | sort -n | sed -n '9{p;q}' | awk '{print $2}' | sed 's/.$//')
disk_i_available=$(df -h | sed -e 1d | awk '{print $6,$5,$4}' | sort -n | sed -n '9{p;q}' | awk '{print $3}')
disk_j_mounted_name=$(df -h | sed -e 1d | awk '{print $6,$5,$4}' | sort -n | sed -n '10{p;q}' | awk '{print $1}')
disk_j_used_percent=$(df -h | sed -e 1d | awk '{print $6,$5,$4}' | sort -n | sed -n '10{p;q}' | awk '{print $2}' | sed 's/.$//')
disk_j_available=$(df -h | sed -e 1d | awk '{print $6,$5,$4}' | sort -n | sed -n '10{p;q}' | awk '{print $3}')
disk_k_mounted_name=$(df -h | sed -e 1d | awk '{print $6,$5,$4}' | sort -n | sed -n '11{p;q}' | awk '{print $1}')
disk_k_used_percent=$(df -h | sed -e 1d | awk '{print $6,$5,$4}' | sort -n | sed -n '11{p;q}' | awk '{print $2}' | sed 's/.$//')
disk_k_available=$(df -h | sed -e 1d | awk '{print $6,$5,$4}' | sort -n | sed -n '11{p;q}' | awk '{print $3}')

#--------------------------------------
#    MYSQL UPDATE QUERY
#--------------------------------------
printf "Mail Sent: $mail_stats_sent\n"
$QUERY_HOST_INFORMATION -e "INSERT INTO host_information SET
host=\"$HOSTNAME\",
platform=\"$PLATFORM\",
os=\"$OS\",
kernel=\"$KERNEL\",
cpu_load_current=\"$CPU_LOAD_CURRENT\",
cpu_used_percent=\"$CPU_USED_PERCENT\",
memory_used_percent=\"$MEMORY_USED_PERCENT\",
memory_total=\"$MEMORY_TOTAL\",
memory_available=\"$MEMORY_AVAILABLE\",
memory_free=\"$MEMORY_TOTAL\",
memory_used=\"$MEMORY_USED\",
memory_cached=\"$MEMORY_CACHED\",
memory_shared=\"$MEMORY_SHARED\",
memory_swap_total=\"$MEMORY_SWAP_TOTAL\",
memory_swap_used=\"$MEMORY_SWAP_USED\",
memory_swap_free=\"$MEMORY_SWAP_FREE\",
ipaddress_eth0=\"$IPADDRESS_ETH0\",
ipaddress_list_all=\"$IPADDRESS_LIST_ALL\",
software_apache_is_installed=\"$software_is_installed_apache\",
software_apache_version=\"$software_apache_version\",
software_apache_built=\"$software_apache_built\",
software_apache_config_status=\"$apache_conf_status\",
software_apache_status=\"$software_apache_status\",
software_apache_config_report=\"$software_apache_config_report\",
software_apache_connected_ip_count=\"$software_apache_connected_ip_count\",
software_apache_process_count=\"$software_apache_process_count\",
software_php_process_count=\"$software_php_process_count\",
software_exim_queue=\"$software_exim_queue\",
software_exim_running=\"$software_exim_running\",
disk_a_mounted_name=\"$disk_a_mounted_name\",
disk_a_used_percent=\"$disk_a_used_percent\",
disk_a_available=\"$disk_a_available\",
disk_b_mounted_name=\"$disk_b_mounted_name\",
disk_b_used_percent=\"$disk_b_used_percent\",
disk_b_available=\"$disk_b_available\",
disk_c_mounted_name=\"$disk_c_mounted_name\",
disk_c_used_percent=\"$disk_c_used_percent\",
disk_c_available=\"$disk_c_available\",
disk_d_mounted_name=\"$disk_d_mounted_name\",
disk_d_used_percent=\"$disk_d_used_percent\",
disk_d_available=\"$disk_d_available\",
disk_e_mounted_name=\"$disk_e_mounted_name\",
disk_e_used_percent=\"$disk_e_used_percent\",
disk_e_available=\"$disk_e_available\",
disk_f_mounted_name=\"$disk_f_mounted_name\",
disk_f_used_percent=\"$disk_f_used_percent\",
disk_f_available=\"$disk_f_available\",
disk_g_mounted_name=\"$disk_g_mounted_name\",
disk_g_used_percent=\"$disk_g_used_percent\",
disk_g_available=\"$disk_g_available\",
disk_h_mounted_name=\"$disk_h_mounted_name\",
disk_h_used_percent=\"$disk_h_used_percent\",
disk_h_available=\"$disk_h_available\",
disk_i_mounted_name=\"$disk_i_mounted_name\",
disk_i_used_percent=\"$disk_i_used_percent\",
disk_i_available=\"$disk_i_available\",
disk_j_mounted_name=\"$disk_j_mounted_name\",
disk_j_used_percent=\"$disk_j_used_percent\",
disk_j_available=\"$disk_j_available\",
disk_k_mounted_name=\"$disk_k_mounted_name\",
disk_k_used_percent=\"$disk_k_used_percent\",
disk_k_available=\"$disk_k_available\",
last_updated=\"$LAST_UPDATED\",
disk_iops_read=\"$DISK_IOPS_READ\",
disk_iops_write=\"$DISK_IOPS_WRITE\",
disk_iops_total=\"$DISK_IOPS_TOTAL\",
disk_latency=\"$DISK_LATENCY\",
disk_utilized=\"$DISK_UTILIZED\",
mail_stats_total=\"$mail_stats_total\",
mail_stats_inprogress=\"$mail_stats_inprogress\",
mail_stats_success=\"$mail_stats_success\",
mail_stats_deferred=\"$mail_stats_deferred\",
mail_stats_failed=\"$mail_stats_failed\",
log_datetime=\"$LAST_UPDATED\";"
#WHERE host=\"$HOSTNAME\";"
printf "Mail Sent: $mail_stats_sent\n"


#mail_stats_sent\"$mail_stats_sent\",
#mail_stats_inprogress=\"$mail_stats_inprogress\",
#mail_stats_success=\"$mail_stats_success\",
#mail_stats_failed=\"$mail_stats_failed\",
#mail_stats_deferred=\"$mail_stats_deferred\",


#Disabled
#Partition_list_raw=\"$PARTITION_LIST_RAW\",
#process_list_raw=\"$PROCESS_LIST_RAW\",
#process_list_top_20_cpu=\"$PROCESS_LIST_TOP_20_CPU\",
#process_list_top_20_mem=\"$PROCESS_LIST_TOP_20_MEM\",
#process_tree_raw=\"$PROCESS_TREE_RAW\",

#-----------------------------------------
#    MYSQL UPDATE QUERY - MINIMAL
#-----------------------------------------

$QUERY_HOST_INFORMATION -e "UPDATE host_information_minimal SET
host=\"$HOSTNAME\",
platform=\"$PLATFORM\",
os=\"$OS\",
kernel=\"$KERNEL\",
cpu_load_current=\"$CPU_LOAD_CURRENT\",
cpu_used_percent=\"$CPU_USED_PERCENT\",
memory_used_percent=\"$MEMORY_USED_PERCENT\",
memory_total=\"$MEMORY_TOTAL\",
memory_available=\"$MEMORY_AVAILABLE\",
memory_free=\"$MEMORY_TOTAL\",
memory_used=\"$MEMORY_USED\",
memory_cached=\"$MEMORY_CACHED\",
memory_shared=\"$MEMORY_SHARED\",
memory_swap_total=\"$MEMORY_SWAP_TOTAL\",
memory_swap_used=\"$MEMORY_SWAP_USED\",
memory_swap_free=\"$MEMORY_SWAP_FREE\",
ipaddress_eth0=\"$IPADDRESS_ETH0\",
ipaddress_list_all=\"$IPADDRESS_LIST_ALL\",
software_apache_is_installed=\"$software_is_installed_apache\",
software_apache_version=\"$software_apache_version\",
software_apache_built=\"$software_apache_built\",
software_apache_config_status=\"$apache_conf_status\",
software_apache_status=\"$software_apache_status\",
software_apache_config_report=\"$software_apache_config_report\",
software_exim_queue=\"$software_exim_queue\",
software_exim_running=\"$software_exim_running\",
disk_a_mounted_name=\"$disk_a_mounted_name\",
disk_a_used_percent=\"$disk_a_used_percent\",
disk_a_available=\"$disk_a_available\",
disk_b_mounted_name=\"$disk_b_mounted_name\",
disk_b_used_percent=\"$disk_b_used_percent\",
disk_b_available=\"$disk_b_available\",
disk_c_mounted_name=\"$disk_c_mounted_name\",
disk_c_used_percent=\"$disk_c_used_percent\",
disk_c_available=\"$disk_c_available\",
disk_d_mounted_name=\"$disk_d_mounted_name\",
disk_d_used_percent=\"$disk_d_used_percent\",
disk_d_available=\"$disk_d_available\",
disk_e_mounted_name=\"$disk_e_mounted_name\",
disk_e_used_percent=\"$disk_e_used_percent\",
disk_e_available=\"$disk_e_available\",
disk_f_mounted_name=\"$disk_f_mounted_name\",
disk_f_used_percent=\"$disk_f_used_percent\",
disk_f_available=\"$disk_f_available\",
disk_g_mounted_name=\"$disk_g_mounted_name\",
disk_g_used_percent=\"$disk_g_used_percent\",
disk_g_available=\"$disk_g_available\",
disk_h_mounted_name=\"$disk_h_mounted_name\",
disk_h_used_percent=\"$disk_h_used_percent\",
disk_h_available=\"$disk_h_available\",
disk_i_mounted_name=\"$disk_i_mounted_name\",
disk_i_used_percent=\"$disk_i_used_percent\",
disk_i_available=\"$disk_i_available\",
disk_j_mounted_name=\"$disk_j_mounted_name\",
disk_j_used_percent=\"$disk_j_used_percent\",
disk_j_available=\"$disk_j_available\",
disk_k_mounted_name=\"$disk_k_mounted_name\",
disk_k_used_percent=\"$disk_k_used_percent\",
disk_k_available=\"$disk_k_available\",
last_updated=\"$LAST_UPDATED\",
log_datetime=\"$LAST_UPDATED\"
WHERE host=\"$HOSTNAME\";"


#Disabled
#Partition_list_raw=\"$PARTITION_LIST_RAW\",
#process_list_raw=\"$PROCESS_LIST_RAW\",
#process_list_top_20_cpu=\"$PROCESS_LIST_TOP_20_CPU\",
#process_list_top_20_mem=\"$PROCESS_LIST_TOP_20_MEM\",
#process_tree_raw=\"$PROCESS_TREE_RAW\",


# COUNT TIMES EXECUTED
#total_times_updated_db=$($QUERY_HOST_INFORMATION -s -N -e "SELECT total_times_updated FROM host_information WHERE host=\"$HOSTNAME\";")

#((increased_counter=total_times_updated_db+1))
increased_counter=`expr $total_times_updated_db + 1`

# INCREASE COUNTER IN DB
##$QUERY_HOST_INFORMATION -s -N -e "UPDATE host_information
##SET total_times_updated=\"$increased_counter\"
##WHERE host=\"$HOSTNAME\";"
#echo "Number of Times Updated: $increased_counter"

# Working Examples
# mysql --host="123.123.123.123" --port="3306" --user="dbuser" --password="password" --database="dbname" -e "UPDATE host_information SET host=\"$HOSTNAME\", platform=\"$PLATFORM\", os=\"$OS\", kernel=\"$KERNEL\" WHERE host=\"$HOSTNAME\";"
#INSERT IGNORE INTO host_information (host,platform,os,kernel) values('$HOSTNAME','$PLATFORM','$OS','$KERNEL') ON DUPLICATE KEY UPDATE host=values(host), platform=values(platform), os=values(os), kernel=values(kernel) WHERE host < VALUES($HOSTNAME);


 
# uncomment if you are using Debian / Ubuntu Linux
#RESTART="/etc/init.d/apache2 restart"
 
#path to pgrep command
PGREP="/usr/bin/pgrep"
 
# Httpd daemon name,
# Under RHEL/CentOS/Fedora it is httpd
# Under Debian 4.x it is apache2
HTTPD="httpd"
 
# find httpd pid
#$PGREP ${HTTPD}
pgrep_apache=$(/usr/bin/pgrep httpd | head -n 1)
 
if [ $pgrep_apache -ne 0 ] # if apache not running 
then
 #echo "apache not running!"
  #echo -e "WHM Apache Died - Manual Intervention Needed!" | $MAIL -s "Apache Died on $HOSTNAME" "$CHASE_PHONE"
 # restart apache
 comment="empty"
#$RESTART
 else
  comment="empty"
 #echo "apache is running!"
fi

else
    echo "MySQL connection: Fail";
	notify='$MAIL -s "$HOSTNAME MySQL connection: Fail to $RDS_MYSQL_ENDPOINT" $CHASE_PHONE'
	eval $notify
fi;
