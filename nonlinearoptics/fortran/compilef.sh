gfortran -O2 olis_f90stdlib.f90 makeopticalelements.f90 num_hom.f90 -L/usr/lib -llapack -lblas && time ./a.out 
#&& ./gnuplot.sh 
