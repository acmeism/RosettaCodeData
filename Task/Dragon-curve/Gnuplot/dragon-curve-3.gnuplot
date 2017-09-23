## pDCF.gp 1/11/17 aev
## Plotting 3 Dragon curve fractals.
## Note: assign variables: ord (order), clr (color), filename and ttl (before using load command).
## ord (order)  # a.k.a. level - defines size of fractal (also number of dots).
#cd 'C:\gnupData'

##DCF11
ord=11; clr = '"red"';
filename = "DCF"; ttl = "Dragon curve fractal, order ".ord;
load "plotdcf.gp"

##DCF13
ord=13; clr = '"brown"';
filename = "DCF"; ttl = "Dragon curve fractal, order ".ord;
load "plotdcf.gp"

##DCF15
ord=15; clr = '"navy"';
filename = "DCF"; ttl = "Dragon curve fractal, order ".ord;
load "plotdcf.gp"
