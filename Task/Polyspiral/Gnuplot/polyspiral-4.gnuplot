## PSpirals4a.gp 1/19/17 aev
## Plotting many polyspiral and other pictures for animation
## Notes: 1. Assign variables: rng, d, clr, filename(before using load command).
## ====== 2. NO title in this version.
##        3. Primarily range is changed.
## Direction d (-1 clockwise / 1 counter-clockwise)
#cd 'C:\gnupData'

##====== for PolySpirsAnim.gif ==========================================
##PS0 A polyspiral (direction: counter-clockwise).
rng=10; d=1; clr = '"red"'; filename = "PS0"; load "plotpolya.gp";

##PS1 A polyspiral (direction: clockwise).
rng=20; d=-1; clr = '"red"'; filename = "PS1"; load "plotpolya.gp";

##PS2 A polyspiral. Looks like PS1, but less loops..
rng=175; d=-1; clr = '"red"'; filename = "PS2"; load "plotpolya.gp";

##PS3 Polyspiral with line segments crossing other line segments.
rng=30; d=-1; clr = '"red"'; filename = "PS3"; load "plotpolya.gp";

##PS4 A polyspiral having 4 secondary spirals.
rng=50; d=-1; clr = '"red"'; filename = "PS4"; load "plotpolya.gp";

##PS5 A polyspiral. Looks like PS4, but has 5 secondary spirals.
rng=40; d=-1; clr = '"red"'; filename = "PS5"; load "plotpolya.gp";

##PS6 A polyspiral. Looks like PS4, but has more distortion.
rng=150; d=-1; clr = '"red"'; filename = "PS6"; load "plotpolya.gp";

##PS7 A polyspiral. Has 8 secondary spirals and even more distortion.
rng=60; d=-1; clr = '"red"'; filename = "PS7"; load "plotpolya.gp";


##====== for NiceFigsAnim.gif ==========================================
##PS8 Not a polyspiral, but has 8 secondary spirals.
rng=75; d=-1; clr = '"navy"'; filename = "PS8"; load "plotpolya.gp";

##PS9 Looks like PS8, but has 5 secondary spirals.
rng=80; d=-1; clr = '"navy"'; filename = "PS9"; load "plotpolya.gp";

##PS10 Looks like PS8, but has 5 secondary spirals (not 8)
rng=120; d=-1; clr = '"navy"'; filename = "PS10"; load "plotpolya.gp";

##PS11 Not a polyspiral, just nice figure.
rng=100; d=-1; clr = '"navy"'; filename = "PS11"; load "plotpolya.gp";

##PS12 Not a polyspiral. Hmmm, just a star?
rng=90; d=-1; clr = '"navy"'; filename = "PS12"; load "plotpolya.gp";

##PS13 Not a polyspiral. Hmmm, just another star?
rng=300; d=-1; clr = '"navy"'; filename = "PS13"; load "plotpolya.gp";

##PS14 Not a polyspiral, but has many short secondary spirals.
rng=700; d=-1; clr = '"navy"'; filename = "PS14"; load "plotpolya.gp";
