proc fold {lambda zero list} {
    set accumulator $zero
    foreach item $list {
	set accumulator [apply $lambda $accumulator $item]
    }
    return $accumulator
}
