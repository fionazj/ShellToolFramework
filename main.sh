#! /bin/bash


typeset flag=0
# get the environment varaibles from the config file
. config/webtop_deploy_config

# check if the webtop app name is exist or not
if [[ $# != 1 ]] ; then
	echo 'Please input the webtop app name'
	exit
fi

user=$(whoami)
if [[ $user == "root" ]]; then
        echo "Please DO NOT run this tool as ROOT"
        exit 1
fi


# check if the log dir exists or not
if [[ ! -d log ]] ; then
	mkdir log
fi

# check if the build dir exists or not
if [[ ! -d $buildDir ]]; then
        mkdir -p $buildDir
fi


# define the web app url and app directory
appURL=$webtopHost$1
appDir=${tomcatDir}webapps/$1

# get war from remote server
if [[ $1 == http* ]] ; then
	echo 'Get the war package from build server ' $1
	flag=1
	wget -P $buildDir $1 > log/download.log 2>&1
	war=$(cat log/download.log | grep saved | awk -F \' '{print $2}' | awk -F \' '{print $1}' | awk -F / '{print $NF}')

# get war from local
elif [[ $1 == *war ]] ; then
	flag=2
	echo 'Get war from local'
	war=$(ls -ltr $buildDir*.war | awk -F '/' {'print $NF'} | tail -1 )
	version=$(echo ${new_war%.*} | awk -F 'se-' {'print $NF'})
	#war=${new_war}_${version}
fi

# unzip war if needed
if [[ flag -ne 0 ]] ; then
	version=$(echo ${war%.*} | awk -F 'se-' '{print $NF}')
	appDir=${tomcatDir}webapps/ux2.2_$version
	rm -rf ${tomcatDir}webapps/ux2.2_$version
	unzip $buildDir$war -d $appDir > log/unzip.log 2>&1
fi

sudo chmod 755 $appDir
sudo chown -R imail1:imail $appDir

# stop tomcat if deploy a new war
if [[ flag -ne 0 ]]; then
	./lib/restart_tomcat_or_webapp.sh $1 'stop'
fi

# back up for webtop config
echo 'back up for webtop config'
cp $appDir/WEB-INF/classes/config/webtop-config.xml $appDir/WEB-INF/classes/config/webtop-config_backup.xml

# update webtop config
if [[ flag -eq 0 ]]; then
	./lib/update_webtop_config_cpms.sh $1
else
	./lib/update_webtop_config_cpms.sh ux2.2_$version
fi

# restart webapps or start tomcat
if [[ flag -eq 0 ]] ; then
	./lib/restart_tomcat_or_webapp.sh $1 'restart'
else
	./lib/restart_tomcat_or_webapp.sh $1 'start'
fi

echo 'the url is :' ${appURL}

