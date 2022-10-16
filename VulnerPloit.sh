#!/bin/bash

###########################
### VULNERMAPPER FUNCTIONS
###########################

# INSTALL(): automatically installs relevant applications and creates relevant directories
# CONSOLE(): collects user input for session name and network range, creates new directory, and executes the subsequent core functions
# NMAP_SCAN(): uses Nmap to scan for ports and services, and saves information into directory
# NMAP_ENUM(): uses Nmap Scripting Engine (NSE) to conduct further enumeration of hosts, based on scan results
# SEARCHSPLOIT_VULN(): uses Searchsploit to find potential vulnerabilities based on enumeration results
# HYDRA_BRUTE(): uses Hydra to find weak passwords used in the network's login services, based on scan results
# LOG(): shows the user the collated results of NMAP_SCAN(), NMAP_ENUM(), SEARCHSPLOIT_VULN(), and HYDRA_BRUTE() after their execution 

#####################
### INSTALL FUNCTION
#####################

### DEFINITION

function INSTALL()
{
	### START
	echo " "
	echo "[*] EXECUTION OF INSTALL MODULE:"
	echo " "
	echo "[*] Installing and updating applications on your local computer..."
	echo " "
	echo "[*] Creating new directory: ~/VulnerMapper..."
	echo " "
	
	### DIRECTORY
	# create a directory to contain output files 
	cd ~
	mkdir VulnerMapper
	cd ~/VulnerMapper
	echo "[+] Directory created: ~/VulnerMapper"
	echo " "
	
	### APT UPDATE
	# update APT packages
	sudo apt-get -y update
	sudo apt-get -y upgrade
	sudo apt-get -y dist-upgrade
	
	# WORDLIST CONFIGURATION
	echo "[*] Configuring Wordlists..."
	echo " "
	sudo apt-get -y install wordlists
	cd /usr/share/wordlists
	sudo gunzip rockyou.txt.gz
	sudo cp rockyou.txt ~/VulnerMapper/wordlist.txt
	cd ~/VulnerMapper
	sudo sed -i '1i kali' wordlist.txt
	echo "[+] Wordlist created: ~/VulnerMapper/wordlist.txt"
	echo " "
	cd ~/VulnerMapper
	
  	### FIGLET INSTALLATION
	# install figlet for aesthetic purposes
	# create a directory for downloading the figlet resources
	mkdir figrc
	cd ~/VulnerMapper/figrc
	sudo apt-get -y install figlet
	# install cybermedium figlet font; credits: http://www.figlet.org
	wget http://www.jave.de/figlet/fonts/details/cybermedium.flf
	cd ~/VulnerMapper
	
	### CORE APPLICATIONS INSTALLATION
	# install relevant applications
	sudo apt-get -y install nmap
	sudo apt -y install exploitdb
	sudo apt-get -y install hydra
	
	### END
	# let the user know applications are installed
	echo " "
	echo "[+] Applications installed and updated."
	echo "	"
}

#######################
### NMAP_SCAN FUNCTION
#######################

### DEFINITION

function NMAP_SCAN()
{ 
        ### START
        echo " "
        echo "[*] EXECUTION OF NMAP_SCAN MODULE:"
        echo " "
        echo "[*] Scanning $netrange on ports 0-65535...(This may take a long time)"
        echo " "
    
        ## SCANNING
        # execute nmap scan with -Pn flag to avoid firewall
		# save the scan output in greppable format for text manipulation later
        sudo nmap -Pn -T4 -p0-65535 $netrange -oG nmap_scan.txt 2>/dev/null 
        
        ### END
        # let user know that the scan is done
        echo " "
        echo "[+] Nmap Scan has been executed."
        echo " "
}

#######################
### NMAP_ENUM FUNCTION
#######################

### DEFINITION

function NMAP_ENUM()
{
	### START
	echo " "
	echo "[*] EXECUTION OF NMAP_ENUM MODULE:"
	echo " "
	echo "[*] Parsing output data from NMAP_SCAN Module..."
	echo " "
	echo "[*] Executing Nmap Scripting Engine Enumeration on open ports and services for $netrange...(This may take a long time)"
	echo " "
	
	### HOST FILTERING
	# manipulate greppable output to create list of open hosts
	echo $(cat nmap_scan.txt | grep Ports: | grep open | awk '{print $2}') > nmap_openhosts.lst

	### ENUMERATION LOOP
	# for each open host, filter and manipulate the data of open ports, then pass it as input for a standard NSE script to enumerate the host
	
	for openhost in $(cat nmap_openhosts.lst)
	do
		### FILTERING: HOST
		echo " "
		echo "[*] Enumerating $openhost......"
		echo " "
		# filter the single-line data of the open host from the greppable scan output
		echo $(cat nmap_scan.txt | grep Ports: | grep open | grep $openhost) 2>/dev/null > linedata.txt
		
		### FILTERING: PORTS
		# extract a list of open ports by susbtituting space with line break, then filtering the port numbers
		echo $(cat linedata.txt | tr " " "\n" | grep open | awk -F/ '{print $1}') 2>/dev/null > openports.lst
		
		### TEXT  MANIPULATION
		# convert the list into string, with the ports separated by commas for input later
		portsstring=$(echo "$(cat openports.lst | tr " " "," | tr -d " ")")
		
		### ENUMERATION
		# execute standard NSE script (-sC) with version detection (-sV) for all for the open ports for each open host
		sudo nmap -sC -sV -p$portsstring -T4 $openhost -oX ${openhost}_enum.xml -oN ${openhost}_enum.txt 2>/dev/null 
		
		### CLEAN-UP
		# remove the temporary lists to avoid overcrowding the directory (especially for large network range and multiple open ports)
		rm linedata.txt
		rm openports.lst
		
	done
	
	### END
        # let user know that the enumeration is done
        echo " "
        echo "[+] Nmap Scripting Engine Enumeration has been executed."
        echo " "
}

###############################
### SEARCHSPLOIT_VULN FUNCTION
###############################

### DEFINITION

function SEARCHSPLOIT_VULN()
{
	### START
    echo " "
    echo "[*] EXECUTION OF SEARCHSPLOIT_VULN MODULE:"
	echo " "
	echo "[*] Parsing output data from NMAP_ENUM Module..."
	echo " "
	echo "[*] Executing Searchsploit Vulnerability Detection on enumerated hosts and services......(This may take a long time)"
	echo " "
	
	### VULNERABILITY DETECTION LOOP
	# for each open host, execute Searchsploit on its enumerated XML file to detect its vulnerabilities
	
	for openhost in $(cat nmap_openhosts.lst)
	
	do
		echo "[*] Detecting vulnerabilities on the services running on $openhost......"
		echo " "
		sudo searchsploit -x -v --nmap ${openhost}_enum.xml 2>/dev/null > ${openhost}_vuln.txt
		
	done
	
	### END
        # let user know that the detection is done
        echo " "
        echo "[+] Searchsploit Vulnerability Detection has been executed."
        echo " "
}

#########################
### HYDRA_BRUTE FUNCTION
#########################

### DEFINITION

function HYDRA_BRUTE()
{
	### START
    echo " "
    echo "[*] EXECUTION OF HYDRA_BRUTE MODULE:"
    echo " "
    echo "[*] Parsing output data from NMAP_SCAN Module..."
    echo " "
	echo "[*] Executing Hydra Brute-Force Attack on open hosts and ports......(This may take a long time)"
	echo " "
	
	### BRUTE-FORCE LOOP
	# for each open host, filter and manipulate the data of open services, then pass it as input for the brute-force attack
	
	for openhost in $(cat nmap_openhosts.lst)
	
	do
		### FILTERING: HOST
		echo " "
		echo "[*] Attacking $openhost......"
		echo " "
		# filter the single-line data of the open host from the greppable scan output
		echo $(cat nmap_scan.txt | grep Ports: | grep open | grep $openhost) > linedata.txt
		# create text file to store extracted passwords
		touch ${openhost}_passwords.txt
		
		### FILTERING: SERVICES
		# extract a list of open services by susbtituting space with line break, then filtering the services
		echo $(cat linedata.txt | tr " " "\n" | grep open | tr "/" " " | awk '{print $4}') > openservices.lst		
      	
      	### BRUTE-FORCE ATTACK
      	# brute-force through all the open services for this open host
		for openservice in $(cat openservices.lst)
		do
			echo "[*] Attacking $openservice on $openhost......"
			echo " "
			WordList=~/VulnerMapper/wordlist.txt
			sudo hydra -f -L $WordList -P $WordList $openhost $openservice -t 4 vV 2>/dev/null > hydra_brute.txt
			# extract passwords to another file
			echo "$openservice: $(cat hydra_brute.txt | grep host: | awk '{print $4, $5, $6, $7}')" 2>/dev/null >> ${openhost}_passwords.txt
			# remove brute-force raw output to avoid crowding
			rm hydra_brute.txt
		done
		
		### CLEAN-UP
		# remove the temporary lists to avoid overcrowding the directory (especially for large network range and multiple open ports)
		rm linedata.txt
		rm openservices.lst
		
	done
        
	### END
	# let user know that the attack is done
	echo " "
	echo "[+] Hydra Brute-Force Attack has been executed."
	echo " "
}

#################
### LOG FUNCTION
#################

### DEFINITION

function LOG()
{
	### START
	echo " "
	echo "[*] EXECUTION OF LOG MODULE:"
	echo " "
		
	### VULNERABILITY LOGGING LOOP
	# use a for-loop to iterate through the list of open hosts
	for openhost in $(cat nmap_openhosts.lst)
	do
		
		### SUBDIRECTORY
		# create subdirectory for specific host
		cd ~/VulnerMapper/$session/$rangename
		mkdir $openhost
		cd $openhost
		# create log file
		touch ${openhost}_vulnmap.txt
		# insert figlet
		echo "$(figlet -c -f ~/VulnerMapper/figrc/cybermedium.flf -t "VULNERMAPPER")" >> ${openhost}_vulnmap.txtt
		# insert title and date-time
		DateTime=$(echo "$(date +%F) $(date +%X | awk '{print $1}')")
		echo "#########################################################" >> ${openhost}_vulnmap.txt
		echo "VULNERABILITY MAP: $rangename | $DateTime" >> ${rangename}_vulnmap.txt
		echo "#########################################################" >> ${openhost}_vulnmap.txt
		echo " " >> ${openhost}_vulnmap.txt
		echo "[*] Parsing output data from all modules......"
		echo " "
	
		### TOTAL OPEN HOSTS LOGGING
		echo " " >> ${openhost}_vulnmap.txt
		echo "###########" >> ${openhost}_vulnmap.txt
		echo "OPEN HOSTS:" >> ${openhost}_vulnmap.txt
		echo "###########" >> ${openhost}_vulnmap.txt
		echo " " >> ${openhost}_vulnmap.txt
		echo "$(cat nmap_openhosts.lst | tr " " "\n")" >> ${openhost}_vulnmap.txt
		echo " " >> ${openhost}_vulnmap.txt

		### SPECIFIC OPEN HOST HEADER
		echo " " >> ${openhost}_vulnmap.txt
		echo "#####################" >> ${openhost}_vulnmap.txt
		echo "HOST: $openhost" >> ${openhost}_vulnmap.txt
		echo "#####################" >> ${openhost}_vulnmap.txt
		echo " " >> ${openhost}_vulnmap.txt
		
		### OPEN SERVICES DISCOVERY LOGGING
		echo "ENUMERATED SERVICES" >> ${openhost}_vulnmap.txt
		echo " " >> ${openhost}_vulnmap.txt
		echo "-------------------" >> ${openhost}_vulnmap.txt
		# trim irrelevant lines
		echo "$(cat ${openhost}_enum.txt | grep tcp | grep open)" >> ${openhost}_vulnmap.txt
		echo " " >> ${openhost}_vulnmap.txt
		
		### POSSIBLE EXPLOITS LOGGING
		echo "POSSIBLE EXPLOITS" >> ${openhost}_vulnmap.txt
		echo "-----------------" >> ${openhost}_vulnmap.txt
		echo " " >> ${openhost}_vulnmap.txt
		# trim irrelevant lines
		echo "$(cat ${openhost}_vuln.txt)" >> ${openhost}_vulnmap.txt
		echo " " >> ${openhost}_vulnmap.txt
		
		### WEAK PASSWORDS LOGGING
		echo "CRACKED PASSWORDS" >> ${openhost}_vulnmap.txt
		echo "-----------------" >> ${openhost}_vulnmap.txt
		echo " " >> ${openhost}_vulnmap.txt
		echo "$(cat ${openhost}_passwords.txt)" >> ${openhost}_vulnmap.txt
		echo " "
		
		### MAKE A COPY FOR COMBINATION LATER
		cp ${openhost}_vulnmap.txt ~/VulnerMapper/$session/$rangename
		
		### MOVING OF FILES
		cd ~/VulnerMapper/$session/$rangename
		cp nmap_openhosts.lst ~/VulnerMapper/$session/$rangename/$openhost
		mv nmap_scan.txt ~/VulnerMapper/$session/$rangename/$openhost
		mv ${openhost}.enum.xml ~/VulnerMapper/$session/$rangename/$openhost
		mv ${openhost}.enum.txt ~/VulnerMapper/$session/$rangename/$openhost
		mv ${openhost}.vuln.txt ~/VulnerMapper/$session/$rangename/$openhost
		mv ${openhost}.passwords.txt ~/VulnerMapper/$session/$rangename/$openhost
	
	done
	
	### COMBINE ALL INDIVIDUAL OUTPUT FOR TERMINAL OUTPUT
	cd ~/VulnerMapper/$session/$rangename
	echo "$(cat ~/VulnerMapper/$session/$rangename/*_vulnmap.txt)" > ${rangename}.vulnmap.txt
		
	### CLEAN-UP
	# remove the individual output files in the range directory
	rm *_vulnmap.txt
	
	### END
	# open combine the individual output for terminal output
	cat ${rangename}_vulnmap.txt
	echo " "
	echo "[+] VULNERABILITY MAP REPORT:"
	echo " "
	echo "	[*] Scroll up to view the terminal output of all discovered hosts."
	echo "	[*] View the individual reports of discovered hosts at their individual subdirectories in ~/VulnerMapper/$session/$rangename"
	echo " "
}

###################
# CONSOLE FUNCTION
###################

### DEFINITION

function CONSOLE()
{		
	### INSTALLATION CHECK
	# check to see if installations and configuration have already been done
	echo " "
	read -p "[!] INSTALLATION CHECK:
	
	[*] Enter 'y' key to install all relevant applications and configurations
	[*] Enter 'n' key to skip installation (if you have installed previously)
	
	[!] Enter Option: " answer
	
	# process options through 'if' conditional flow
	# if already installed, head to directory directly
	if [ $answer == "n" ] 
	then
		cd ~/VulnerMapper
		continue 2>/dev/null 
	# if not,call the INSTALL function
	else
		if [ $answer == "y" ] 
		then
			echo " "
			INSTALL
			continue 2>/dev/null 
		fi
	fi
	
	### CONSOLE DISPLAY
	# display figlet for aesthetics, with short description of program
	echo " "
	figlet -c -f ~/VulnerMapper/figrc/cybermedium.flf -t "VULNERMAPPER"
	# description of functions
	echo " "
	echo "[*] IMPORTANT NOTICE:"
	echo "This program is for mapping vulnerabilities of all hosts within a local network. Please use for penetration testing and education purposes only."
	echo " "
	echo "[*] RAPID TESTING CONFIGURATION:"
	echo "For quick testing, configure the target machines to have the user and password as 'kali'."
	echo " "
	echo "[!] EXIT:"
	echo "Press Ctrl-C to exit."
	echo " "
	
	### START OF SESSION
	echo " "
	read -p "[!] START OF SESSION:
	
	[!] Enter Session Name: " session
	echo " "
	cd ~/VulnerMapper
	mkdir $session
	cd ~/VulnerMapper/$session
	
	### NETWORK RANGE INPUT
	read -p "
	[!] Enter Target Network Range (e.g. 192.168.235.0/24): " netrange
	echo " "
	# create directory with the network range specified 
	net=$(echo $netrange | awk -F/ '{print $1}')
	mask=$(echo $netrange | awk -F/ '{print $2}')
	rangename=${net}_${mask}
	mkdir $rangename
	cd ~/VulnerMapper/$session/$rangename
	echo "	[+] Directory created: ~/VulnerMapper/$session/$rangename"
	echo " "
	echo " "
	echo " "
	echo "[*] EXECUTION OF VULNERMAPPER CORE MODULES"
	echo " "
	echo "[*] Mapping the range $netrange......"
	echo " "
	
	### CORE EXECUTION
	# call the core functions to map the specified local network range
	NMAP_SCAN
	NMAP_ENUM
	SEARCHSPLOIT_VULN
	HYDRA_BRUTE
	LOG
	# EXPLOIT (under development)
	
	### END
	# force a pause to allow the user to focus on the results
	read -p "[!] END OF SESSION:
	
	[*] Enter 'y' key to return to the console
	[*] Enter any other key to exit
	
	[!] Enter option: " option
	echo " "
	
	# process options through 'if' conditional flow
	if [ $option == "y" ]
	then
		continue 2>/dev/null 
	else
		exit
	fi		
}

### CONSOLE EXECUTION
# call the CONSOLE function through while-true loop to return user to the console after every execution
while true 
do
CONSOLE
done
