function leftRect(f:Function, a:Number, b:Number, n:uint):Number
{
	var sum:Number = 0;
	var dx:Number = (b-a)/n;
	for (var x:Number = a; n > 0; n--, x += dx)
		sum += f(x);
	return sum * dx;
}

function rightRect(f:Function, a:Number, b:Number, n:uint):Number
{
	var sum:Number = 0;
	var dx:Number = (b-a)/n;
	for (var x:Number = a + dx; n > 0; n--, x += dx)
		sum += f(x);
	return sum * dx;
}

function midRect(f:Function, a:Number, b:Number, n:uint):Number
{
	var sum:Number = 0;
	var dx:Number = (b-a)/n;
	for (var x:Number = a + (dx / 2); n > 0; n--, x += dx)
		sum += f(x);
	return sum * dx;
}
function trapezium(f:Function, a:Number, b:Number, n:uint):Number
{
	var dx:Number = (b-a)/n;
	var x:Number = a;
	var sum:Number = f(a);
	for(var i:uint = 1; i < n; i++)
	{
		a += dx;
		sum += f(a)*2;
	}
	sum += f(b);
	return 0.5 * dx * sum;
}
function simpson(f:Function, a:Number, b:Number, n:uint):Number
{
	var dx:Number = (b-a)/n;
	var sum1:Number = f(a + dx/2);
	var sum2:Number = 0;
	for(var i:uint = 1; i < n; i++)
	{
		sum1 += f(a + dx*i + dx/2);
		sum2 += f(a + dx*i);
	}
	return (dx/6) * (f(a) + f(b) + 4*sum1 + 2*sum2);
}
