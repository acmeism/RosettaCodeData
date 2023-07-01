((xmin=-8601))  # int(-2.1*4096)
((xmax=2867))   # int( 0.7*4096)

((ymin=-4915))  # int(-1.2*4096)
((ymax=4915))   # int( 1.2*4096)

((maxiter=30))

((dx=(xmax-xmin)/72))
((dy=(ymax-ymin)/24))

C='0123456789'
((lC=${#C}))

for((cy=ymax;cy>=ymin;cy-=dy)) ; do
	for((cx=xmin;cx<=xmax;cx+=dx)) ; do
		((x=0,y=0,x2=0,y2=0))
		for((iter=0;iter<maxiter && x2+y2<=16384;iter++)) ; do
			((y=((x*y)>>11)+cy,x=x2-y2+cx,x2=(x*x)>>12,y2=(y*y)>>12))
		done
		((c=iter%lC))
		echo -n ${C:$c:1}
	done
	echo
done
