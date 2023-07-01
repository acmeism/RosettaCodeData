## PSpirals.gp 1/10/17 aev
## Plotting many polyspiral pictures.
## Note: assign variables: rng, d, clr, filename and ttl (before using load command).
## Direction d (-1 clockwise / 1 counter-clockwise)
#cd 'C:\gnupData'

##PS0 smooth spiral (not a polyspiral)
reset
set terminal png font arial 12 size 640,640
set output "PS0gp.png"
set title "Smooth spiral  #0 rng=10" font "Arial:Bold,12"
set parametric
c=10*pi; set trange [0:c]; set xrange[-c:c]; set yrange[-c:c];
set samples 1000
plot t*cos(t), t*sin(t) lt rgb "red"
set output

##PS1 A polyspiral (Same size as PS0).
rng=10; d=1; clr = '"dark-green"';
filename = "PS1gp"; ttl = "Polyspiral #1 rng=10";
load "plotpoly.gp"

##PS3 A polyspiral
rng=20; d=-1; clr = '"red"';
filename = "PS3gp"; ttl = "Polyspiral #3 rng=20";
load "plotpoly.gp"

##PS4 A polyspiral having 4 secondary spirals.
rng=50; d=-1; clr = '"navy"';
filename = "PS4gp"; ttl = "Polyspiral #4 rng=50";
load "plotpoly.gp"

##PS5 Not a polyspiral, but has 8 secondary spirals.
rng=75; d=-1; clr = '"navy"';
filename = "PS5gp"; ttl = "Polyspiral #5 rng=75";
load "plotpoly.gp"

##PS6 Not a polyspiral, just a nice figure (seen in zkl).
rng=100; d=-1; clr = '"navy"';
filename = "PS6gp"; ttl = "Polyspiral #6 rng=100";
load "plotpoly.gp"

##==============================
#### NO PICTURES on RC starting from here, test it yourself

##PS2 A polyspiral
rng=20; d=1; clr = '"red"';
filename = "PS2gp"; ttl = "Polyspiral #2 rng=20";
load "plotpoly.gp"

##PS7 Looks like PS5, but has 5 secondary spirals (not 8)
rng=120; d=-1; clr = '"green"';
filename = "PS7gp"; ttl = "Polyspiral #7 rng=120";
load "plotpoly.gp"

##PS8 Looks like PS4, but more distortion.
rng=150; d=-1; clr = '"green"';
filename = "PS8gp"; ttl = "Polyspiral #8 rng=150";
load "plotpoly.gp"

##PS9 Looks like PS2, but less loops..
rng=175; d=-1; clr = '"green"';
filename = "PS9gp"; ttl = "Polyspiral #9 rng=175";
load "plotpoly.gp"

##PS10 One loop of a spiral
rng=200; d=-1; clr = '"green"';
filename = "PS10gp"; ttl = "Polyspiral #10 rng=200";
load "plotpoly.gp"

##PS11 Polyspiral with line segments crossing other line segments.
rng=30; d=-1; clr = '"navy"';
filename = "PS11gp"; ttl = "Polyspiral #11 rng=30";
load "plotpoly.gp"

##PS12 Looks like PS4, but has 5 secondary spirals.
rng=40; d=-1; clr = '"navy"';
filename = "PS12gp"; ttl = "Polyspiral #12 rng=40";
load "plotpoly.gp"

##PS13 Looks like PS5, but has 8 secondary spirals.
rng=60; d=-1; clr = '"navy"';
filename = "PS13gp"; ttl = "Polyspiral #13 rng=60";
load "plotpoly.gp"

##PS14 Looks like PS4, but has 5 secondary spirals.
rng=80; d=-1; clr = '"navy"'
filename = "PS14gp"; ttl = "Polyspiral #14 rng=80";
load "plotpoly.gp"

##PS15 Not a polyspiral. Hmmm, just a star?
rng=90; d=-1; clr = '"navy"';
filename = "PS15gp"; ttl = "Polyspiral #15 rng=90";
load "plotpoly.gp"

##PS16 Not a polyspiral. Hmmm, just another star?
rng=300; d=-1; clr = '"navy"';
filename = "PS16gp"; ttl = "Polyspiral #16 rng=300";
load "plotpoly.gp"

## Continue plotting starting with a range rng=110 to 400+ step 10 to discover new figures.
## END ##
