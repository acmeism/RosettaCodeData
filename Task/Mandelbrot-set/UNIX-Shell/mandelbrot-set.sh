function mandelbrot() {
  local -ir maxiter=100
  local -i i j {x,y}m{in,ax} d{x,y}
  local -ra C=( {0..9} )
  local -i lC=${#C[*]}
  local -i columns=${COLUMNS:-72} lines=${LINES:-24}

  ((
    xmin=-21*4096/10,
    xmax=  7*4096/10,

    ymin=-12*4096/10,
    ymax= 12*4096/10,

    dx=(xmax-xmin)/columns,
    dy=(ymax-ymin)/lines
  ))

  for ((cy=ymax, i=0; i<lines; cy-=dy, i++))
  do for ((cx=xmin, j=0; j<columns; cx+=dx, j++))
    do (( x=0, y=0, x2=0, y2=0 ))
      for (( iter=0; iter<maxiter && x2+y2<=16384; iter++ ))
      do
        ((
          y=((x*y)>>11)+cy,
          x=x2-y2+cx,
          x2=(x*x)>>12,
          y2=(y*y)>>12
        ))
      done
      ((c=iter%lC))
      echo -n "${C[c]}"
    done
    echo
  done
}
