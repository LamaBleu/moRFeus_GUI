#
# Quick plot level/vs freq
# LamaBleu 06/2018
#
# CSV input file format (space separator) : 
# freq(Hz) level
# comments at the end of file only
#
# example test from shell reading file.csv : 
# gnuplot -persist -e "f0=144000000;fmax=146000000" ./plot.gnu
#
#
#
set term qt 0  size 1000,400 position 30,30
set title "Fstart : " . sprintf("%09.3f", f0/1000) . " kHz  -  Fstop " . sprintf("%09.3f", fmax/1000) . " kHz"
set xlabel "freq. [MHz]"
set yrange [-70:5]
set ylabel "level [dB]"
set format x "%1.3f"
plot './example.csv' using ($1)/1000000:($2) with lines lc rgb '#bf000a' notitle 
set terminal push
set terminal png size 1200, 600
set output './example-1.png'
replot
set terminal pop
replot

