# Task: Ackermann function
#
# A simple straightforward recursive implementation.
module ackermann_function

fun ack(m, n: Int): Int
do
	if m == 0 then return n + 1
	if n == 0 then return ack(m-1,1)
	return ack(m-1, ack(m, n-1))
end

for m in [0..3] do
	for n in [0..6] do
		print ack(m,n)
	end
	print ""
end
