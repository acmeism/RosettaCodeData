# syntax: GAWK -f DRAW_A_CUBOID.AWK [-v x=?] [-v y=?] [-v z=?]
# example: GAWK -f DRAW_A_CUBOID.AWK -v x=12 -v y=4 -v z=6
# converted from VBSCRIPT
BEGIN {
    init_sides()
    draw_cuboid(2,3,4)
    draw_cuboid(1,1,1)
    draw_cuboid(6,2,1)
    exit (errors == 0) ? 0 : 1
}
function draw_cuboid(nx,ny,nz,  esf,i,i_max,j,j_max,lx,ly,lz) {
    esf = errors # errors so far
    if (nx !~ /^[0-9]+$/ || nx <= 0) { error(nx,ny,nz,1) }
    if (ny !~ /^[0-9]+$/ || ny <= 0) { error(nx,ny,nz,2) }
    if (nz !~ /^[0-9]+$/ || nz <= 0) { error(nx,ny,nz,3) }
    if (errors > esf) { return }
    lx = x * nx
    ly = y * ny
    lz = z * nz
# define the array size
    i_max = ly + lz
    j_max = lx + ly
    delete arr
    printf("%s %s %s (%d rows x %d columns)\n",nx,ny,nz,i_max+1,j_max+1)
# draw lines
    for (i=0; i<=nz-1; i++) { draw_line(lx,0,z*i,"-") }
    for (i=0; i<=ny; i++)   { draw_line(lx,y*i,lz+y*i,"-") }
    for (i=0; i<=nx-1; i++) { draw_line(lz,x*i,0,"|") }
    for (i=0; i<=ny; i++)   { draw_line(lz,lx+y*i,y*i,"|") }
    for (i=0; i<=nz-1; i++) { draw_line(ly,lx,z*i,"/") }
    for (i=0; i<=nx; i++)   { draw_line(ly,x*i,lz,"/") }
# output the cuboid
    for (i=i_max; i>=0; i--) {
      for (j=0; j<=j_max; j++) {
        printf("%1s",arr[i,j])
      }
      printf("\n")
    }
}
function draw_line(n,x,y,c,  dx,dy,i,xi,yi) {
    if      (c == "-") { dx = 1 ; dy = 0 }
    else if (c == "|") { dx = 0 ; dy = 1 }
    else if (c == "/") { dx = 1 ; dy = 1 }
    for (i=0; i<=n; i++) {
      xi = x + i * dx
      yi = y + i * dy
      arr[yi,xi] = (arr[yi,xi] ~ /^ ?$/) ? c : "+"
    }
}
function error(x,y,z,arg) {
    printf("error: '%s,%s,%s' argument %d is invalid\n",x,y,z,arg)
    errors++
}
function init_sides() {
# to change the defaults on the command line use: -v x=? -v y=? -v z=?
    if (x+0 < 2) { x = 6 } # top
    if (y+0 < 2) { y = 2 } # right
    if (z+0 < 2) { z = 3 } # front
}
