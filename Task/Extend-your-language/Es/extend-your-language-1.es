fn if2 cond1 cond2 body11 body10 body01 body00 {
	# Must evaluate both conditions, and should do so in order.
	# Negation ensures a boolean result: a true condition becomes
        # 1 for false; a false condition becomes 0 for true.
	let (c1 = <={! $cond1}; c2 = <={! $cond2}) {
		# Use those values to pick the body to evaluate.
		$(body$c1$c2)
	}
}
