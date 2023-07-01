type
	/// domain for Fibonacci function
	/// where result is within nativeUInt
	// You can not name it fibonacciDomain,
	// since the Fibonacci function itself
	// is defined for all whole numbers
	// but the result beyond F(n) exceeds high(nativeUInt).
	fibonacciLeftInverseRange =
		{$ifdef CPU64} 0..93 {$else} 0..47 {$endif};

{**
	implements Fibonacci sequence iteratively
	
	\param n the index of the Fibonacci number to calculate
	\returns the Fibonacci value at n
}
function fibonacci(const n: fibonacciLeftInverseRange): nativeUInt;
type
	/// more meaningful identifiers than simple integers
	relativePosition = (previous, current, next);
var
	/// temporary iterator variable
	i: longword;
	/// holds preceding fibonacci values
	f: array[relativePosition] of nativeUInt;
begin
	f[previous] := 0;
	f[current] := 1;
	
	// note, in Pascal for-loop-limits are inclusive
	for i := 1 to n do
	begin
		f[next] := f[previous] + f[current];
		f[previous] := f[current];
		f[current] := f[next];
	end;
	
	// assign to previous, bc f[current] = f[next] for next iteration
	fibonacci := f[previous];
end;
