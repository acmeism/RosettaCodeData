function factorial
	set x $argv[1]
	set result 1
	for i in (seq $x)
		set result (expr $i '*' $result)
	end
	echo $result
end
