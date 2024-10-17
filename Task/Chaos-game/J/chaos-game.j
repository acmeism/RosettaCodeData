require'plot'
NB. equilateral triangle with vertices on unit circle. rotated for fun.
Triangle=: *1ad_90 1ad150 1ad30*j./2 1 o.(2p1%6)*?0
Targets=: (?3000#3) { Triangle
Start=: j./2 1 o.2p1*?0       NB. start on unit circle
'marker' plot ((+/%#)@(,{.) , ])/Targets,Start
