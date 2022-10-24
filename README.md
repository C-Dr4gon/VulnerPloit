# VulnerPloit

![image](https://user-images.githubusercontent.com/103941010/197491063-a85a8bb2-c58c-45c6-9a5d-d089d72098ba.png)

This is a penetration testing program, written in shell script, to automate the scanning, enumeration, vulnerability assessment and exploitation of local network devices.

The brute-force attack will take a long time. If you just want to test if this program works, set your user and password as "kali" for the hosts in the local target network.

## MODULES

INSTALL(): automatically installs relevant applications and creates relevant directories

CONSOLE(): collects user input for session name and network range, creates new directory, and executes the subsequent core functions

NMAP_SCAN(): uses Nmap to scan for ports and services, and saves information into directory

NMAP_ENUM(): uses Nmap Scripting Engine (NSE) to conduct further enumeration of hosts, based on scan results

SEARCHSPLOIT_VULN(): uses Searchsploit to identify vulnerabilities and potential exploits based on the enumeration results

HYDRA_BRUTE(): uses Hydra to find weak passwords used in the network's login services, based on scan results

MSF_EXPLOIT(): uses Metasploit Framework (MSF) to import and execute the exploits identified by Searchsploit (ruby scripts only)

LOG(): shows the user the collated results of NMAP_SCAN(), NMAP_ENUM(), SEARCHSPLOIT_VULN(), HYDRA_BRUTE() and EXPLOIT() 

## EXECUTION

Execute VulnerMapper.sh with bash to start the script.

    $ bash VulnerPloit.sh

## INSTALL()

The user will be asked to either install relevant applications or skip to the console. if applications are already installed previously.

![image](https://user-images.githubusercontent.com/103941010/197487629-b905259c-6a92-4cbd-8fb4-f4c0c937906e.png)

## CONSOLE()

After installation or skipping installation, the user will arrive at a console for the user to key in the session name and network range. After that, the core modules will be executed on the network range.

![image](https://user-images.githubusercontent.com/103941010/197487778-2ce21c2e-a424-4c47-8c0c-437ea6b9365a.png)

The subdirectory for the session and then the network range will be created to store output files.

![image](https://user-images.githubusercontent.com/103941010/197488341-a4f2948d-c574-4908-b756-d59b4127ad2f.png)


## NMAP_SCAN()

The program will use nmap to scan for open ports and services in the target range and log results. This will take a long time if you have a large range of hosts.

![image](https://user-images.githubusercontent.com/103941010/197488811-82be8a8e-fb29-4fd4-ae81-e28a95c931cd.png)


## NMAP_ENUM(

The program will use Nmap Scripting Engine (NSE) to to conduct further enumeration of hosts, based on scan results.

![image](https://user-images.githubusercontent.com/103941010/197489170-8e534aab-e238-4469-9843-cfc261b40c0a.png)

## SEARCHSPLOIT_VULN()

The program will use Searchsploit to identify vulnerabilities and potential exploits based on enumeration results.

![image](https://user-images.githubusercontent.com/103941010/197489222-c3e2d323-456e-4a99-82d0-fcd1bfeeaa53.png)

## HYDRA_BRUTE()

The program will use Hydra to find weak passwords used in the network's login services, based on the vulnerability results.

![image](https://user-images.githubusercontent.com/103941010/197489343-0a6fb8b4-ca47-4fe6-88b9-c6f3c2add915.png)

### MSF_EXPLOIT()

The program will use Metasploit Framework (MSF) to import and execute exploits from exploitdb, as identified by Searchsploit. This only applies to modules written in Ruby script. For the exploits written in text or other scripting languages, manual exploitation has to be done. 

![image](https://user-images.githubusercontent.com/103941010/197489820-b12b2e63-a9fe-40af-b74c-18ccbbc3c63c.png)

For this example, no ruby exploits were identified, and the output is therefore empty.

## LOG()

The program will aggregate the collated results of NMAP_SCAN(), NMAP_ENUM(), SEARCHSPLOIT_VULN(), HYDRA_BRUTE() and MSF_EXPLOIT() after their execution. For this example, no ruby exploit modules from exploitdb were identified, and the MSF_EXPLOIT output is therefore empty. The identified exploits require manual exploitation.

![image](https://user-images.githubusercontent.com/103941010/197489972-fd5f9cdf-3753-4361-9936-3aa50f5d361b.png)

The program will generate "Vulnerability Map" reports on the terminal and inside the subdirectories of the individual hosts. For this example, the SSH servic everson was detected, and the potential exploits for the version were shown. These exploits are not written in Ruby and need to be manually executed, therefore the MSF automatic exploitation shows no output. The login username and password are also cracked as "kali".

![image](https://user-images.githubusercontent.com/103941010/197491158-dca0d3d3-3195-438e-9985-077f2dc0c16f.png)


Output files are channelled away to different subdirectories based on their hosts for clean look.

![image](https://user-images.githubusercontent.com/103941010/197491212-59617093-d02b-4e03-8a75-c0dcd77737cf.png)

![image](https://user-images.githubusercontent.com/103941010/197491264-0e9a5512-16b8-4a81-9a04-564b49b8b42a.png)

Raw output can be accessed inside the subdirectory.

![image](https://user-images.githubusercontent.com/103941010/197491339-d1addcba-41cb-43fd-aceb-118cc26adfa8.png)


## END

Press 'y' to return to the console (Installation Check) to conduct another mapping session or on another range.

![image](https://user-images.githubusercontent.com/103941010/197492240-9ba600de-a8d0-4f44-8ca5-3c3393472529.png)


Press any other key to exit:





