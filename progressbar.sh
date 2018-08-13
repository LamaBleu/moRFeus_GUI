
#!/bin/bash
rm /tmp/stop
#echo $(cat /tmp/percent) | yad --progress --percentage=0
i=0
#i=$(cat /tmp/percent)
(while [ $((i <= 100)) '=' 1 ]
do
i=$(cat /tmp/percent)
    echo $i
    echo "#Processing ... $i %"
    sleep 0.5
#    i=$((i + 5))
done) | zenity --progress --auto-close --title="moRFeus" 
echo S > /tmp/stop
