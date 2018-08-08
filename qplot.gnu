
set term x11  size 500,200 position 30,30
set title "Fstart : " . sprintf("%09.3f", f0/1000) . " kHz  -  Fstop " . sprintf("%09.3f", fmax/1000) . " kHz  -  Step " . k . " / " . band
set xlabel "freq. [MHz]"
#set yrange [-110:-10]
set ylabel "level [dB]"
set format x "%1.3f"
#set key at graph 0.95, 0.95
#set size 0.95,0.95
plot '/tmp/qplot.csv' using ($1)/1000000:($2) with lines lc rgb '#bf000a' notitle 
pause 1
pause stepper_hop



