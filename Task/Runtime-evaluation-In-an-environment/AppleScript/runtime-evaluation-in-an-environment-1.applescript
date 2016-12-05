on task_with_x(pgrm, x1, x2)
	local rslt1, rslt2
	set rslt1 to run script pgrm with parameters {x1}
	set rslt2 to run script pgrm with parameters {x2}
	rslt2 - rslt1
end task_with_x
