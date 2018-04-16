# moRFeus_GUI

A simple tool to control your moRFeus device from your Linux-computer 

Designed only for moRFeus (RF mixer/generator made by Outernet).  
Product informations : https://outernet.is/pages/morfeus .
This tool was written using only 'yad' and bash to make my moRFeus user life easier.  
Feel free to use it, improve it. Code is very crude, with no error checking.

Installation.
==============

As pre-requisite you have to install yad package (sudo apt-get install yad)

- Download and copy the script from https://github.com/LamaBleu/moRFeus_GUI on a directory, let's say /home/_your_username>/GUI_moRFeus
 
- Download the morfeus_tool executable from Outernet archives website: https://archive.outernet.is/morfeus_tool_v1.6/
 Choose the right version, adapted to your platform. ! (Linux-32 or 64b, ARM)
 Copy the tool to the GUI_moRFeus directory. RENAME it 'morfeus_tool' ! 
 If needed make all files in this directory executable (cd to directory then 'chmod +x *') but no needs to change files owner.
 
- Just have a look to the first lines of the GUI_moRFeus.sh file.

 !!!!!! IMPORTANT !!!!!!  
 As you need to be root to communicate with the device, launch the UI by typing:  
 
     gksudo <path_to_file>/GUI_moRFeus.sh
 or
 
     sudo <directory_path>/GUI_moRFeus.sh 
(I prefer the second one to see console messages)
The program will not launch if device is disconnected or launched by a regular (not root-level privileges) user !

Once again do not forget to rename the downloaded executable to 'morfeus_tool' !

Usage
=====

- 'cd' to GUI_moRFeus then run 'gksudo ./GUI_moRFeus.sh' or './sudo GUI_moRFeus'

The main GUI window is intuitive, each button describing the performed function.
Nothing else to say.

- Step generator

The best is to have a look at this image first : https://imgur.com/6RdO9LO  
Step generator mode will allow to increment the frequency (switched to generator mode) by regulars (seconds) steps (Hz).


When using this feature take care : 
- not really debugged, so at this moment F-start should be superior to F-end.
- think first what you will do with your generator:
  this can take lot of time, example: if you chose F-start=150MHz F-end=450MHz Step 1000Hz, hop every 10 seconds --> 9hrs45mins !  
- IMPORTANT REMINDER : is not allowed to play everywhere in RF spectrum !
- at this moment no negative (decrement) step and sweep interval is perhaps not 1/10 sec accurate, sorry.


