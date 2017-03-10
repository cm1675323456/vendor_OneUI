#OneUI
while read -r device
do
    add_lunch_combo oneui_$device-userdebug
done < <(curl -s http://downloads.one-teams.com/OneUI_Devices/n)