i=0
(while [ $((i <= 100)) '=' 1 ]
do
i=$(cat /tmp/percent)
    echo $i
    echo "#Processing ... $i %"
done) | yad --progress --center --width=240 --auto-kill --auto-close --button=gtk-cancel:"touch /tmp/stop" --title="moRFeus" 
echo "100" > /tmp/percent
echo "S" > /tmp/stop
kill $(echo $(pidof progressbar.sh))
