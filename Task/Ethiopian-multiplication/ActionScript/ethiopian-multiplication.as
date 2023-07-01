function Divide(a:Number):Number {
	return ((a-(a%2))/2);
}
function Multiply(a:Number):Number {
	return (a *= 2);
}
function isEven(a:Number):Boolean {
	if (a%2 == 0) {
		return (true);
	} else {
		return (false);
	}
}
function Ethiopian(left:Number, right:Number) {
	var r:Number = 0;
	trace(left+"     "+right);
	while (left != 1) {
		var State:String = "Keep";
		if (isEven(Divide(left))) {
			State = "Strike";
		}
		trace(Divide(left)+"     "+Multiply(right)+"  "+State);
		left = Divide(left);
		right = Multiply(right);
		if (State == "Keep") {
			r += right;
		}
	}
	trace("="+"      "+r);
}
}
