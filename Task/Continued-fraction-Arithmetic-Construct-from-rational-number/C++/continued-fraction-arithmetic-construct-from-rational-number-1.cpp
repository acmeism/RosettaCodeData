#include <iostream>
/* Interface for all Continued Fractions
   Nigel Galloway, February 9th., 2013.
*/
class ContinuedFraction {
	public:
	virtual const int nextTerm(){};
	virtual const bool moreTerms(){};
};
/* Create a continued fraction from a rational number
   Nigel Galloway, February 9th., 2013.
*/
class r2cf : public ContinuedFraction {
	private: int n1, n2;
	public:
	r2cf(const int numerator, const int denominator): n1(numerator), n2(denominator){}
	const int nextTerm() {
		const int thisTerm = n1/n2;
		const int t2 = n2; n2 = n1 - thisTerm * n2; n1 = t2;
		return thisTerm;
	}
	const bool moreTerms() {return fabs(n2) > 0;}
};
/* Generate a continued fraction for sqrt of 2
   Nigel Galloway, February 9th., 2013.
*/
class SQRT2 : public ContinuedFraction {
	private: bool first=true;
	public:
	const int nextTerm() {if (first) {first = false; return 1;} else return 2;}
	const bool moreTerms() {return true;}
};
