--  One of n lines in a file
include std/rand.e
include std/math.e

function one_of_n(integer n)
	integer line_num = 1
	for i = 2 to n do
		if rnd() < 1 / i then
			line_num = i
		end if
	end for
	return line_num
end function

procedure main()
	integer num_reps = 1000000, num_lines_in_file = 10
	sequence lines = repeat(0,num_lines_in_file)
	for i = 1 to num_reps do
		lines[one_of_n(num_lines_in_file)] += 1
	end for
	for i = 1 to num_lines_in_file do
		printf(1,"Number of times line %d was selected: %g\n", {i,lines[i]})
	end for
	printf(1,"Total number selected: %d\n", sum(lines) )
end procedure

main()
