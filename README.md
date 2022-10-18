# VulnerPloit

![image](https://user-images.githubusercontent.com/103941010/194728271-c6d2b63e-5b71-46e9-8eb8-12727617cf07.png)

This is a penetration testing program, written in shell script, to automate the scanning, enumeration, vulnerability assessment and exploitation of local network devices.

The brute-force attack will take a long time. If you just want to test if this program works, set your user and password as "kali" for the hosts in the local target network.

## MODULES

INSTALL(): automatically installs relevant applications and creates relevant directories

CONSOLE(): collects user input for session name and network range, creates new directory, and executes the subsequent core functions

NMAP_SCAN(): uses Nmap to scan for ports and services, and saves information into directory

NMAP_ENUM(): uses Nmap Scripting Engine (NSE) to conduct further enumeration of hosts, based on scan results

SEARCHSPLOIT_VULN(): uses Searchsploit to identify vulnerabilities and potential exploits based on the enumeration results

HYDRA_BRUTE(): uses Hydra to find weak passwords used in the network's login services, based on scan results

MSF_EXPLOIT(): uses Metapsploit Framework (MSF) to import and execute the exploits identified by Searchsploit

LOG(): shows the user the collated results of NMAP_SCAN(), NMAP_ENUM(), SEARCHSPLOIT_VULN(), HYDRA_BRUTE() and EXPLOIT() 

## EXECUTION

Execute VulnerMapper.sh with bash to start the script.

    $ bash VulnerPloit.sh

## INSTALL()

The user will be asked to either install relevant applications or skip to the console. if applications are already installed previously.

![image](https://user-images.githubusercontent.com/103941010/194728008-5684961b-3653-4648-b312-6f316a3d7880.png)


## CONSOLE()

After installation or skipping installation, the user will arrive at a console for the user to key in the session name and network range.

![image](https://user-images.githubusercontent.com/103941010/194728197-ae6711b8-8b1c-4574-9fea-bb6cc35a6904.png)

![image](https://user-images.githubusercontent.com/103941010/194727110-f695fc01-f268-4c9d-9f76-9a425a64d975.png)



## NMAP_SCAN()

The program will use nmap to scan for open ports and services in the target range and log results.

![image](https://user-images.githubusercontent.com/103941010/194727130-c07ec799-8c12-4d1b-902d-0a9a5f50a189.png)

![image](https://user-images.githubusercontent.com/103941010/194727133-bf23044d-c62b-4821-8f7c-3607dcd26b4f.png)


## NMAP_ENUM(

The program will use Nmap Scripting Engine (NSE) to to conduct further enumeration of hosts, based on scan results.

![image](https://user-images.githubusercontent.com/103941010/194727141-545b2a6c-7e32-44c9-a275-67015629d22c.png)

![image](https://user-images.githubusercontent.com/103941010/194727145-230b97b1-4bdd-4fe8-a90e-99fd6d17490c.png)


![image](https://user-images.githubusercontent.com/103941010/194727158-162836ac-65ad-4cb9-9e24-010b93833c96.png)

## SEARCHSPLOIT_VULN()

The program will use Searchsploit to identify vulnerabilities and potential exploits based on enumeration results.

![image](https://user-images.githubusercontent.com/103941010/194727165-0ad054ec-3a83-4fca-ba29-ceae31595955.png)

![image](https://user-images.githubusercontent.com/103941010/194727167-f5050396-ddfd-4cd5-b665-8d690e875755.png)


## HYDRA_BRUTE()

The program will use Hydra to find weak passwords used in the network's login services, based on the vulnerability results.

![image](https://user-images.githubusercontent.com/103941010/194728082-86f7c1af-22e3-44e5-80a2-11a2dd3bdbe2.png)

## LOG()

The program will show the user the collated results of NMAP_SCAN(), NMAP_ENUM(), SEARCHSPLOIT_VULN(), HYDRA_BRUTE() and MSF_EXPLOIT() after their execution.

![image](https://user-images.githubusercontent.com/103941010/194728163-fae00a21-315a-464e-b0ee-3ebac716ab81.png)

Vulnerability Map report will be generated both on the terminal and inside the specified directory.

![image](https://user-images.githubusercontent.com/103941010/194729013-6de79604-9701-4dd7-8de5-3bdd4a1870db.png)

![image](https://user-images.githubusercontent.com/103941010/194728979-313e5f91-ae14-400e-80c3-f42c9a6fa264.png)

Output files will be channelled away to different subdirectories based on their hosts for clean look.

![image](https://user-images.githubusercontent.com/103941010/194727199-e66f2428-da12-4cca-a731-bfd94595c33d.png)

![image](https://user-images.githubusercontent.com/103941010/194727193-57e2e1aa-f7ea-4769-ac30-c3099ebd0aef.png)

## END

Press 'y' to return to the console (Installation Check) to conduct another mapping session or on another range.

![image](https://user-images.githubusercontent.com/103941010/194728180-bf181622-9716-44ea-9811-7bb860e216ec.png)

Press any other key to exit:

![image](https://user-images.githubusercontent.com/103941010/194727205-ec65753a-3ed7-4f7e-9868-f138ead2ab85.png)



