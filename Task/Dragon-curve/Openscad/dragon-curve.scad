level = 8;
linewidth = .1;  // fraction of segment length
sqrt2 = pow(2, .5);

// Draw a dragon curve "level" going from [0,0] to [1,0]
module dragon(level) {
    if (level <= 0) {
        translate([.5,0]) cube([1+linewidth,linewidth,linewidth],center=true);
    } else {
        rotate(-45) scale(1/sqrt2) dragon(level-1);
        translate([1,0]) rotate(-135) scale(1/sqrt2) dragon(level-1);
    }
}

scale(40) {  // scale to nicely visible in the default GUI
    sphere(1.5*linewidth / pow(2,level/2));  // mark the start of the curve
    dragon(level);
}
