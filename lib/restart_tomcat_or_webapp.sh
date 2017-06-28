#! /bin/bash

# get the environment varaibles from the config file
. config/webtop_deploy_config

# check if the webtop app name is exist or not
if [[ $# != 2 ]] ; then
	echo 'Please input the webtop app name'
	exit
fi


appURL=$webtopHost$1
appDir=${tomcatDir}webapps/$1

# shutdown tomcat
if [[ $2 == 'stop' ]] ; then
	echo 'shut down tomcat'
	kill -9 $(ps -ef | grep $tomcatProcess | grep -v grep | awk '{print $2}')
	exit
fi


# start tomcat
if [[ $2 == 'start' ]]; then
	echo 'start tomcat'
	$tomcatDir/bin/catalina.sh start
	exit 
fi

# restart webapp
if [[ $2 == 'restart' ]]; then
	echo 'restart web apps '$1
	curl --user $tomcatManager:$tomcatManagerPwd ${webtopHost}manager/text/stop?path=/$1
	curl --user $tomcatManager:$tomcatManagerPwd ${webtopHost}manager/text/start?path=/$1
fi


# stop webapp
if [[ $2 == 'appStop' ]]; then
        echo 'stop web apps '$1
        curl --user $tomcatManager:$tomcatManagerPwd ${webtopHost}manager/text/stop?path=/$1
fi

# start webapp
if [[ $2 == 'appStart' ]]; then
        echo 'start web apps '$1
        curl --user $tomcatManager:$tomcatManagerPwd ${webtopHost}manager/text/start?path=/$1
fi

