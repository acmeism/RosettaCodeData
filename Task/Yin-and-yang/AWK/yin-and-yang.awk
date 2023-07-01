# syntax: GAWK -f YIN_AND_YANG.AWK
# converted from PHL
BEGIN {
    yin_and_yang(16)
    yin_and_yang(8)
    exit(0)
}
function yin_and_yang(radius,  black,white,scale_x,scale_y,sx,sy,x,y) {
    black = "#"
    white = "."
    scale_x = 2
    scale_y = 1
    for (sy = radius*scale_y; sy >= -(radius*scale_y); sy--) {
      for (sx = -(radius*scale_x); sx <= radius*scale_x; sx++) {
        x = sx / scale_x
        y = sy / scale_y
        if (in_big_circle(radius,x,y)) {
          if (in_white_semi_circle(radius,x,y)) {
            printf("%s",(in_small_black_circle(radius,x,y)) ? black : white)
          }
          else if (in_black_semi_circle(radius,x,y)) {
            printf("%s",(in_small_white_circle(radius,x,y)) ? white : black)
          }
          else {
            printf("%s",(x<0) ? white : black)
          }
        }
        else {
          printf(" ")
        }
      }
      printf("\n")
    }
}
function in_circle(center_x,center_y,radius,x,y) {
    return (x-center_x)*(x-center_x)+(y-center_y)*(y-center_y) <= radius*radius
}
function in_big_circle(radius,x,y) {
    return in_circle(0,0,radius,x,y)
}
function in_black_semi_circle(radius,x,y) {
    return in_circle(0,0-radius/2,radius/2,x,y)
}
function in_white_semi_circle(radius,x,y) {
    return in_circle(0,radius/2,radius/2,x,y)
}
function in_small_black_circle(radius,x,y) {
    return in_circle(0,radius/2,radius/6,x,y)
}
function in_small_white_circle(radius,x,y) {
    return in_circle(0,0-radius/2,radius/6,x,y)
}
