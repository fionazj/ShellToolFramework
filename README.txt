The script is for UIA team to deploy war package automatically

The script can deploy the war by get war from remote server, or install in local, or just update configuraion

################################
How to use main.sh
1. Download the project to the webtop machine
2. Config your server info in config/webtop_deploy_config file
3. How to exectuive the script:
 1) ./main.sh http://******.war	------- deploy the war from remote server , update config info , and restart tomcat
 2) ./main.sh ****.war		-------	deploy the war from local and update config info, and restart tomcat	
 3) ./main.sh *******		------- update config info and restart the specific webapp



