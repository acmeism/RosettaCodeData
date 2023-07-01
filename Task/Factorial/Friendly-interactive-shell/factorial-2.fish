function factorial
	set x $argv[1]
	if [ $x -eq 1 ]
		echo 1
	else
		expr (factorial (expr $x - 1)) '*' $x
	end
end
