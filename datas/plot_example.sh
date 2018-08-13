#!/bin/bash

# Will display a plot from example.csv file
# and save the plot as example-1.png
# CSVfile : freq(Hz) level(dB) 
gnuplot -persist -e "f0=1250000000;fmax=1750000000" ./plot-example.gnu
