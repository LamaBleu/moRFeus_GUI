#!/bin/bash

# GUI for moRFeus (Outernet) tool
# for moRFeus device v1.6 - LamaBleu 04/2018
#
# As pre-requisite you have to install yad package (sudo apt-get install yad)
# Download and copy this script on a directory.
# Download morfeus_tool executable from Outernet website: https://archive.outernet.is/morfeus_tool_v1.6/
# Choose the right version, adapted to your platform. ! (Linux-32 & 64b, ARM)
# Copy the tool to the same directory. RENAME it 'morfeus_tool' ! 
# No needs to change files owner.If needed make all files executable (cd to directory then 'chmod +x *')


#  !!!!!! IMPORTANT !!!!!!
# You need to have enoug privileges to communicate with the device so launch the UI 
# by typing : "gksudo <path_to_file>/morfeus_gui" or " sudo <directory_path>/GUI_moRFeus.sh"

# Do not forget to rename the executable 'morfeus_tool'

# Path to moRFeus directory (to morfeus_tool and this script). Adapt to your own needs. 
# (Replacing $HOME by the real path works better).

# ADAPT !
export morf_tool_path=$HOME/GUI_moRFeus/

# If all is OK you will find an empty 'testfile' in the moRFeus directory, along the other files.


function on_click () {
yad --about 
}
export -f on_click

function generator () {
$morf_tool_path/morfeus_tool Generator
}
export -f generator

function close_exit(){
#    echo "close and exit"
    kill -USR1 $YAD_PID
}
export -f close_exit


function setfreq () {

freq_morf=${status_freq::-4}
freq_morf_a="${freq_morf/$'.'/}"

INPUTTEXT=`yad --center --center --title="set Frequency" --form --text="  Now : $freq_morf" --field="Number:NUM" $freq_morf_a'\!85e6..5.4e9\!1000\!0 2>/dev/null'`  
INPUTTEXT1=${INPUTTEXT%,*}

$morf_tool_path/morfeus_tool setFrequency $INPUTTEXT1
echo "setFrequency : "$INPUTTEXT1"  , "
close_exit

}
export -f setfreq


function setcurrent () {
INPUTTEXT=`yad --center --title="set Power" --form --field="Power:CB" $status_current'!0!1!2!3!4!5!6!7' 2>/dev/null`  
INPUTTEXT1=${INPUTTEXT%,3*}
echo "setCurrent : "$INPUTTEXT1"  , "

$morf_tool_path/morfeus_tool setCurrent $INPUTTEXT1
close_exit

}
export -f setcurrent

function setmixer () {

$morf_tool_path/morfeus_tool Mixer 
echo "setMixer,  "
close_exit

}
export -f setmixer

function setgenerator () {

$morf_tool_path/morfeus_tool Generator 
echo "setGenerator  ,"
close_exit

}
export -f setgenerator



function mainmenu () {



export morf_tool
status_mode=$($morf_tool_path/morfeus_tool getFunction)
status_current=$($morf_tool_path/morfeus_tool getCurrent)
status_freq=$($morf_tool_path/morfeus_tool getFrequency)
freq_morf=${status_freq::-4}
freq_morf_a="${freq_morf/$'.'/}"
export status_freq
export status_current
export freq_morf_a

data="$(yad --center --title="Outernet moRFeus v1.6" --text-align=center --text=" moRFeus control \n by LamaBleu 04/2018 \n" \
--form --field=Freq:RO "$status_freq" --field="Mode:RO" "$status_mode" --field="Power:RO"  "$status_current"  \
--field=:LBL "" --field="set Generator mode:FBTN" "bash -c setgenerator"  \
--field="set Mixer mode:FBTN" "bash -c setmixer" --form --columns=1 \
--field="Set frequency:FBTN" "bash -c setfreq" \
--field="Set current:FBTN" "bash -c setcurrent" "" "" "" "" "" "" "" "" \
--button="Step generator:3" --field=:LBL "" --button="Refresh:0" --button="Quit:1" 2>/dev/null)"  

ret=$?
#echo $ret
export ret



if [[ $ret -eq 3 ]]; then

stepper="$(yad  --center --title="Start End" --form --text="  Now : $freq_morf" --field="Start_freq:NUM" $freq_morf_a'\!85e6..5.4e9\!10000\!0' \
--field="Stop_freq:NUM" $freq_morf_a'\!85e6..5.4e9\!10000\!0' \
--field="Step Hz:NUM" 1000\!1..1e9\!100000\!0 --field="Hop (s.):NUM" 5\!0.1..3600\!0.1\!1 "" "" "" "" 2>/dev/null)"

#INPUTTEXT=`yad --center --center --title="set Frequency" --form --text="  Now : $freq_morf" --field="Number:NUM" $freq_morf_a'\!85e6..5.4e9\!1000\!0 2>/dev/null'`


stepper_start=$(echo $(echo $(echo "$stepper" | cut -d\| -f 1)))
stepper_stop=$(echo $(echo $(echo "$stepper" | cut -d\| -f 2)))
stepper_step=$(echo $(echo $(echo "$stepper" | cut -d\| -f 3)))
stepper_hop=$(echo $(echo $(echo "$stepper" | cut -d\| -f 4)))

stepper_start_in="${stepper_start::-7}"
stepper_stop_in="${stepper_stop::-7}"
stepper_step_in="${stepper_step::-7}"
stepper_hop_dec="${stepper_hop::-4}"
stepper_start_int=$(($stepper_start_in))
stepper_stop_int=$(($stepper_stop_in))
stepper_step_int=$(($stepper_step_in))

echo "Fstart: "$stepper_start_int "Fend: " $stepper_stop_int "Step Hz:  "$stepper_step_int "Hope-time s. :  "$stepper_hop_dec 


morf_tool=$morf_tool_path/morfeus_tool
morf_tool Generator
$morf_tool setCurrent 1



i=$((stepper_start_int))
end=$(($stepper_stop_int))

while [ $i -le $end ]; do
   echo "Freq:  " $i
	$morf_tool setFrequency $i
    i=$(($i+$stepper_step_int))
   sleep $stepper_hop_dec

done
echo "Stepper end.    "
sleep 1

yad  --center --title "moRFeus stepper " --center --text="Done !" 2>/dev/null


fi

echo $data
#echo $ret
}


# Establish run order
main() {
 #!/bin/bash
while :
do
mainmenu
#echo $ret

if [[ $ret -eq 1 ]];
   then
	break       	   #Abandon the loop. (quit button)
   fi
if [[ $ret -eq 127 ]];
   then
	break       	   #Abandon the loop. (error)
	fi
if [[ $ret -eq 252 ]];
   then
	break       	   #Abandon the loop. (close mainwindow)
   fi
done  
}
export -f mainmenu
main



