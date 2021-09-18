
#!/bin/bash

# Public IP address of the BBB server
PUBLIC_IP="37.152.167.14"

# Pull in the helper functions for configuring BigBlueButton
source /etc/bigbluebutton/bbb-conf/apply-lib.sh

enableUFWRules

echo "Running three parallel Kurento media server"
enableMultipleKurentos

echo "Make the HTML5 client default"
sed -i 's/attendeesJoinViaHTML5Client=.*/attendeesJoinViaHTML5Client=true/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
sed -i 's/moderatorsJoinViaHTML5Client=.*/moderatorsJoinViaHTML5Client=true/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "Set Welcome message"
sed -i 's/defaultWelcomeMessage=.*/defaultWelcomeMessage=Welcome to <b>\%\%CONFNAME\%\%<\/b>\!/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
sed -i 's/defaultWelcomeMessageFooter=.*/defaultWelcomeMessageFooter=Use a headset to avoid causing background noise.<br>Refresh the browser in case of any network issue./g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "Let Moderators unmute users"
sed -i 's/allowModsToUnmuteUsers=.*/allowModsToUnmuteUsers=true/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "See other viewers webcams"
sed -i 's/webcamsOnlyForModerator=.*/webcamsOnlyForModerator=false/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "Don't Mute the class on start"
sed -i 's/muteOnStart=.*/muteOnStart=true/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "Saves meeting events even if the meeting is not recorded"
sed -i 's/keepEvents=.*/keepEvents=true/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "Set maximum users per class to 300"
sed -i 's/defaultMaxUsers=.*/defaultMaxUsers=300/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "Disable private chat"
sed -i 's/lockSettingsDisablePrivateChat=.*/lockSettingsDisablePrivateChat=false/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "Disable public chat"
sed -i 's/lockSettingsDisablePublicChat=.*/lockSettingsDisablePublicChat=false/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "Disable shared note"
sed -i 's/lockSettingsDisableNote=.*/lockSettingsDisableNote=false/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

# Enabeling this may create audio issue in 2.2.29
echo "Enable mic";
sed -i 's/lockSettingsDisableMic=.*/lockSettingsDisableMic=false/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "See other users in the Users list"
sed -i 's/lockSettingsHideUserList=.*/lockSettingsHideUserList=false/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "Prevent viewers from sharing webcams"
sed -i 's/lockSettingsDisableCam=.*/lockSettingsDisableCam=true/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "Prevent users from joining classes from multiple devices"
sed -i 's/allowDuplicateExtUserid=.*/allowDuplicateExtUserid=true/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "End the meeting when there are no moderators after a certain period of time. Prevents students from running amok."
sed -i 's/endWhenNoModerator=.*/endWhenNoModerator=false/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "Set maximum meeting duration to 360 minutes"
sed -i 's/defaultMeetingDuration=.*/defaultMeetingDuration=360/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "Enable listen only mode"
sed -i 's/listenOnlyMode:.*/listenOnlyMode: true/g' /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml

echo "Enable audio check otherwise may face audio issue"
sed -i 's/skipCheck:.*/skipCheck: false/g' /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml

echo "Set Client Title"
sed -i 's/clientTitle:.*/clientTitle: IASBS/g' /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml

echo "Set App Title"
sed -i 's/appName:.*/appName: IASBS E-Learning/g' /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml

echo "Set Copyright"
sed -i 's/copyright:.*/copyright: "©2021 IASBS-CC"/g' /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml

echo "Set Helplink"
sed -i 's~helpLink:.*~helpLink: http://iasbs.ac.ir/iasbs-elearn~g' /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml

echo "Set Copyright in Playback"
sed -i "s/defaultCopyright = .*/defaultCopyright = \'<p>IASBS.ac.ir<\/p>\';/g" /var/bigbluebutton/playback/presentation/2.0/playback.js

echo "Fix for 1007 and 1020 - https://github.com/manishkatyan/bbb-optimize#fix-1007-and-1020-errors"
xmlstarlet edit --inplace --update '//profile/settings/param[@name="ext-rtp-ip"]/@value' --value "\$\${external_rtp_ip}" /opt/freeswitch/etc/freeswitch/sip_profiles/external.xml
xmlstarlet edit --inplace --update '//profile/settings/param[@name="ext-sip-ip"]/@value' --value "\$\${external_sip_ip}" /opt/freeswitch/etc/freeswitch/sip_profiles/external.xml
xmlstarlet edit --inplace --update '//X-PRE-PROCESS[@cmd="set" and starts-with(@data, "external_rtp_ip=")]/@data' --value "external_rtp_ip=$PUBLIC_IP" /opt/freeswitch/etc/freeswitch/vars.xml
xmlstarlet edit --inplace --update '//X-PRE-PROCESS[@cmd="set" and starts-with(@data, "external_sip_ip=")]/@data' --value "external_sip_ip=$PUBLIC_IP" /opt/freeswitch/etc/freeswitch/vars.xml