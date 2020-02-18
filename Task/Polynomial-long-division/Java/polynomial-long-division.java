import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

public class PolynomialLongDivision {

    public static void main(String[] args) {
        RunDivideTest(new Polynomial(1, 3, -12, 2, -42, 0), new Polynomial(1, 1, -3, 0));
        RunDivideTest(new Polynomial(5, 2, 4, 1, 1, 0), new Polynomial(2, 1, 3, 0));
        RunDivideTest(new Polynomial(5, 10, 4, 7, 1, 0), new Polynomial(2, 4, 2, 2, 3, 0));
        RunDivideTest(new Polynomial(2,7,-24,6,2,5,-108,4,3,3,-120,2,-126,0), new Polynomial(2, 4, 2, 2, 3, 0));
    }

    private static void RunDivideTest(Polynomial p1, Polynomial p2) {
        Polynomial[] result = p1.divide(p2);
        System.out.printf("Compute: (%s) / (%s) = %s reminder %s%n", p1, p2, result[0], result[1]);
        System.out.printf("Test:    (%s) * (%s) + (%s) = %s%n%n", result[0], p2, result[1], result[0].multiply(p2).add(result[1]));
    }

    private static final class Polynomial {

        private List<Term> polynomialTerms;

        //  Format - coeff, exp, coeff, exp, (repeating in pairs) . . .
        public Polynomial(long ... values) {
            if ( values.length % 2 != 0 ) {
                throw new IllegalArgumentException("ERROR 102:  Polynomial constructor.  Length must be even.  Length = " + values.length);
            }
            polynomialTerms = new ArrayList<>();
            for ( int i = 0 ; i < values.length ; i += 2 ) {
                polynomialTerms.add(new Term(BigInteger.valueOf(values[i]), values[i+1]));
            }
            Collections.sort(polynomialTerms, new TermSorter());
        }

        public Polynomial() {
            //  zero
            polynomialTerms = new ArrayList<>();
            polynomialTerms.add(new Term(BigInteger.ZERO, 0));
        }

        private Polynomial(List<Term> termList) {
            if ( termList.size() != 0 ) {
                //  Remove zero terms if needed
                for ( int i = 0 ; i < termList.size() ; i++ ) {
                    if ( termList.get(i).coefficient.compareTo(Integer.ZERO_INT) == 0 ) {
                        termList.remove(i);
                    }
                }
            }
            if ( termList.size() == 0 ) {
                //  zero
                termList.add(new Term(BigInteger.ZERO,0));
            }
            polynomialTerms = termList;
            Collections.sort(polynomialTerms, new TermSorter());
        }

        public Polynomial[] divide(Polynomial v) {
            Polynomial q = new Polynomial();
            Polynomial r = this;
            Number lcv = v.leadingCoefficient();
            long dv = v.degree();
            while ( r.degree() >= dv ) {
                Number lcr = r.leadingCoefficient();
                Number s = lcr.divide(lcv);
                Term term = new Term(s, r.degree() - dv);
                q = q.add(term);
                r = r.add(v.multiply(term.negate()));
            }
            return new Polynomial[] {q, r};
        }

        public Polynomial add(Polynomial polynomial) {
            List<Term> termList = new ArrayList<>();
            int thisCount = polynomialTerms.size();
            int polyCount = polynomial.polynomialTerms.size();
            while ( thisCount > 0 || polyCount > 0 ) {
                Term thisTerm = thisCount == 0 ? null : polynomialTerms.get(thisCount-1);
                Term polyTerm = polyCount == 0 ? null : polynomial.polynomialTerms.get(polyCount-1);
                if ( thisTerm == null ) {
                    termList.add(polyTerm);
                    polyCount--;
                }
                else if (polyTerm == null ) {
                    termList.add(thisTerm);
                    thisCount--;
                }
                else if ( thisTerm.degree() == polyTerm.degree() ) {
                    Term t = thisTerm.add(polyTerm);
                    if ( t.coefficient.compareTo(Integer.ZERO_INT) != 0 ) {
                        termList.add(t);
                    }
                    thisCount--;
                    polyCount--;
                }
                else if ( thisTerm.degree() < polyTerm.degree() ) {
                    termList.add(thisTerm);
                    thisCount--;
                }
                else {
                    termList.add(polyTerm);
                    polyCount--;
                }
            }
            return new Polynomial(termList);
        }

        public Polynomial add(Term term) {
            List<Term> termList = new ArrayList<>();
            boolean added = false;
            for ( int index = 0 ; index < polynomialTerms.size() ; index++ ) {
                Term currentTerm = polynomialTerms.get(index);
                if ( currentTerm.exponent == term.exponent ) {
                    added = true;
                    if ( currentTerm.coefficient.add(term.coefficient).compareTo(Integer.ZERO_INT) != 0 ) {
                        termList.add(currentTerm.add(term));
                    }
                }
                else {
                    termList.add(currentTerm);
                }
            }
            if ( ! added ) {
                termList.add(term);
            }
            return new Polynomial(termList);
        }

        public Polynomial multiply(Polynomial polynomial) {
            List<Term> termList = new ArrayList<>();
            for ( int i = 0 ; i < polynomialTerms.size() ; i++ ) {
                Term ci = polynomialTerms.get(i);
                for ( int j = 0 ; j < polynomial.polynomialTerms.size() ; j++ ) {
                    Term cj = polynomial.polynomialTerms.get(j);
                    Term currentTerm = ci.multiply(cj);
                    boolean added = false;
                    for ( int k = 0 ; k < termList.size() ; k++ ) {
                        if ( currentTerm.exponent == termList.get(k).exponent ) {
                            added = true;
                            Term t = termList.remove(k).add(currentTerm);
                            if ( t.coefficient.compareTo(Integer.ZERO_INT) != 0 ) {
                                termList.add(t);
                            }
                            break;
                        }
                    }
                    if ( ! added ) {
                        termList.add(currentTerm);
                    }
                }
            }
            return new Polynomial(termList);
        }

        public Polynomial multiply(Term term) {
            List<Term> termList = new ArrayList<>();
            for ( int index = 0 ; index < polynomialTerms.size() ; index++ ) {
                Term currentTerm = polynomialTerms.get(index);
                termList.add(currentTerm.multiply(term));
            }
            return new Polynomial(termList);
        }

        public Number leadingCoefficient() {
            return polynomialTerms.get(0).coefficient;
        }

        public long degree() {
            return polynomialTerms.get(0).exponent;
        }

        @Override
        public String toString() {
            StringBuilder sb = new StringBuilder();
            boolean first = true;
            for ( Term term : polynomialTerms ) {
                if ( first ) {
                    sb.append(term);
                    first = false;
                }
                else {
                    sb.append(" ");
                    if ( term.coefficient.compareTo(Integer.ZERO_INT) > 0 ) {
                        sb.append("+ ");
                        sb.append(term);
                    }
                    else {
                        sb.append("- ");
                        sb.append(term.negate());
                    }
                }
            }
            return sb.toString();
        }
    }

    private static final class TermSorter implements Comparator<Term> {
        @Override
        public int compare(Term o1, Term o2) {
            return (int) (o2.exponent - o1.exponent);
        }
    }

    private static final class Term {
        Number coefficient;
        long exponent;

        public Term(BigInteger c, long e) {
            coefficient = new Integer(c);
            exponent = e;
        }

        public Term(Number c, long e) {
            coefficient = c;
            exponent = e;
        }

        public Term multiply(Term term) {
            return new Term(coefficient.multiply(term.coefficient), exponent + term.exponent);
        }

        public Term add(Term term) {
            if ( exponent != term.exponent ) {
                throw new RuntimeException("ERROR 102:  Exponents not equal.");
            }
            return new Term(coefficient.add(term.coefficient), exponent);
        }

        public Term negate() {
            return new Term(coefficient.negate(), exponent);
        }

        public long degree() {
            return exponent;
        }

        @Override
        public String toString() {
            if ( coefficient.compareTo(Integer.ZERO_INT) == 0 ) {
                return "0";
            }
            if ( exponent == 0 ) {
                return "" + coefficient;
            }
            if ( coefficient.compareTo(Integer.ONE_INT) == 0 ) {
                if ( exponent == 1 ) {
                    return "x";
                }
                else {
                    return "x^" + exponent;
                }
            }
            if ( exponent == 1 ) {
                return coefficient + "x";
            }
            return coefficient + "x^" + exponent;
        }
    }

    private static abstract class Number {
        public abstract int compareTo(Number in);
        public abstract Number negate();
        public abstract Number add(Number in);
        public abstract Number multiply(Number in);
        public abstract Number inverse();
        public abstract boolean isInteger();
        public abstract boolean isFraction();

        public Number subtract(Number in) {
            return add(in.negate());
        }

        public Number divide(Number in) {
            return multiply(in.inverse());
        }
    }

    public static class Fraction extends Number {

        private final Integer numerator;
        private final Integer denominator;

        public Fraction(Integer n, Integer d) {
            numerator = n;
            denominator = d;
        }

        @Override
        public int compareTo(Number in) {
            if ( in.isInteger() ) {
                Integer result = ((Integer) in).multiply(denominator);
                return numerator.compareTo(result);
            }
            else if ( in.isFraction() ) {
                Fraction inFrac = (Fraction) in;
                Integer left = numerator.multiply(inFrac.denominator);
                Integer right = denominator.multiply(inFrac.numerator);
                return left.compareTo(right);
            }
            throw new RuntimeException("ERROR:  Unknown number type in Fraction.compareTo");
        }

        @Override
        public Number negate() {
            if ( denominator.integer.signum() < 0 ) {
                return new Fraction(numerator, (Integer) denominator.negate());
            }
            return new Fraction((Integer) numerator.negate(), denominator);
        }

        @Override
        public Number add(Number in) {
            if ( in.isInteger() ) {
                //x/y+z = (x+yz)/y
                return new Fraction((Integer) ((Integer) in).multiply(denominator).add(numerator), denominator);
            }
            else if ( in.isFraction() ) {
                Fraction inFrac = (Fraction) in;
                //  compute a/b + x/y
                //  Let q = gcd(b,y)
                //  Result = ( (a*y + x*b)/q ) / ( b*y/q )
                Integer x = inFrac.numerator;
                Integer y = inFrac.denominator;
                Integer q = y.gcd(denominator);
                Integer temp1 = numerator.multiply(y);
                Integer temp2 = denominator.multiply(x);
                Integer newDenom = denominator.multiply(y).divide(q);
                if ( newDenom.compareTo(Integer.ONE_INT) == 0 ) {
                    return temp1.add(temp2);
                }
                Integer newNum = (Integer) temp1.add(temp2).divide(q);
                Integer gcd2 = newDenom.gcd(newNum);
                if ( gcd2.compareTo(Integer.ONE_INT) == 0 ) {
                    return new Fraction(newNum, newDenom);
                }
                newNum = newNum.divide(gcd2);
                newDenom = newDenom.divide(gcd2);
                if ( newDenom.compareTo(Integer.ONE_INT) == 0 ) {
                    return newNum;
                }
                else if ( newDenom.compareTo(Integer.MINUS_ONE_INT) == 0 ) {
                    return newNum.negate();
                }
                return new Fraction(newNum, newDenom);
            }
            throw new RuntimeException("ERROR:  Unknown number type in Fraction.compareTo");
        }

        @Override
        public Number multiply(Number in) {
            if ( in.isInteger() ) {
                //x/y*z = x*z/y
                Integer temp = numerator.multiply((Integer) in);
                Integer gcd = temp.gcd(denominator);
                if ( gcd.compareTo(Integer.ONE_INT) == 0 || gcd.compareTo(Integer.MINUS_ONE_INT) == 0 ) {
                    return new Fraction(temp, denominator);
                }
                Integer newTop = temp.divide(gcd);
                Integer newBot = denominator.divide(gcd);
                if ( newBot.compareTo(Integer.ONE_INT) == 0 ) {
                    return newTop;
                }
                if ( newBot.compareTo(Integer.MINUS_ONE_INT) == 0 ) {
                    return newTop.negate();
                }
                return new Fraction(newTop, newBot);
            }
            else if ( in.isFraction() ) {
                Fraction inFrac = (Fraction) in;
                //  compute a/b * x/y
                Integer tempTop = numerator.multiply(inFrac.numerator);
                Integer tempBot = denominator.multiply(inFrac.denominator);
                Integer gcd = tempTop.gcd(tempBot);
                if ( gcd.compareTo(Integer.ONE_INT) == 0 || gcd.compareTo(Integer.MINUS_ONE_INT) == 0 ) {
                    return new Fraction(tempTop, tempBot);
                }
                Integer newTop = tempTop.divide(gcd);
                Integer newBot = tempBot.divide(gcd);
                if ( newBot.compareTo(Integer.ONE_INT) == 0 ) {
                    return newTop;
                }
                if ( newBot.compareTo(Integer.MINUS_ONE_INT) == 0 ) {
                    return newTop.negate();
                }
                return new Fraction(newTop, newBot);
            }
            throw new RuntimeException("ERROR:  Unknown number type in Fraction.compareTo");
        }

        @Override
        public boolean isInteger() {
            return false;
        }

        @Override
        public boolean isFraction() {
            return true;
        }

        @Override
        public String toString() {
            return numerator.toString() + "/" + denominator.toString();
        }

        @Override
        public Number inverse() {
            if ( numerator.equals(Integer.ONE_INT) ) {
                return denominator;
            }
            else if ( numerator.equals(Integer.MINUS_ONE_INT) ) {
                return denominator.negate();
            }
            else if ( numerator.integer.signum() < 0 ) {
                return new Fraction((Integer) denominator.negate(), (Integer) numerator.negate());
            }
            return new Fraction(denominator, numerator);
        }
    }

    public static class Integer extends Number {

        private BigInteger integer;
        public static final Integer MINUS_ONE_INT = new Integer(new BigInteger("-1"));
        public static final Integer ONE_INT = new Integer(new BigInteger("1"));
        public static final Integer ZERO_INT = new Integer(new BigInteger("0"));

        public Integer(BigInteger number) {
            this.integer = number;
        }

        public int compareTo(Integer val) {
            return integer.compareTo(val.integer);
        }

        @Override
        public int compareTo(Number in) {
            if ( in.isInteger() ) {
                return compareTo((Integer) in);
            }
            else if ( in.isFraction() ) {
                Fraction frac = (Fraction) in;
                BigInteger result = integer.multiply(frac.denominator.integer);
                return result.compareTo(frac.numerator.integer);
            }
            throw new RuntimeException("ERROR:  Unknown number type in Integer.compareTo");
        }

        @Override
        public Number negate() {
            return new Integer(integer.negate());
        }

        public Integer add(Integer in) {
            return new Integer(integer.add(in.integer));
        }

        @Override
        public Number add(Number in) {
            if ( in.isInteger() ) {
                return add((Integer) in);
            }
            else if ( in.isFraction() ) {
                Fraction f = (Fraction) in;
                Integer top = f.numerator;
                Integer bot = f.denominator;
                return new Fraction((Integer) multiply(bot).add(top), bot);
            }
            throw new RuntimeException("ERROR:  Unknown number type in Integer.add");
        }

        @Override
        public Number multiply(Number in) {
            if ( in.isInteger() ) {
                return multiply((Integer) in);
            }
            else if ( in.isFraction() ) {
                //  a * x/y = ax/y
                Integer x = ((Fraction) in).numerator;
                Integer y = ((Fraction) in).denominator;
                Integer temp = (Integer) multiply(x);
                Integer gcd = temp.gcd(y);
                if ( gcd.compareTo(Integer.ONE_INT) == 0 || gcd.compareTo(Integer.MINUS_ONE_INT) == 0 ) {
                    return new Fraction(temp, y);
                }
                Integer newTop = temp.divide(gcd);
                Integer newBot = y.divide(gcd);
                if ( newBot.compareTo(Integer.ONE_INT) == 0 ) {
                    return newTop;
                }
                if ( newBot.compareTo(Integer.MINUS_ONE_INT) == 0 ) {
                    return newTop.negate();
                }
                return new Fraction(newTop, newBot);
            }
            throw new RuntimeException("ERROR:  Unknown number type in Integer.add");
        }

        public Integer gcd(Integer in) {
            return new Integer(integer.gcd(in.integer));
        }

        public Integer divide(Integer in) {
            return new Integer(integer.divide(in.integer));
        }

        public Integer multiply(Integer in) {
            return new Integer(integer.multiply(in.integer));
        }

        @Override
        public boolean isInteger() {
            return true;
        }

        @Override
        public boolean isFraction() {
            return false;
        }

        @Override
        public String toString() {
            return integer.toString();
        }

        @Override
        public Number inverse() {
            if ( equals(ZERO_INT) ) {
                throw new RuntimeException("Attempting to take the inverse of zero in IntegerExpression");
            }
            else if ( this.compareTo(ONE_INT) == 0 ) {
                return ONE_INT;
            }
            else if ( this.compareTo(MINUS_ONE_INT) == 0 ) {
                return MINUS_ONE_INT;
            }
            return new Fraction(ONE_INT, this);
        }

    }
}
