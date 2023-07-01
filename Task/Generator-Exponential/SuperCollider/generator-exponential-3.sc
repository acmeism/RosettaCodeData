(
var filter = { |a, b, func| // both streams are assumed to be ordered
	Prout {
		var astr, bstr;
		var aval, bval;
		astr = a.asStream;
		bstr = b.asStream;
		bval = bstr.next;
		while {
			aval = astr.next;
			aval.notNil
		} {
			while {
				bval.notNil and: { bval < aval }
			} {
				bval = bstr.next;
			};
			if(func.value(aval, bval)) { aval.yield };
		}
	}
};
var without = filter.(_, _, { |a, b|  a != b }); // partially apply function

f = Pseries(0, 1);

g = without.(f ** 2, f ** 3);
h = g.drop(20);
h.asStream.nextN(10);
)

answers: [ 529, 576, 625, 676, 784, 841, 900, 961, 1024, 1089 ]
