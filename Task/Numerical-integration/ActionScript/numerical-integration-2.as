function f1(n:Number):Number {
	return (2/(1+ 4*(n*n)));
}
trace(leftRect(f1, -1, 2, 4));
trace(rightRect(f1, -1, 2, 4));
trace(midRect(f1, -1, 2, 4));
trace(trapezium(f1, -1, 2 ,4 ));
trace(simpson(f1, -1, 2 ,4 ));
