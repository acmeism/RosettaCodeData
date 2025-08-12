class Main {
	static public function main():Void {
		// Array (dynamic length)
		var a = new Array<Int>();
		for (i in 1...4)
			a.push(i);
        // alt: var a = [1, 2, 3];
        // alt2: var a = [for (i in 1...4)];

		for (i in 0...a.length)
			trace(a[i]);

		// Vector (fixed-length)
		var v = new haxe.ds.Vector(3);
		v[0] = 1;
		v[1] = 2;
		v[2] = 3;

		for (i in 0...v.length)
			trace(v[i]);
	}
}
