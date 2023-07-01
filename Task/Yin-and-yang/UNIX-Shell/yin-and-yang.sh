#!/usr/bin/env bash
in_circle() { #(cx, cy, r, x y)
  # return true if the point (x,y) lies within the circle of radius r centered
  # on (cx,cy)
  # (but really scaled to an ellipse with vertical minor semiaxis r and
  # horizontal major semiaxis 2r)
  local -i cx=$1 cy=$2 r=$3 x=$4 y=$5
  local -i dx dy
  (( dx=(x-cx)/2, dy=y-cy, dx*dx + dy*dy <= r*r ))
}

taijitu() { #radius
  local -i radius=${1:-17}
  local -i x1=0 y1=0 r1=radius            # outer circle
  local -i x2=0 y2=-radius/2 r2=radius/6  # upper eye
  local -i x3=0 y3=-radius/2 r3=radius/2  # upper half
  local -i x4=0 y4=+radius/2 r4=radius/6  # lower eye
  local -i x5=0 y5=+radius/2 r5=radius/2  # lower half
  local -i x y
  for (( y=radius; y>=-radius; --y )); do
    for (( x=-2*radius; x<=2*radius; ++x)); do
      if ! in_circle $x1 $y1 $r1 $x $y; then
        printf ' '
      elif in_circle $x2 $y2 $r2 $x $y; then
        printf '#'
      elif in_circle $x3 $y3 $r3 $x $y; then
        printf '.'
      elif in_circle $x4 $y4 $r4 $x $y; then
        printf '.'
      elif in_circle $x5 $y5 $r5 $x $y; then
        printf '#'
      elif (( x <= 0 )); then
        printf '.'
      else
        printf '#'
      fi
    done
    printf '\n'
  done
}
