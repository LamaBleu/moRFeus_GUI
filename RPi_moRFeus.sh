#!/bin/bash

# GUI for moRFeus (Outernet) tool
# for moRFeus device v1.6 - LamaBleu 04/2018
#
#
# INSTALLATION (Raspberry PI3)
# ========================

# For Raspberry, installation is now automatic.
# The script will download morfeus_tool from Outernet website, and check if packages 'yad' bc' and
# 'socat' are missing.
#
#    git clone https://github.com/LamaBleu/moRFeus_GUI
#    cd moRFeus_GUI
#    chmod +x *.sh
#    gksudo ./RPi_moRFeus.sh


#  !!!!!! IMPORTANT !!!!!!
# As you need to be root to communicate with the device, launch the UI typing from shell : 
#  " gksudo <directory_path>/GUI_moRFeus.sh"




# GQRX support
# ============
# Informations about GQRX: http://gqrx.dk (thanks to Alex for nice and continuous work ;) )

# Adapt parameters (IP,port) in this file to GQRX settings (should be OK by default)
# Use GQRX_IP=127.0.0.1 for local use. Adapt GQRX_IP if GQRX running on a remote computer.


# USAGE:
# =====
# From the main window, you can :
#	- read actual  VFO and LNB_LO values.
#	- transfer the moRFeus freq to the GQRX VFO (generator mode, listen moRFeus signal)
#	- transfer the moRFeus freq to GQRX LNB_LO (moRFeus mixer mode), to display real frequency on GQRX when running mixer mode.
#	- reset GQRX LNB_LO freq. to 0 
#	  GQRX is now the real frequency (mixer + GQRX VFO)
# From the step generator menu, you can send the moRFeus frequency to GQRX or GQRX LNB_LO and so follow the signal. Cool!


# Step Generator notes
# ====================
# Useful to follow the moRFeus signal in stepper mode from GQRX
# Power level (current) can be set.
# Steps can be negative (decremental steps) if F-start > F-end
# Sending freq to GQRX/VFO allow you to follow moRFeus RF signal from GQRX during the stepping-sequence. 
# Try to listen the audio signal (CW mode) of the generator. Very stable and clean !
# Using GQRX 'local or remote) : follow moRFeus steps, retrieve signal level and store values in CSV file.


#
# Known bugs.
# Lot ! The most annoying is pressing "Cancel button" on the step generator window...
# Program runs a little bit slower with GQRX enabled. If you don't use GQRX you can disable the feature on this file.
#
#
#

# Credits goes to Outernet and Alex OZ9AEC to give us so nice tools. Thanks !


#############
##########    Raspberry Pi specific : https://unix.stackexchange.com/a/118826
# To add to /home/pi/.bashrc :
#export XAUTHORITY=~/.Xauthority 


######################
# remote access RDP : xhost
#xhost +
#export DISPLAY=:10.0
#############

#  Path to moRFeus directory (to morfeus_tool and this script).
####### Adapt to real path if not working.
#  Replacing $HOME by full name of directory may help
export morf_tool_path=/home/pi/moRFeus_GUI

if [ ! -f $morf_tool_path/morfeus_tool ]; then
    echo
    echo
    echo "Directory : " $morf_tool_path
    echo "Outernet morfeus_tool not found ! "
    echo "Trying to download armv7 version (raspberry Pi)"
    wget -O $morf_tool_path/morfeus_tool  https://archive.outernet.is/morfeus_tool_v1.6/morfeus_tool_linux_armv7
    ### Tricks 
    chown pi:pi $morf_tool_path/morfeus_tool
    chmod +x $morf_tool_path/morfeus_tool
    chmod +x $morf_tool_path/*.sh
    apt-get install -y yad bc socat
fi

#######
####### GQRX settings - GRQX_ENABLE= to avoid 'connection refused' messages
#######
export GQRX_ENABLE=1
export GQRX_IP=127.0.0.1
export GQRX_PORT=7356


export stepper_step_int=0
export morf_tool
export GQRX_STEP="No"


function on_click () {
yad --about 
}
export -f on_click

function generator () {
$morf_tool_path/morfeus_tool Generator
}
export -f generator

function close_exit(){

    kill -USR1 $YAD_PID
}
export -f close_exit


# sent to GQRX VFO

function gqrx_vfo_send () {
if [[ $GQRX_ENABLE -eq 1 ]];
   then
#echo "gqrx_vfo_send : F "$freq_morf_a
echo "F "$freq_morf_a > /dev/tcp/$GQRX_IP/$GQRX_PORT
setgenerator
fi
}

export -f gqrx_vfo_send

# send to GQRX LNB_LO

function gqrx_lnb_send () {
if [[ $GQRX_ENABLE -eq 1 ]];
   then
#echo "gqrx_lnb_send : LNB_LO "$freq_morf_a
echo "LNB_LO "$freq_morf_a > /dev/tcp/$GQRX_IP/$GQRX_PORT
setmixer
fi
export GQRX_LNB
export freq_morf_a

}

export -f gqrx_lnb_send

function gqrx_lnb_reset () {
if [[ $GQRX_ENABLE -eq 1 ]];
   then
echo "LNB_LO 0 " > /dev/tcp/$GQRX_IP/$GQRX_PORT
fi
GQRX_LNB=0
export GQRX_LNB
close_exit
}

export -f gqrx_lnb_reset


function remote_morfeus_receive () {

#read MESSAGE
echo "TCP receive : " $MESSAGE
$morf_tool_path/morfeus_tool setFrequency  $(($MESSAGE))


}

export -f remote_morfeus_receive


function setfreq () {
freq_morf=${status_freq::-4}
freq_morf_a="${freq_morf/$'.'/}"

INPUTTEXT=`yad  --center --width=270 --title="set Frequency" --form --text="  Now : $freq_morf kHz" --field="Number:NUM" $freq_morf_a'\!85e6..5.4e9\!1000\!0 2>/dev/null'`  
INPUTTEXT1=${INPUTTEXT%,*}

$morf_tool_path/morfeus_tool setFrequency $INPUTTEXT1



export freq_morf_a
#export INPUTTEXT1
close_exit
}
export -f setfreq




function gqrx_get () {
if [[ $GQRX_ENABLE -eq 1 ]];
   then
GQRX_FREQ=$(echo 'f ' | socat stdio tcp:$GQRX_IP:$GQRX_PORT,shut-none 2>/dev/null) 
GQRX_LNB=$(echo 'LNB_LO ' | socat stdio tcp:$GQRX_IP:$GQRX_PORT,shut-none 2>/dev/null)
#echo "GQRX VFO: $GQRX_FREQ   LNB LO: $GQRX_LNB"
else 
echo "GQRX disabled"
fi
export GQRX_FREQ
export GQRX_LNB

}
export -f gqrx_get


function setcurrent () {

INPUTTEXT=`yad --center --width=250 --title="set Power" --form --field="Power:CB" $status_current'!0!1!2!3!4!5!6!7' 2>/dev/null`  
INPUTTEXT1=${INPUTTEXT%,3*}

status_current = INPUTTEXT1
$morf_tool_path/morfeus_tool setCurrent $INPUTTEXT1

export status_current
close_exit

}
export -f setcurrent

function setmixer () {

$morf_tool_path/morfeus_tool setCurrent 0
$morf_tool_path/morfeus_tool Mixer 

close_exit

}
export -f setmixer

function setgenerator () {

$morf_tool_path/morfeus_tool Generator 

close_exit
}
export -f setgenerator



function mainmenu () {

######### get status
#export morf_tool
status_mode=$($morf_tool_path/morfeus_tool getFunction)
status_current=$($morf_tool_path/morfeus_tool getCurrent)
status_freq=$($morf_tool_path/morfeus_tool getFrequency)
freq_morf=${status_freq::-4}
freq_morf_a="${freq_morf/$'.'/}"
export status_freq
export status_current
export freq_morf_a

gqrx_get
#socat -u tcp-l:7777,fork system:'read MESSAGE;$morf_tool_path/morfeus_tool setFrequency  $(($MESSAGE));echo "TCP receive : " $MESSAGE' &
####### main GUI window



data="$(yad --center --title="Outernet moRFeus v1.6" --text-align=center --text=" moRFeus control \n by LamaBleu 04/2018 \n" \
--form --field=Freq:RO "$status_freq" --field="Mode:RO" "$status_mode" --field="Power:RO"  "$status_current"  \
--field=:LBL "" --form --field="Set Frequency:FBTN" "bash -c setfreq" \
--field="set Generator mode:FBTN" "bash -c setgenerator" \
--field="set Mixer mode:FBTN" "bash -c setmixer"  \
--field="Set Power:FBTN" "bash -c setcurrent" --field=:LBL "" \
--field='GQRX control':RO "  IP: $GQRX_IP   Port: $GQRX_PORT"  \
--field='GQRX Freq':RO "VFO: $GQRX_FREQ    LNB LO: $GQRX_LNB " \
--field="Morfeus/Gen. + Freq --> GQRX (VFO):FBTN" "bash -c gqrx_vfo_send" \
--field="Morfeus/Mixer + Freq --> GQRX (LNB LO):FBTN" "bash -c gqrx_lnb_send" \
--field="Reset GQRX LNB LO to 0:FBTN" "bash -c gqrx_lnb_reset" "" "" "" "" "" "" "" "" "" ""  \
--button="Step generator:3"  --button="Refresh:0" --button="Quit:1" 2>/dev/null)"  


#echo " gqrx_enable : "$GQRX_ENABLE
ret=$?


#############
############# step generator


if [[ $ret -eq 3 ]]; then

# we need to switch to generator mode.
$morf_tool_path/morfeus_tool Generator
#$morf_tool_path/morfeus_tool setCurrent 1

#echo "Stepper init Fstart: "$stepper_start_int " Fend: " $stepper_stop_int " Step Hz:  "$stepper_step_int " Hope-time : "$stepper_hop_dec \
#"Power : "$status_current "  GQRX : "$GQRX_STEP

#setting variables in advance i know why ;)
stepper_step_int=10000
stepper_start_int=$freq_morf_a
stepper_step=10000
stepper_start_in=$(echo "$freq_morf_a + 0.000000" | bc)
stepper_stop_in=$(echo "$freq_morf_a + 0.000000" | bc)
stepper_step_in=10000
stepper_hop=5.000000
stepper_hop1=5
stepper="No"
stepper_step="10000"
stepper_start=$(echo "$freq_morf_a + 0.000000" | bc)
stepper_stop=$(echo "$freq_morf_a + 0.000000" | bc)
stepper_stop_int=$freq_morf_a
#$morf_tool_path/morfeus_tool setCurrent 1
############

stepper="$(yad  --center --width=320 --title="start Frequency" --form --text="  Now : $freq_morf kHz" \
--field="Start_freq:NUM" $freq_morf_a'\!85e6..5.4e9\!100000\!0' \
--field="Stop_freq:NUM" $freq_morf_a'\!85e6..5.4e9\!100000\!0' \
--field="Step Hz:NUM" $stepper_step_int'\!0..1e9\!10000\!0' \
--field="Hop (s.):NUM" '5.\!0.5..3600\!0.5\!1' \
--field="Power:CB" $status_current'\!0!1!2!3!4!5!6!7' \
--field="Send Freq to GQRX:CB" $GQRX_STEP'\!No!VFO!LNB_LO'  "" "" "" "" "" "" 2>/dev/null) "



#ret_step=$?
#echo "ret_step "$ret_step
#export ret_step

stepper_start=$(echo $(echo $(echo "$stepper" | cut -d\| -f 1)))
stepper_stop=$(echo $(echo $(echo "$stepper" | cut -d\| -f 2)))
stepper_step=$(echo $(echo $(echo "$stepper" | cut -d\| -f 3)))
stepper_hop=$(echo $(echo $(echo "$stepper" | cut -d\| -f 4)))
stepper_current=$(echo $(echo $(echo "$stepper" | cut -d\| -f 5)))
GQRX_STEP=$(echo $(echo $(echo "$stepper" | cut -d\| -f 6)))


#echo $stepper
stepper_start="${stepper_start//,/$'.'}"
stepper_stop="${stepper_stop//,/$'.'}"
stepper_step="${stepper_step//,/$'.'}"
stepper_hop="${stepper_hop//,/$'.'}"

stepper_step_int=stepper_step
stepper_start_int=stepper_start
stepper_stop_int=stepper_stop



i=$((stepper_start_int))
end=$((stepper_stop_int))
band=$(((end-i)/stepper_step_int))
band=${band#-}

#echo $i $end $band


echo "Fstart: "$i " Fend: " $end " Step Hz: "$stepper_step "Hop-time: "$stepper_hop \
"Jumps: "$band "  Power : "$stepper_current "  GQRX : "$GQRX_STEP


# we need to switch to generator mode, and minimal power.
$morf_tool_path/morfeus_tool Generator
$morf_tool_path/morfeus_tool setCurrent $stepper_current


if [[ $GQRX_ENABLE -eq 1 ]];
   then
	if [[ $GQRX_STEP = "VFO" ]]; then
		#scanning start : setting GQRX LNB_LO to 0, to ensure display on correct VFO freq.
		echo "gqrx lnb_lo reset"
		echo "LNB_LO 0 " > /dev/tcp/$GQRX_IP/$GQRX_PORT 2>/dev/null
	fi
fi
k=0

#test if f_start > f_end, then launch decremental stepper
# and swap f_start f_end variables

if [[ "$i" > "$end" ]] ; then
	echo "*** Decremental steps !"
	#negative steps
	stepper_step_int=-${stepper_step_int}
	#swap f_end <->f_start
	end=$((stepper_start_int))
	i=$(($stepper_stop_int))

	else

	echo "*** Incremental steps !"
	i=$((stepper_start_int))
	end=$(($stepper_stop_int))

fi


# step numbers
band=$((band+1))

i=$((stepper_start_int))
end=$(($stepper_stop_int))

echo "# Fstart: $i  -  Fend:  $end -  step: $((stepper_step_int)) Hz" > file.csv
echo "# Start : "$(date +%Y-%m-%d" "%H:%M:%S) >> file.csv

while [ $k -ne $band ]; do

$morf_tool_path/morfeus_tool setFrequency $i
if [[ $GQRX_ENABLE -eq 1 ]];
   then
   if [[ $GQRX_STEP = "LNB_LO" ]]; then
      #send to LNB_LO
      #echo "GQRX LNB_LO:  " $i
      echo "LNB_LO "$i > /dev/tcp/$GQRX_IP/$GQRX_PORT 
   fi

   if [[ $GQRX_STEP = "VFO" ]]; then
      #send to VFO
      #echo "GQRX VFO:  " $i
      echo "F "$i > /dev/tcp/$GQRX_IP/$GQRX_PORT 
   fi
fi
k=$((k+1))

sleep $stepper_hop
# get signal level, thanks to @csete
GQRX_LEVEL=$(echo 'l' | socat stdio tcp:$GQRX_IP:$GQRX_PORT,shut-none 2>/dev/null)
echo "Freq: $i - GQRX: $GQRX_STEP - Jump $k/$band   -  Level : $GQRX_LEVEL dB"

# store freq,level values in csv file for future use (plot) :
# same as https://www.rtl-sdr.com/using-an-rtl-sdr-and-morfeus-as-a-tracking-generator-to-measure-filters-and-antenna-vswr/
# file compatible for use with rtl_power_fftw: https://github.com/AD-Vega/rtl-power-fftw/blob/master/doc/rtl_power_fftw.1.md

echo "$i,$GQRX_LEVEL" >> file.csv

#next freq step
i=$(($i+$stepper_step_int))
#echo $i



done
echo "Stepper end.    "
echo "# End : "$(date +%Y-%m-%d" "%H:%M:%S) >> file.csv
sleep 0.5


fi
#mainmenu
}



# Establish run order
main() {
#!/bin/bash
while :
do
#echo $ret

mainmenu
if [[ $ret -eq 1 ]];
   then
#	killall socat
	echo "Normal exit"	
	break       	   #Abandon the loop. (quit button)
   fi
if [[ $ret -eq 127 ]];
   then
	echo "err 127"
	break       	   #Abandon the loop. (error)
	fi
if [[ $ret -eq 252 ]];
   then
	echo "User cancel"
	break       	   #Abandon the loop. (close mainwindow)
   fi

done 
 
}

export -f mainmenu
main



