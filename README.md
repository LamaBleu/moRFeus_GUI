# moRFeus_GUI

A simple tool to control your moRFeus device from your Linux-computer or Raspberry Pi

Note : a specific file [RPi_moRFeus.sh](https://github.com/LamaBleu/moRFeus_GUI/RPi_moRFeus.sh) for **Raspberry Pi** is now available for download. Installation procedure is the same.

Designed only for moRFeus (RF mixer/generator made by Outernet).  
Product informations : https://outernet.is/pages/morfeus   
This tool was written using only 'yad' and bash to make my moRFeus user life easier.  
Code is very crude, with no error checking. Feel free to use it, improve it. 

Installation  
============

As pre-requisite you have to install yad ,socat and bc packages (sudo apt-get install yad socat bc)  
Download and copy this script into a directory.  
Download morfeus_tool executable from Outernet website: https://archive.outernet.is/morfeus_tool_v1.6/  
      Choose the right version, adapted to your platform.  (Linux-32 & 64b, ARM)    
      Copy the tool to the same directory. RENAME it 'morfeus_tool' !  
      Make all files executable (cd to directory then 'chmod +x *'). No need to change files owner. 
 

!!!!!! IMPORTANT !!!!!!  
You need to be root to communicate with the device, launch the UI typing from shell :   
  " sudo <directory_path>/GUI_moRFeus.sh"  

 Again do not forget to rename the executable to 'morfeus_tool'  

Usage  
=====

At launch actual moRFeus settings are collected and displayed on the first three lines.

![image](https://user-images.githubusercontent.com/26578895/38947869-5274aa46-433e-11e8-8e76-18c5039fda80.png)

- from shell 'cd' to GUI_moRFeus directory, type 'sudo ./GUI_moRFeus'  

The main GUI window is intuitive, each button describing the performed function.  
Nothing else to say.  

Step generator
==============

![image](https://user-images.githubusercontent.com/26578895/38948007-aca71f4e-433e-11e8-9bfe-714a17975774.png)



The best is to have a look at this other screenshot first : https://imgur.com/6RdO9LO   
Step generator mode will allow to increment the frequency (switched to generator mode) by steps (Hz) of regular interval (seconds)  
Power can be set at this moment. moRFeus device will toggle to generator mode.  
Steps can be negative (decremental steps) if F-start > F-end  
Sending freq to GQRX/VFO allow you **to follow the signal in GQRX** during the stepping-sequence.  
Try to listen the audio signal (set GQRX in CW mode) of the generator. Very stable and clean !  
Here is an example : [screenshot](https://imgur.com/vmZoEP2) and [related audio](https://vocaroo.com/i/s0efbrP0W1cP)

When using this feature please consider : 
- think first what you will do with your generator:  
  this can take lot of time, example: if you chose F-start=150MHz F-end=450MHz Step 1000Hz, hop every 10 seconds --> 9hrs45mins !  
- IMPORTANT REMINDER : is not allowed to play everywhere in RF spectrum !  


GQRX support  
============
Informations about GQRX: http://gqrx.dk (thanks to Alex for nice and continuous work ;) )  
 Adapt parameters in this file to GQRX settings (should be OK by default)  
 
 From the main window, you can :  
	- read actual GQRX VFO and LNB_LO values.  
	- transfer the moRFeus freq to the GQRX VFO (generator mode, listen moRFeus signal)  
	- transfer the moRFeus freq to GQRX LNB_LO (moRFeus mixer mode).
	  GQRX is now displaying the real frequency (mixer + GQRX VFO) !  
	- reset GQRX LNB_LO freq. to 0 
	  
 
 From the step generator menu, you can send the moRFeus frequency to GQRX, and so follow the signal. Cool!  


Known bugs.  
===========
Lot ! 
The most annoying is pressing "Cancel" button on the "step generator" window...  
Program runs a little bit slower with GQRX support enabled. 
If you don't use GQRX you can disable the feature by setting GQRX_ENABLE=0 on this file.  


