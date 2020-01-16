#!/bin/bash
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
printf "\n\n"
echo -e '\e[96m  /$$$$$$                                  /$$               /$$ /$$             /$$     /$$                    '
echo -e ' /$$__  $$                                | $$              | $$| $$            | $$    |__/                    '
echo -e '| $$  \__/  /$$$$$$  /$$$$$$$   /$$$$$$$ /$$$$$$    /$$$$$$ | $$| $$  /$$$$$$  /$$$$$$   /$$  /$$$$$$  /$$$$$$$ '
echo -e '| $$       /$$__  $$| $$__  $$ /$$_____/|_  $$_/   /$$__  $$| $$| $$ |____  $$|_  $$_/  | $$ /$$__  $$| $$__  $$'
echo -e '| $$      | $$  \ $$| $$  \ $$|  $$$$$$   | $$    | $$$$$$$$| $$| $$  /$$$$$$$  | $$    | $$| $$  \ $$| $$  \ $$'
echo -e '| $$    $$| $$  | $$| $$  | $$ \____  $$  | $$ /$$| $$_____/| $$| $$ /$$__  $$  | $$ /$$| $$| $$  | $$| $$  | $$'
echo -e '|  $$$$$$/|  $$$$$$/| $$  | $$ /$$$$$$$/  |  $$$$/|  $$$$$$$| $$| $$|  $$$$$$$  |  $$$$/| $$|  $$$$$$/| $$  | $$'
echo -e ' \______/  \______/ |__/  |__/|_______/    \___/   \_______/|__/|__/ \_______/   \___/  |__/ \______/ |__/  |__/'
printf '\t\t\t\t\t\t\t\t\tCreated By Chase Merola (cEMa™) © 2011'
printf "\n\n"

software_name='constellation_ce'

# Getting the OS release version
#redhat_version=$(cat /etc/redhat-release | grep -oE '[0-9]+\.[0-9]+'|cut -d"." -f1)
#ubuntu_version=$(lsb_release -a | grep -v 'available')

echo -e '\e[93m Verifying script authenticity... \e[92m OK \e[0m'

echo -e '\e[93m Checking for existing config... \e[92m OK \e[0m'

if [[ -e config/main.cfg ]]
then
    echo -e '\e[93m WARNING \e[0m'
	printf "\nThe constellation agent has already been configured on this system.\n\n"
	printf "Overwrite Config?"
    echo "ok"
else
	printf "\n"
	echo -e '\e[44m Initializing Installation \e[0m\n'
    echo -e '\e[93m Do you agree to the terms and licensing agreements outlined @ https://github.com/cmerola/Contellation_CE/blob/master/LICENSE? \e[0m'
	read -p " I Agree (y) I Decline (n)? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
	echo -e "\n\e[101m You Did NOT Agree! Exiting \e[0m\n\n"
    exit 1
fi
# do dangerous stuff

###############
#  Check Prerequisites  #
###############
printf "\n"
echo -e '\e[93m Checking Prerequisites... \e[0m'

#Check if GNU Bash v3.2+ installed
if [ -f /bin/bash* ]; then
    echo -e '\e[93m  - GNU Bash v3.2+ \e[92m OK \e[0m'
else 
    echo -e "\e[43m  - GNU Bash v3.2+ wasn't found! \e[0m"
	read -p "Install it now? (y/n)" -n 1 -r
	if [[ ! $REPLY =~ ^[Yy]$ ]]
	then
		echo -e "\n\n\e[101m Exiting Installer \e[0m\n\n"
		exit 1
	fi
fi

#Check if MySQL Client installed
if [ -f /etc/init.d/mysql* ]; then
    echo -e '\e[93m  - MySQL Client \e[92m OK \e[0m'
else 
    echo -e "\e[43m  - MySQL Client wasn't found! \e[0m"
	read -p "Install it now? (y/n)" -n 1 -r
	if [[ ! $REPLY =~ ^[Yy]$ ]]
	then
		echo -e "\n\n\e[101m Exiting Installer \e[0m\n\n"
		exit 1
	fi
fi

###########
#  begin Config  #
###########
	#Test SQL Connection
	mysql -h $RDS_MYSQL_ENDPOINT -u $RDS_MYSQL_USER -p$RDS_MYSQL_PASS -D $RDS_MYSQL_BASE -e 'quit';

	if [[ $? -eq 0 ]]; then
		echo "MySQL connection: OK";

#		#Write Config
#        cat >/opt/${software_name}/config/main.conf <<EOF
#			QUERY_HOST_INFORMATION='mysql -h '$RDS_MYSQL_ENDPOINT' -u '$RDS_MYSQL_USER' -p'$RDS_MYSQL_PASS' -D '$RDS_MYSQL_BASE''
#		EOF
    echo -e '\e[93m 1st \e[0m'
	fi

	    echo -e '\e[93m You Did NOT Agree! Exiting \e[0m'
	    exit
	fi
	    echo -e '\e[93m 3rd \e[0m'
fi
	    echo -e '\e[93m END \e[0m'
fi
