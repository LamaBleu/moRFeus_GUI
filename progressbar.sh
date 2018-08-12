
#!/bin/bash
rm /tmp/stop
#echo $(cat /tmp/percent) | yad --progress --percentage=0

i=$(cat /tmp/percent)
(while [ $((i <= 100)) '=' 1 ]
do
i=$(cat /tmp/percent)
    echo $i
    echo "#Processing ... $i %"
    sleep 1
#    i=$((i + 5))
done) | zenity --progress --auto-close --title="moRFeus" 
sleep 2
echo S > /tmp/stop
