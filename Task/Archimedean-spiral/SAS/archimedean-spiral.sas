data xy;
h=constant('pi')/40;
do i=0 to 400;
    t=i*h;
    x=(1+t)*cos(t);
    y=(1+t)*sin(t);
    output;
end;
keep x y;
run;

proc sgplot;
series x=x y=y;
run;
