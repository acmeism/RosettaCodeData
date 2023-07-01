# syntax: GAWK -f DRAW_A_SPHERE.AWK
# converted from VBSCRIPT
BEGIN {
    draw_sphere(20,4,0.1)
    draw_sphere(10,2,0.4)
    exit(0)
}
function draw_sphere(radius,k,ambient, b,i,intensity,j,leng_shades,light,line,shades,vec,x,y) {
    leng_shades = split0(".:!*oe&#%@",shades,"")
    split("30,30,-50",light,",")
    normalize(light)
    for (i=int(-radius); i<=ceil(radius); i++) {
      x = i + 0.5
      line = ""
      for (j=int(-2*radius); j<=ceil(2*radius); j++) {
        y = j / 2 + 0.5
        if (x*x + y*y <= radius*radius) {
          vec[1] = x
          vec[2] = y
          vec[3] = sqrt(radius*radius - x*x - y*y)
          normalize(vec)
          b = dot(light,vec) ^ k + ambient
          intensity = int((1-b) * leng_shades)
          if (intensity < 0) {
            intensity = 0
          }
          if (intensity >= leng_shades) {
            intensity = leng_shades
          }
          line = line shades[intensity]
        }
        else {
          line = line " "
        }
      }
      printf("%s\n",line)
    }
}
function ceil(x,  tmp) {
    tmp = int(x)
    return (tmp != x) ? tmp+1 : tmp
}
function dot(x,y,  tmp) {
    tmp = x[1]*y[1] + x[2]*y[2] + x[3]*y[3]
    return (tmp < 0) ? -tmp : 0
}
function normalize(v,  tmp) {
    tmp = sqrt(v[1]*v[1] + v[2]*v[2] + v[3]*v[3])
    v[1] /= tmp
    v[2] /= tmp
    v[3] /= tmp
}
function split0(str,array,fs,  arr,i,n) { # same as split except indices start at zero
    n = split(str,arr,fs)
    for (i=1; i<=n; i++) {
      array[i-1] = arr[i]
    }
    return(n)
}
