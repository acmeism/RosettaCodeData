shared void run() {

	alias Vector => Float[3];
	
	function dot(Vector a, Vector b) =>
			a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
	
	function cross(Vector a, Vector b) => [
		a[1] * b[2] - a[2] * b[1],
		a[2] * b[0] - a[0] * b[2],
		a[0] * b[1] - a[1] * b[0]
	];
	
	function scalarTriple(Vector a, Vector b, Vector c) =>
			dot(a, cross(b, c));
	
	function vectorTriple(Vector a, Vector b, Vector c) =>
			cross(a, cross(b, c));
	
	value a = [ 3.0,    4.0,    5.0 ];
	value b = [ 4.0,    3.0,    5.0 ];
	value c = [-5.0,  -12.0,  -13.0 ];
	
	print("``a`` . ``b`` = ``dot(a, b)``");
	print("``a`` X ``b`` = ``cross(a, b)``");
	print("``a`` . ``b`` X ``c`` = ``scalarTriple(a, b, c)``");
	print("``a`` X ``b`` X ``c`` = ``vectorTriple(a, b, c)``");
}
