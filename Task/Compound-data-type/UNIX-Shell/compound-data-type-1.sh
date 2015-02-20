typeset -T Point=(
  typeset x
  typeset y
)
Point p
p.x=1
p.y=2
echo $p
echo ${p.x} ${p.y}
Point q=(x=3 y=4)
echo ${q.x} ${q.y}
