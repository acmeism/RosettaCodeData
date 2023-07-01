merge(base, update){
	Merged  := {}
	for k, v in base
		Merged[k] := v
	for k, v in update
		Merged[k] := v
	return Merged
}
