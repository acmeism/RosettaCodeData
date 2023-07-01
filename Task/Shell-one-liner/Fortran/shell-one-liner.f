$ gawk 'BEGIN{print"write(6,\"(2(g12.3,x))\")(i/10.0,besj1(i/10.0), i=0,1000)\nend";exit(0)}'|gfortran -ffree-form -x f95 - | gnuplot -p -e 'plot "<./a.out" t "Bessel function of 1st kind" w l'
