SpecialObject {

	classvar a = 42, <b = 0, <>c;    // Class variables. 42 and 0 are default values.
	var <>x, <>y;           // Instance variables.
	// Note: variables are private by default. In the above, "<" creates a getter, ">" creates a setter

	*new { |value|
		^super.new.init(value)       // constructor is a class method. typically calls some instance method to set up, here "init"
	}

	init { |value|
		x = value;
		y = sqrt(squared(a) + squared(b))
	}

	// a class method
	*randomizeAll {
		a = 42.rand;
		b = 42.rand;
		c = 42.rannd;
	}

	// an instance method
	coordinates {
		^Point(x, y) // The "^" means to return the result. If not specified, then the object itself will be returned ("^this")
	}


}
