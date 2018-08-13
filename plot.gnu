#
# Quick plot level/vs freq
# LamaBleu 06/2018
#
# CSV input file format (space separator) : 
# freq(Hz) level
# comments at the end of file only
#
#
#
#
set term qt 0  size 1000,400 position 30,30
set title "Fstart : " . sprintf("%09.3f", f0/1000) . " kHz  -  Fstop " . sprintf("%09.3f", fmax/1000) . " kHz"
set xlabel "freq. [MHz]"
set yrange [-110:-10]
set ylabel "level [dB]"
set format x "%1.3f"
set timestamp
set key at graph 0.95, 0.95
set size 0.95,0.95
plot '/tmp/file.csv' using ($1)/1000000:($2) with lines lc rgb '#bf000a' notitle 
set terminal push
set terminal png size 1200, 600
set output './datas/signal.png'
replot
set terminal pop
replot

