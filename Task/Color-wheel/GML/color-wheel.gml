for (var i = 1; i <= 360; i++) {
    for (var j = 0; j < 255; j++) {

        var hue = 255*(i/360);
        var saturation = j;
        var value = 255;

        var c = make_colour_hsv(hue,saturation,value);

        //size of circle determined by how far from the center it is
        //if you just draw them too small the circle won't be full.
        //it will have patches inside it that didn't get filled in with color
        var r = max(1,3*(j/255));

        //Math for built-in GMS functions
        //lengthdir_x(len,dir) = +cos(degtorad(direction))*length;
        //lengthdir_y(len,dir) = -sin(degtorad(direction))*length;
        draw_circle_colour(x+lengthdir_x(m_radius*(j/255),i),y+lengthdir_y(m_radius*(j/255),i),r,c,c,false);
    }
}
