#gnuplot -e "set xlabel 'w1'; set ylabel 'w2'; set zlabel 'F(x,y)'; splot 'signalfreq1.dat' with linespoints pointtype 7, 'signalfreq2.dat' with linespoints pointtype 6; pause -1"

gnuplot << EOF
if (!exists("MP_LEFT"))   MP_LEFT = .1
if (!exists("MP_RIGHT"))  MP_RIGHT = .95
if (!exists("MP_BOTTOM")) MP_BOTTOM = .1
if (!exists("MP_TOP"))    MP_TOP = .9
if (!exists("MP_GAP"))    MP_GAP = 0.05

set multiplot layout 2,2 columnsfirst title "{/:Bold=15 Multiplot with explicit page margins}" \
              margins screen MP_LEFT, MP_RIGHT, MP_BOTTOM, MP_TOP spacing screen MP_GAP

set format y "%.1f"
set key box opaque
set ylabel 'ylabel'

set style line 1 lc 1
set style line 2 lc 3


plot 'signalfreq1.dat' using 2:3 with linespoints ls 1
set xlabel 'xlabel'
plot 'signalfreq2.dat' using 2:3 with linespoints ls 1

unset ylabel
unset ytics

unset xlabel
plot 'idlerfreq1.dat' using 2:3 with linespoints ls 2
set xlabel 'xlabel'
plot 'idlerfreq2.dat' using 2:3 with linespoints ls 2
unset multiplot


pause 10
EOF

gnuplot << 'EOF'

set terminal gif animate delay 5 loop 0 optimize
set output "jsa.gif"
set label "JSA" at screen 0.7, 0.9

unset key
set palette model CMY rgbformulae 7,5,15
n = 100
do for [i=1:n] {
   set view 60, i*360/n
    splot 'fplotw1w2.dat' using 1:2:($3 <=0.05 ? NaN : $3) with linespoints palette, 'fplotw3w4.dat' using 1:2:($3 <=0.05 ? NaN : $3) with linespoints palette
}

set output

#pause 30
EOF
