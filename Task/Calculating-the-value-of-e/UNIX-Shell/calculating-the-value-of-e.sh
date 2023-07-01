# POSIX requires "signed long" for shell arithmetic, so assume to have at
# least 31 bits available, which is sufficient to store (e - 1) * 10^9

one=1000000000

e=0 n=0 rfct=$one
while [ $((rfct /= (n += 1))) -ne 0 ]
do
	e=$((e + rfct))
done

echo "$((e / one + 1)).$((e % one))"
