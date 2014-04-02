var Quaternion = (function() {
    // The Q() function takes an array argument and changes it
    // prototype so that it becomes a Quaternion instance.  This is
    // scoped only for prototype member access.
    function Q(a) {
	a.__proto__ = proto;
	return a;
    }

    // Actual constructor.  This constructor converts its arguments to
    // an array, then that array to a Quaternion instance, then
    // returns that instance.  (using "new" with this constructor is
    // optional)
    function Quaternion() {
	return Q(Array.prototype.slice.call(arguments, 0, 4));
    }

    // Prototype for all Quaternions
    const proto = {
	// Inherits from a 4-element Array
	__proto__ : [0,0,0,0],

	// Properties -- In addition to Array[0..3] access, we
	// also define matching a, b, c, and d properties
	get a() this[0],
	get b() this[1],
	get c() this[2],
	get d() this[3],

	// Methods
	norm : function() Math.sqrt(this.map(function(x) x*x).reduce(function(x,y) x+y)),
	negate : function() Q(this.map(function(x) -x)),
	conjugate : function() Q([ this[0] ].concat(this.slice(1).map(function(x) -x))),
	add : function(x) {
	    if ("number" === typeof x) {
		return Q([ this[0] + x ].concat(this.slice(1)));
	    } else {
		return Q(this.map(function(v,i) v+x[i]));
	    }
	},
	mul : function(r) {
	    var q = this;
	    if ("number" === typeof r) {
		return Q(q.map(function(e) e*r));
	    } else {
		return Q([ q[0] * r[0] - q[1] * r[1] - q[2] * r[2] - q[3] * r[3],
			   q[0] * r[1] + q[1] * r[0] + q[2] * r[3] - q[3] * r[2],
			   q[0] * r[2] - q[1] * r[3] + q[2] * r[0] + q[3] * r[1],
			   q[0] * r[3] + q[1] * r[2] - q[2] * r[1] + q[3] * r[0] ]);
	    }
	},
	equals : function(q) this.every(function(v,i) v === q[i]),
	toString : function() (this[0] + " + " + this[1] + "i + "+this[2] + "j + " + this[3] + "k").replace(/\+ -/g, '- ')
    };

    Quaternion.prototype = proto;
    return Quaternion;
})();
