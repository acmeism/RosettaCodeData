## pSCF.gp 12/7/16 aev
## Plotting Sierpinski carpet fractals.
## Note: assign variables: ord (order), clr (color), filename and ttl (before using load command).
## ord (order)  # a.k.a. level - defines size of fractal (also number of dots).
#cd 'C:\gnupData'

##SCF21
ord=3; clr = '"red"';
filename = "SCF21gp"; ttl = "Sierpinski carpet fractal #21, ord ".ord;
load "plotscf.gp"

##SCF22
ord=5; clr = '"brown"';
filename = "SCF22gp"; ttl = "Sierpinski carpet fractal #22, ord ".ord;
load "plotscf.gp"

##SCF31
ord=5; clr = '"navy"';
filename = "SCF31gp"; ttl = "Sierpinski carpet fractal #31, ord ".ord;
load "plotscf1.gp"
