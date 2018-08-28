# moRFeus_GUI

A simple tool to control your moRFeus device from your Linux-computer or Raspberry Pi

Designed only for moRFeus device (RF mixer/generator made by Outernet).  
Product informations : https://store.othernet.is/products/morfeus-1   
This tool was written using only 'yad' and bash to make my moRFeus user life easier.  

UPDATE 08/08/2018 : This is the 'next' version.  
Fixes, added live-plot, progress-bar during step-sequence.  
Abort during step-sequence is now possible by pressing the "cancel" button  
GNUPlot (gnuplot AND gnuplot-qt) is not mandatory, only optional.  


New feature to "get signal level from GQRX" with CSV export file and plots, when running step generator.  
Why ? more here : https://www.rtl-sdr.com/using-an-rtl-sdr-and-morfeus-as-a-tracking-generator-to-measure-filters-and-antenna-vswr/
  
Code is very crude, with no error checking. Feel free to use it, improve it.  
Reporting bug, issue, or just experience, you are welcome : github, @fonera_cork (twitter), lama.bleu (gmail), /u/samarragepas (reddit)



Installation  
============

**Short video** showing installation and step-generator on Linux 64bits platform : [here](http://www.lamableu.net/files/moRFeus_GUI-install.mkv)

 
#### Linux and Raspberry Pi

Automatic install :

  `git clone https://github.com/LamaBleu/moRFeus_GUI`  
  `cd moRFeus_GUI`  
  `git checkout next`  
  `sudo -H ./GUI_moRFeus.sh`  


At first launch the script will try to download the morfeus_tool from Outernet website, then perform installation tasks.
You will be asked to choose 32, 64 bits or arm (RPi) version.
In case of trouble, re-launch install by deleting morfeus_tool file (if present)



 
Usage  
=====

At launch actual moRFeus settings are collected and displayed on the first three lines.

![image](https://user-images.githubusercontent.com/26578895/38947869-5274aa46-433e-11e8-8e76-18c5039fda80.png)


The main GUI window is intuitive, each button describing the performed function.  
Nothing else to say.  

Step generator
==============

![image](https://user-images.githubusercontent.com/26578895/38948007-aca71f4e-433e-11e8-9bfe-714a17975774.png)


3-minutes video showing step-generator and plotting  : https://www.youtube.com/watch?v=m0agjpfRzyg

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


CSV export and plotting
=======================

  - use moRFeus as RF generator and GQRX (local or remote) to test antennas, filters, receiver performance. Get signal level at regular steps accross the spectrum and store results in CSV file. Then plot results.  
     . prepare your stuffs, antenna, receiver, adjust levels, ppm calibration and gain on GQRX (set it first to central frequency of the range you will study)  
     . enable remote control from GQRX. If GQRX is running on remote computer you have to allow client IP address in GQRX remote control settings.  
     . go to step-generator mode, and select start/stop freqs, power. Choose **"send Freq to GQRX : VFO"**. Run stepper, wait...    
     . at the end of process csv file is generated (freq level) in ./datas directory  
     . **Only if** gnuplot and gnuplot-qt packages are installed, a resulting plot will be displayed, and saved to ./datas/ directory  
     . full example is provided in ./datas/ directory, with gnuplot script to plot again graph from CSV file.  
  
Here is an example, testing an old UHF TV antenna:  
![image](https://user-images.githubusercontent.com/26578895/42124301-55954e28-7c60-11e8-908d-3f98e4446634.png)
  
more infos here on : https://www.rtl-sdr.com/using-an-rtl-sdr-and-morfeus-as-a-tracking-generator-to-measure-filters-and-antenna-vswr/  
    



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



#### Troubleshooting

* In case automatic install fails just delete the morfeus_tool executable file present in moFReus_GUI directory.  
Script will try to download it again and perform important step for a first use.  
  
* GQRX link : check remote control settings menu, to allow remote computer to control VFO  
Details on GQRX website :  http://gqrx.dk/doc/remote-control  
     



Known issues.  
=============

Program runs a little bit slower with GQRX support enabled. 
If you don't use GQRX you can disable the feature by setting GQRX_ENABLE=0 on GUI_moRFeus.sh file 


Credits
=======
Thanks to Outernet team, othernet forum contributors, Karl from rtl-sdr.com blog, [Alex OZ9AEC](http://gqrx.dk).  
Special thanks to [Psynosaur](https://github.com/Psynosaur) and Konrad WA4OSH for sharing ideas and experience.  
