exact_equality(a,b){
	return (a==b)
}
exact_inequality(a,b){
	return !(a==b)
}
equality(a,b){
	return (a=b)
}
inequality(a,b){
	return !(a=b)
}
ordered_before(a,b){
	return ("" a < "" b)
}
ordered_after(a,b){
	return ("" a > "" b)
}
