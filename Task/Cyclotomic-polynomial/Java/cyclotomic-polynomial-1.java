import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

public class CyclotomicPolynomial {

    @SuppressWarnings("unused")
    private static int divisions = 0;
    private static int algorithm = 2;

    public static void main(String[] args) throws Exception {
        System.out.println("Task 1:  cyclotomic polynomials for n <= 30:");
        for ( int i = 1 ; i <= 30 ; i++ ) {
            Polynomial p = cyclotomicPolynomial(i);
            System.out.printf("CP[%d] = %s%n", i, p);
        }
        System.out.println("Task 2:  Smallest cyclotomic polynomial with n or -n as a coefficient:");
        int n = 0;
        for ( int i = 1 ; i <= 10 ; i++ ) {
            while ( true ) {
                n++;
                Polynomial cyclo = cyclotomicPolynomial(n);
                if ( cyclo.hasCoefficientAbs(i) ) {
                    System.out.printf("CP[%d] has coefficient with magnitude = %d%n", n, i);
                    n--;
                    break;
                }
            }
        }
    }

    private static final Map<Integer, Polynomial> COMPUTED = new HashMap<>();

    private static Polynomial cyclotomicPolynomial(int n) {
        if ( COMPUTED.containsKey(n) ) {
            return COMPUTED.get(n);
        }

        //System.out.println("COMPUTE:  n = " + n);

        if ( n == 1 ) {
            //  Polynomial:  x - 1
            Polynomial p = new Polynomial(1, 1, -1, 0);
            COMPUTED.put(1, p);
            return p;
        }

        Map<Integer,Integer> factors = getFactors(n);

        if ( factors.containsKey(n) ) {
            //  n prime
            List<Term> termList = new ArrayList<>();
            for ( int index = 0 ; index < n ; index++ ) {
                termList.add(new Term(1, index));
            }

            Polynomial cyclo = new Polynomial(termList);
            COMPUTED.put(n, cyclo);
            return cyclo;
        }
        else if ( factors.size() == 2 && factors.containsKey(2) && factors.get(2) == 1 && factors.containsKey(n/2) && factors.get(n/2) == 1 ) {
            //  n = 2p
            int prime = n/2;
            List<Term> termList = new ArrayList<>();
            int coeff = -1;
            for ( int index = 0 ; index < prime ; index++ ) {
                coeff *= -1;
                termList.add(new Term(coeff, index));
            }

            Polynomial cyclo = new Polynomial(termList);
            COMPUTED.put(n, cyclo);
            return cyclo;
        }
        else if ( factors.size() == 1 && factors.containsKey(2) ) {
            //  n = 2^h
            int h = factors.get(2);
            List<Term> termList = new ArrayList<>();
            termList.add(new Term(1, (int) Math.pow(2, h-1)));
            termList.add(new Term(1, 0));
            Polynomial cyclo = new Polynomial(termList);
            COMPUTED.put(n, cyclo);
            return cyclo;
        }
        else if ( factors.size() == 1 && ! factors.containsKey(n) ) {
            // n = p^k
            int p = 0;
            for ( int prime : factors.keySet() ) {
                p = prime;
            }
            int k = factors.get(p);
            List<Term> termList = new ArrayList<>();
            for ( int index = 0 ; index < p ; index++ ) {
                termList.add(new Term(1, index * (int) Math.pow(p, k-1)));
            }

            Polynomial cyclo = new Polynomial(termList);
            COMPUTED.put(n, cyclo);
            return cyclo;
        }
        else if ( factors.size() == 2 && factors.containsKey(2) ) {
            //  n = 2^h * p^k
            int p = 0;
            for ( int prime : factors.keySet() ) {
                if ( prime != 2 ) {
                    p = prime;
                }
            }
            List<Term> termList = new ArrayList<>();
            int coeff = -1;
            int twoExp = (int) Math.pow(2, factors.get(2)-1);
            int k = factors.get(p);
            for ( int index = 0 ; index < p ; index++ ) {
                coeff *= -1;
                termList.add(new Term(coeff, index * twoExp * (int) Math.pow(p, k-1)));
            }

            Polynomial cyclo = new Polynomial(termList);
            COMPUTED.put(n, cyclo);
            return cyclo;
        }
        else if ( factors.containsKey(2) && ((n/2) % 2 == 1) && (n/2) > 1 ) {
            //  CP(2m)[x] = CP(-m)[x], n odd integer > 1
            Polynomial cycloDiv2 = cyclotomicPolynomial(n/2);
            List<Term> termList = new ArrayList<>();
            for ( Term term : cycloDiv2.polynomialTerms ) {
                termList.add(term.exponent % 2 == 0 ? term : term.negate());
            }
            Polynomial cyclo = new Polynomial(termList);
            COMPUTED.put(n, cyclo);
            return cyclo;
        }

        //  General Case

        if ( algorithm == 0 ) {
            //  Slow - uses basic definition.
            List<Integer> divisors = getDivisors(n);
            //  Polynomial:  ( x^n - 1 )
            Polynomial cyclo = new Polynomial(1, n, -1, 0);
            for ( int i : divisors ) {
                Polynomial p = cyclotomicPolynomial(i);
                cyclo = cyclo.divide(p);
            }

            COMPUTED.put(n, cyclo);
            return cyclo;
        }
        else if ( algorithm == 1 ) {
            //  Faster.  Remove Max divisor (and all divisors of max divisor) - only one divide for all divisors of Max Divisor
            List<Integer> divisors = getDivisors(n);
            int maxDivisor = Integer.MIN_VALUE;
            for ( int div : divisors ) {
                maxDivisor = Math.max(maxDivisor, div);
            }
            List<Integer> divisorsExceptMax = new ArrayList<Integer>();
            for ( int div : divisors ) {
                if ( maxDivisor % div != 0 ) {
                    divisorsExceptMax.add(div);
                }
            }

            //  Polynomial:  ( x^n - 1 ) / ( x^m - 1 ), where m is the max divisor
            Polynomial cyclo = new Polynomial(1, n, -1, 0).divide(new Polynomial(1, maxDivisor, -1, 0));
            for ( int i : divisorsExceptMax ) {
                Polynomial p = cyclotomicPolynomial(i);
                cyclo = cyclo.divide(p);
            }

            COMPUTED.put(n, cyclo);

            return cyclo;
        }
        else if ( algorithm == 2 ) {
            //  Fastest
            //  Let p ; q be primes such that p does not divide n, and q q divides n.
            //  Then CP(np)[x] = CP(n)[x^p] / CP(n)[x]
            int m = 1;
            Polynomial cyclo = cyclotomicPolynomial(m);
            List<Integer> primes = new ArrayList<>(factors.keySet());
            Collections.sort(primes);
            for ( int prime : primes ) {
                //  CP(m)[x]
                Polynomial cycloM = cyclo;
                //  Compute CP(m)[x^p].
                List<Term> termList = new ArrayList<>();
                for ( Term t : cycloM.polynomialTerms ) {
                    termList.add(new Term(t.coefficient, t.exponent * prime));
                }
                cyclo = new Polynomial(termList).divide(cycloM);
                m = m * prime;
            }
            //  Now, m is the largest square free divisor of n
            int s = n / m;
            //  Compute CP(n)[x] = CP(m)[x^s]
            List<Term> termList = new ArrayList<>();
            for ( Term t : cyclo.polynomialTerms ) {
                termList.add(new Term(t.coefficient, t.exponent * s));
            }
            cyclo = new Polynomial(termList);
            COMPUTED.put(n, cyclo);

            return cyclo;
        }
        else {
            throw new RuntimeException("ERROR 103:  Invalid algorithm.");
        }
    }

    private static final List<Integer> getDivisors(int number) {
        List<Integer> divisors = new ArrayList<Integer>();
        long sqrt = (long) Math.sqrt(number);
        for ( int i = 1 ; i <= sqrt ; i++ ) {
            if ( number % i == 0 ) {
                divisors.add(i);
                int div = number / i;
                if ( div != i && div != number ) {
                    divisors.add(div);
                }
            }
        }
        return divisors;
    }

    private static final Map<Integer,Map<Integer,Integer>> allFactors = new TreeMap<Integer,Map<Integer,Integer>>();
    static {
        Map<Integer,Integer> factors = new TreeMap<Integer,Integer>();
        factors.put(2, 1);
        allFactors.put(2, factors);
    }

    public static Integer MAX_ALL_FACTORS = 100000;

    public static final Map<Integer,Integer> getFactors(Integer number) {
        if ( allFactors.containsKey(number) ) {
            return allFactors.get(number);
        }
        Map<Integer,Integer> factors = new TreeMap<Integer,Integer>();
        if ( number % 2 == 0 ) {
            Map<Integer,Integer> factorsdDivTwo = getFactors(number/2);
            factors.putAll(factorsdDivTwo);
            factors.merge(2, 1, (v1, v2) -> v1 + v2);
            if ( number < MAX_ALL_FACTORS )
                allFactors.put(number, factors);
            return factors;
        }
        boolean prime = true;
        long sqrt = (long) Math.sqrt(number);
        for ( int i = 3 ; i <= sqrt ; i += 2 ) {
            if ( number % i == 0 ) {
                prime = false;
                factors.putAll(getFactors(number/i));
                factors.merge(i, 1, (v1, v2) -> v1 + v2);
                if ( number < MAX_ALL_FACTORS )
                    allFactors.put(number, factors);
                return factors;
            }
        }
        if ( prime ) {
            factors.put(number, 1);
            if ( number < MAX_ALL_FACTORS )
                allFactors.put(number, factors);
        }
        return factors;
    }

    private static final class Polynomial {

        private List<Term> polynomialTerms;

        //  Format - coeff, exp, coeff, exp, (repeating in pairs) . . .
        public Polynomial(int ... values) {
            if ( values.length % 2 != 0 ) {
                throw new IllegalArgumentException("ERROR 102:  Polynomial constructor.  Length must be even.  Length = " + values.length);
            }
            polynomialTerms = new ArrayList<>();
            for ( int i = 0 ; i < values.length ; i += 2 ) {
                Term t = new Term(values[i], values[i+1]);
                polynomialTerms.add(t);
            }
            Collections.sort(polynomialTerms, new TermSorter());
        }

        public Polynomial() {
            //  zero
            polynomialTerms = new ArrayList<>();
            polynomialTerms.add(new Term(0,0));
        }

        private boolean hasCoefficientAbs(int coeff) {
            for ( Term term : polynomialTerms ) {
                if ( Math.abs(term.coefficient) == coeff ) {
                    return true;
                }
            }
            return false;
        }

        private Polynomial(List<Term> termList) {
            if ( termList.size() == 0 ) {
                //  zero
                termList.add(new Term(0,0));
            }
            else {
                //  Remove zero terms if needed
                for ( int i = 0 ; i < termList.size() ; i++ ) {
                    if ( termList.get(i).coefficient == 0 ) {
                        termList.remove(i);
                    }
                }
            }
            if ( termList.size() == 0 ) {
                //  zero
                termList.add(new Term(0,0));
            }
            polynomialTerms = termList;
            Collections.sort(polynomialTerms, new TermSorter());
        }

        public Polynomial divide(Polynomial v) {
            //long start = System.currentTimeMillis();
            divisions++;
            Polynomial q = new Polynomial();
            Polynomial r = this;
            long lcv = v.leadingCoefficient();
            long dv = v.degree();
            while ( r.degree() >= v.degree() ) {
                long lcr = r.leadingCoefficient();
                long s = lcr / lcv;  //  Integer division
                Term term = new Term(s, r.degree() - dv);
                q = q.add(term);
                r = r.add(v.multiply(term.negate()));
            }
            //long end = System.currentTimeMillis();
            //System.out.printf("Divide:  Elapsed = %d, Degree 1 = %d, Degree 2 = %d%n", (end-start), this.degree(), v.degree());
            return q;
        }

        public Polynomial add(Polynomial polynomial) {
            List<Term> termList = new ArrayList<>();
            int thisCount = polynomialTerms.size();
            int polyCount = polynomial.polynomialTerms.size();
            while ( thisCount > 0 || polyCount > 0 ) {
                Term thisTerm = thisCount == 0 ? null : polynomialTerms.get(thisCount-1);
                Term polyTerm = polyCount == 0 ? null : polynomial.polynomialTerms.get(polyCount-1);
                if ( thisTerm == null ) {
                    termList.add(polyTerm.clone());
                    polyCount--;
                }
                else if (polyTerm == null ) {
                    termList.add(thisTerm.clone());
                    thisCount--;
                }
                else if ( thisTerm.degree() == polyTerm.degree() ) {
                    Term t = thisTerm.add(polyTerm);
                    if ( t.coefficient != 0 ) {
                        termList.add(t);
                    }
                    thisCount--;
                    polyCount--;
                }
                else if ( thisTerm.degree() < polyTerm.degree() ) {
                    termList.add(thisTerm.clone());
                    thisCount--;
                }
                else {
                    termList.add(polyTerm.clone());
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
                    if ( currentTerm.coefficient + term.coefficient != 0 ) {
                        termList.add(currentTerm.add(term));
                    }
                }
                else {
                    termList.add(currentTerm.clone());
                }
            }
            if ( ! added ) {
                termList.add(term.clone());
            }
            return new Polynomial(termList);
        }

        public Polynomial multiply(Term term) {
            List<Term> termList = new ArrayList<>();
            for ( int index = 0 ; index < polynomialTerms.size() ; index++ ) {
                Term currentTerm = polynomialTerms.get(index);
                termList.add(currentTerm.clone().multiply(term));
            }
            return new Polynomial(termList);
        }

        public Polynomial clone() {
            List<Term> clone = new ArrayList<>();
            for ( Term t : polynomialTerms ) {
                clone.add(new Term(t.coefficient, t.exponent));
            }
            return new Polynomial(clone);
        }

        public long leadingCoefficient() {
//            long coefficient = 0;
//            long degree = Integer.MIN_VALUE;
//            for ( Term t : polynomialTerms ) {
//                if ( t.degree() > degree ) {
//                    coefficient = t.coefficient;
//                    degree = t.degree();
//                }
//            }
            return polynomialTerms.get(0).coefficient;
        }

        public long degree() {
//            long degree = Integer.MIN_VALUE;
//            for ( Term t : polynomialTerms ) {
//                if ( t.degree() > degree ) {
//                    degree = t.degree();
//                }
//            }
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
                    if ( term.coefficient > 0 ) {
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

    //  Note:  Cyclotomic Polynomials have small coefficients.  Not appropriate for general polynomial usage.
    private static final class Term {
        long coefficient;
        long exponent;

        public Term(long c, long e) {
            coefficient = c;
            exponent = e;
        }

        public Term clone() {
            return new Term(coefficient, exponent);
        }

        public Term multiply(Term term) {
            return new Term(coefficient * term.coefficient, exponent + term.exponent);
        }

        public Term add(Term term) {
            if ( exponent != term.exponent ) {
                throw new RuntimeException("ERROR 102:  Exponents not equal.");
            }
            return new Term(coefficient + term.coefficient, exponent);
        }

        public Term negate() {
            return new Term(-coefficient, exponent);
        }

        public long degree() {
            return exponent;
        }

        @Override
        public String toString() {
            if ( coefficient == 0 ) {
                return "0";
            }
            if ( exponent == 0 ) {
                return "" + coefficient;
            }
            if ( coefficient == 1 ) {
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

}
