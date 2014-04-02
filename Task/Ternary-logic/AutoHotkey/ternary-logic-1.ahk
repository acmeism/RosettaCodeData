Ternary_Not(a){
	SetFormat, Float, 2.1
	return Abs(a-1)
}

Ternary_And(a,b){
	return a<b?a:b
}

Ternary_Or(a,b){
	return a>b?a:b
}

Ternary_IfThen(a,b){
	return a=1?b:a=0?1:a+b>1?1:0.5
}

Ternary_Equiv(a,b){
	return a=b?1:a=1?b:b=1?a:0.5
}
