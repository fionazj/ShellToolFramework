#! /bin/bash

# get the environment varaibles from the config file
. ./config/webtop_deploy_config

# check if the webtop app name is exist or not
if [[ $# != 1 ]] ; then
	echo 'Please input the webtop app name'
	exit
fi

appURL=$webtopHost$1
appDir=${tomcatDir}webapps/$1

# update webtop config
echo '*********************************************************************************************'
echo '	update webtop configurations 	'
echo '*********************************************************************************************'
sed -i "s#secret#password#g" $appDir/WEB-INF/classes/config/webtop-config.xml
sed -i "s#rwc-ux01.owmessaging.com#$ldapHost#g" $appDir/WEB-INF/classes/config/webtop-config.xml
sed -i "s#dc=acme,#dc=ux21-core-cpms001-imail1-20151122-232251,#g" $appDir/WEB-INF/classes/config/webtop-config.xml
sed -i "s#,dc=com#,dc=net#g" $appDir/WEB-INF/classes/config/webtop-config.xml
sed -i "s#base=\"dc=acme\"#base=\"dc=ux21-core-cpms001-imail1-20151122-232251,dc=nplex,dc=net\"#g" $appDir/WEB-INF/classes/config/webtop-config.xml
sed -i "s#rwc-hinoki06:8081/webtop-media#$mediaServerHost:$mediaServerPort/mediatranscoder-1.1.8.0/#g" $appDir/WEB-INF/classes/config/webtop-config.xml
sed -i "111s#maxuploadsize value=\".*\"#maxuploadsize value=\"14m\"#" $appDir/WEB-INF/classes/config/webtop-config.xml
sed -i "s#maxAddresses=\".*\"#maxAddresses=\"9\" keepCopy=\"true\" sendAsAttachment=\"true\"#g" $appDir/WEB-INF/classes/config/webtop-config.xml
sed -i "s#store protocol=\"imap\" host=\".*\" port=\".*\"#store protocol=\"imap\" host=\"$imapHost\" port=\"$imapPort\" starttls=\"false\"#g" $appDir/WEB-INF/classes/config/webtop-config.xml
sed -i "s#transport protocol=\"smtp\" host=\".*\" port=\".*\"#transport protocol=\"smtp\" host=\"$smtpHost\" port=\"$smtpPort\" auth=\"true\" starttls=\"false\"#g" $appDir/WEB-INF/classes/config/webtop-config.xml
sed -i "s#allowCalDomain value=\".*\"#allowCalDomain value=\"synchronoss.cn,irapoint.qa.laszlosystems.com,test.com,openwave.com\"#g" $appDir/WEB-INF/classes/config/webtop-config.xml
sed -i "1394s#maxuploadsize value=\".*\"#maxuploadsize value=\"9m\"#g" $appDir/WEB-INF/classes/config/webtop-config.xml
sed -i "s#calDavServer host=\".*\" port=\".*\"#calDavServer host=\"$calHost\" port=\"$calPort\" webappContext=\"/calendars\" trashEnabled=\"true\" proxyHost=\"$calHost\" proxyPort=\"$calPort\" caldavAuthenticateAsAdmin=\"true\" httpMaxConnectionsPerHost=\"2\" httpMaxTotalConnections=\"200\" httpConnectionTimeout=\"1m\" httpSocketTimeout=\"1m\" idleTimerRate=\"2m\" idleTimeout=\"20s\"#g" $appDir/WEB-INF/classes/config/webtop-config.xml
sed -i "s#publicWebcalUrl base=\".*\"#publicWebcalUrl base=\"http://$calHost:$calPort/calendars/\"#g" $appDir/WEB-INF/classes/config/webtop-config.xml
sed -i "s#rsvp url=\"http://.*:*\"#rsvp url=\"$appURL/rsvp\"#g" $appDir/WEB-INF/classes/config/webtop-config.xml
sed -i "s#soft=\"20m\"#soft=\"40m\"#g" $appDir/WEB-INF/classes/config/webtop-config.xml
sed -i "s#shareCalendar url=\"http://.*:.*/*\"#shareCalendar url=\"$appURL/http/shareCalendar\"#g" $appDir/WEB-INF/classes/config/webtop-config.xml

