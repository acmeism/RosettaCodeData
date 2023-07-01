for_J(doFunction, start, stop, step:=1){
	j := start
	while (j<=stop) && (start<=stop) && (step>0)
		%doFunction%(j),		j+=step
	while (j>=stop) && (start>stop) && (step<0)
		%doFunction%(j),		j+=step
}
