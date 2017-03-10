#OneUI
deviceList=$(curl -s http://downloads.one-teams.com/OneUI_Devices/n);

IFS=$'\n'
for device in $deviceList  
do
    add_lunch_combo oneui_$device-userdebug
done