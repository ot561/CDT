# plot the function

#save it
#gnuplot -e "set key off; set xlabel 'w1'; set ylabel 'w2'; set zlabel 'f(x,y)'; splot 'fplot.dat' with linespoints palette pointtype 7; set term png; set output 'fxy_plot1.png'; set view 89,0,1,1; replot; set output 'fxy_plot2.png'; set view 1,89,1,1; replot; set output 'fxy_plot3.png'; set view 60,135,1,1; replot; pause 1"

gnuplot -e "set key off; set xlabel 'w1'; set ylabel 'w2'; set zlabel 'F(x,y)'; splot 'fplotw1w2.dat' with linespoints pointtype 7, 'fplotw3w4.dat' with linespoints pointtype 6; pause -1"

./plotsigidler.sh

#gnuplot -e "plot 'g4f90data.dat'; pause -1"



