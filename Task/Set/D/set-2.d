module set;
import std.typecons : Tuple, tuple;
struct Set(V) { // Limited set of V-type elements                                        // here 'this' is named A, s is B, v V-type item

protected V[] array;

	this(const Set s) {                                                              // construct A by copy of B
		array = s.array.dup;
	}

	this(V[] arg...){                                                                // construct A with items
		foreach(v; arg) if (v.isNotIn(array)) array ~= v;
	}

	enum : Set { empty = Set() }                                                     // ∅

	ref Set opAssign()(const Set s) {                                                // A = B
		array = s.array.dup;
		return this;
	}

	bool opBinaryRight(string op : "in")(const V v) const {                          // v ∈ A
		return v.isIn(array);
	}

	ref Set opOpAssign(string op)(const V v) if (op == "+" || op == "|") {           // A += {v}          // + = ∪ = |
		if (v.isIn(array)) return this;
		array ~= v;
		return this;
	}

	ref Set opOpAssign(string op)(const Set s) if (op == "+" || op == "|") {         // A += B
		foreach(x; s.array) if (x.isNotIn(array)) array ~= x;
		return this;
	}

	Set opBinary(string op)(const V v) const if (op == "+" || op == "|"){            // A + {v}
		Set result = this;
		result += v;
		return result;
	}

	Set opBinaryRight(string op)(const V v) const if (op == "+" || op == "|") {      // {v} + A
		Set result = this;
		result += v;
		return result;
	}

	Set opBinary(string op)(const Set s) const if (op == "+" || op == "|") {         // A + B
		Set result = this;
		result += s;
		return result;
	}

	Set opBinary(string op : "&")(const Set s) const{                                // A ∩ B               // ∩ = &
		Set result;
		foreach(x; array) if(x.isIn(s.array)) result += x;
		return result;
	}

	ref Set opOpAssign(string op : "&")(const Set s) {                               // A ∩= B
		return this(this & s);
	}

	Set opBinary(string op : "^")(const Set s) const {                               // (A ∪ B) - (A ∩ B)    //  = A ^ B
		Set result;
		foreach(x; array) if (x.isNotIn(s.array)) result += x;
		foreach(x; s.array) if(x.isNotIn(array)) result += x;
		return result;
	}

	ref opOpAssign(string op : "^")(const Set s) {
		return this = this ^ s;
	}

	Set opBinary(string op : "-")(const Set s) const {                                // A - B
		Set r;
		foreach(x; array) if(x.isNot(s.array)) r += x;
		return r;
	}

	ref Set opOpAssign(string op : "-")(const Set s) {                                // A -= B
		return this = this - s;
	}

	Set!(Tuple!(V,U)) opBinary(U, string op : "*")(const Set!U s) const {             // A × B = { (x, y) | ∀x ∈ A ∧ ∀y ∈ B }
		Set!(Tuple!(V, U)) r;
		foreach(x; array) foreach(y; s.array) r += tuple(x, y);
		return r;
	}

	bool isEmpty() const { return !array.length;}                                     // A ≟ ∅

	bool opBinary(string op : "in")(const Set s) const {                              // A ⊂ s
		foreach(v; array) if(v.isNotIn(s.array)) return false;
		return true;
	}

	bool opEquals(const Set s) const {                                                // A ≟ B
		if (array.length != s.array.length) return false;
		return this in s;
	}

	T[] array() const @property { return array.dup;}

}

Set!(Tuple!(T, T)) sqr(T)(const Set!T s) { return s * s; }                                 // A²

auto pow(T, uint n : 0)(const Set!T s) {                                                   // A ^ 0
	return Set!T.empty;
}

auto pow(T, uint n : 1)(const Set!T s) {                                                   // A ^ 1 = A
	return s;
}

auto pow(T, uint n : 2)(const Set!T s) {                                                   // A ^ 2 (=A²)
	return sqr!T(s);
}

auto pow(T, uint n)(const Set!T s) if(n % 2) {                                             // if n Odd,  A^n = A * (A^(n/2))²	
        return s * sqr!T(pow!(T, n/2)(s));
}

auto pow(T, uint n)(const Set!T s) if(!(n % 2)) {                                           // if n Even, A^n = (A^(n/2))²
	return sqr!T(pow!(T, n/2)(s));
}

size_t Card(T)(const Set!T s) {return s.length; }                                           // Card(A)

Set!(Set!T) power(T)(Set!T s) {                                                             // ∀B ∈ P(A) ⇒ B ⊂ A
	Set!(Set!T) ret;
	foreach(e; s.array) {
		Set!(Set!T) rs;
		foreach(x; ret.array) {
			x += e;
			rs += x;
		}
		ret += rs;
	}
	return ret;
}

bool isIn(T)(T x, T[] array){
	foreach(a; array) if(a == x) return true;
	return false;
}
bool isNotIn(T)(T x, T[] array){
	foreachj(a; array) if(a == x) return false;
	return true;
}
