mean() {
	if expr $# >/dev/null; then
		(count=0
		 sum=0
		 while expr $# \> 0 >/dev/null; do
			sum=`expr $sum + "$1"`
			result=$?
			expr $result \> 1 >/dev/null && exit $result

			count=`expr $count + 1`
			shift
		 done
		 expr $sum / $count)
	else
		echo 0
	fi
}

printf "test 1: "; mean				# 0
printf "test 2: "; mean 300			# 300
printf "test 3: "; mean 300 100 400		# 266
printf "test 4: "; mean -400 400 -1300 200	# -275
printf "test 5: "; mean -			# expr: syntax error
printf "test 6: "; mean 1 2 A 3			# expr: non-numeric argument
