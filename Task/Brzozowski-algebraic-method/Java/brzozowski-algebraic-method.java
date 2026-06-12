import java.util.Arrays;

public final class BrzozowskiAlgebraicMethod {

	public static void main(String[] args) {
		// Define the NFA transition matrix a
	    RegularExpression[][] a = new RegularExpression[][] {
	    	{ new EmptyExpression(), new CarExpression('a'), new CarExpression('b') },
		    { new CarExpression('b'), new EmptyExpression(), new CarExpression('a') },
		    { new CarExpression('a'), new CarExpression('b'), new EmptyExpression() }
	    };
 	
	    // Define the initial state vector b
	    RegularExpression[] b = new RegularExpression[]
	    	{ new EpsilonExpression(), new EmptyExpression(), new EmptyExpression() };	
	
	    // Apply Brzozowski's algorithm
	    RegularExpression dfaExpr = brzozowski(a, b);

	    // Print the regular expression
	    System.out.println(dfaExpr.display() + System.lineSeparator());

	    // Apply recursive simplification
	    RegularExpression simplifiedDFA = recursiveSimplify(dfaExpr, 0);
	    System.out.println(simplifiedDFA.display());
	}

	private static RegularExpression brzozowski(RegularExpression[][] a, RegularExpression[] b) {
        // Copy the given arrays to avoid mutating them
	    RegularExpression[][] aa = Arrays.copyOf(a, a.length);
	    RegularExpression[] bb = Arrays.copyOf(b, b.length);
	
	    for ( int i = a.length - 1; i >= 0; i-- ) {
	        bb[i] = new ConcatExpression( new StarExpression(aa[i][i]), bb[i] );
	        for ( int j = 0; j < i; j++ ) {
	            aa[i][j] = new ConcatExpression( new StarExpression(aa[i][i]), aa[i][j] );
	        }
	        for ( int k = 0; k < i; k++ ) {
	            bb[k] = new UnionExpression( bb[k], new ConcatExpression(aa[k][i], bb[i]) );
	            for ( int m = 0; m < i; m++ ) {
	                aa[k][m] = new UnionExpression( aa[k][m], new ConcatExpression(aa[k][i], aa[i][m]) );
	            }
	        }
	        for ( int n = 0; n < i; n++ ) {
	            aa[n][i] = new EmptyExpression();
	        }
	    }
	    return bb[0];
	}
	
	private static RegularExpression recursiveSimplify(RegularExpression expression, int depth) {
	    if ( depth > 200 ) {
	        return expression;
	    }
	
        RegularExpression simplified = expression.simplify();
        if ( simplified.equals(expression) ) {
            return simplified;
        }
        return recursiveSimplify(simplified, depth + 1);
	}
	
	private static abstract class RegularExpression {
		
		protected abstract RegularExpression simplify();
		protected abstract String display();
		protected abstract boolean equals(RegularExpression other);
		
	}
	
	private static final class EmptyExpression extends RegularExpression {
		
		@Override
		protected RegularExpression simplify() {
	        return new EmptyExpression();
	    }
		
		@Override
		protected String display() {
		    return "0";
		}
		
		@Override
	    protected boolean equals(RegularExpression other) {
	        return switch ( other ) {
	        	case EmptyExpression empty -> true;
	        	case RegularExpression regular -> false;
	        };
	    }
		
	}

	private static final class EpsilonExpression extends RegularExpression {
		
		@Override
	    protected RegularExpression simplify() {
	        return new EpsilonExpression();
	    }
	
	    @Override
	    protected String display() {
	        return "1";
	    }
	
	    @Override
	    protected boolean equals(RegularExpression other) {
	    	 return switch ( other ) {
	        	case EpsilonExpression epsilon -> true;
	        	case RegularExpression regular -> false;
	        };
	    }
	
	}
	
	private static final class CarExpression extends RegularExpression {

	    public CarExpression(char aChar) {
	    	ch = aChar;
	    }
	
	    @Override
	    protected RegularExpression simplify() {
	        return new CarExpression(ch);
	    }
	
	    @Override
	    protected String display() {
	        return String.valueOf(ch);
	    }
	
	    @Override
	    protected boolean equals(RegularExpression other) {
	    	return switch ( other ) {
	    		case CarExpression car -> ch == car.ch;
	    		case RegularExpression regular -> false;
	    	};
	    }
	
	    private final char ch;
	
	}
	
	private static final class UnionExpression extends RegularExpression {	
		
	    public UnionExpression(RegularExpression aE, RegularExpression aF) {
	    	e = aE;
	    	f = aF;
	    }
	
	    @Override
	    protected RegularExpression simplify() {	
    	    RegularExpression se = e.simplify();
    	    RegularExpression sf = f.simplify();
    	
    	    if ( se.equals(sf) ) {
    	        return se;
    	    }
    	
    	    return switch ( se ) {
    	    	case UnionExpression uni -> new UnionExpression(uni.e, new UnionExpression(uni.f, sf));
    	    	case EmptyExpression empty -> sf;
    	    	case RegularExpression regular -> switch ( sf ) {
    	    		case EmptyExpression empty -> se;
    	    		case RegularExpression reg -> new UnionExpression(se, sf);
    	    	};
    	    };
	    }
	
	    @Override
	    protected String display() {
	        return e.display() + "+" + f.display();
	    }
	
	    @Override
	    protected boolean equals(RegularExpression other) {
	    	return switch ( other ) {
	    		case UnionExpression union ->
	    			// Since Union is commutative, check both orders of the parameters e and f
	    			( e.equals(union.e) && f.equals(union.f) ) || ( e.equals(union.f) && f.equals(union.e) );
	    		case RegularExpression regular -> false;
	    	};
	    }
	
	    private final RegularExpression e, f;
	
	}
	
	private static final class ConcatExpression extends RegularExpression {		
	
	    public ConcatExpression(RegularExpression aE, RegularExpression aF) {
	    	e = aE;
	    	f = aF;
	    }
	
	    @Override
		protected RegularExpression simplify() {
	    	RegularExpression se = e.simplify();
    	    RegularExpression sf = f.simplify();
    	
    	    return switch ( se ) {
    	    	case EpsilonExpression epsilon -> sf;
    	    	case RegularExpression regular -> switch ( sf ) {
    	    		case EpsilonExpression epsilon -> se;
    	    		case EmptyExpression empty -> new EmptyExpression();
    	    		case RegularExpression reg -> switch ( se ) {
    	    			case EmptyExpression empty -> new EmptyExpression();
    	    			case ConcatExpression c -> new ConcatExpression(c.e, new ConcatExpression(c.f, sf));
    	    			case RegularExpression regula -> new ConcatExpression(se, sf);
    	    		};
    	    	};
    	    };
	    }
	
	    @Override
	    protected String display() {
	        return "(" + e.display() + ")(" + f.display() + ")";
	    }
	
	    @Override
	    protected boolean equals(RegularExpression other) {
	    	return switch ( other ) {
    			case UnionExpression union -> e.equals(union.e) && f.equals(union.f);
    			case RegularExpression regular -> false;
	    	};
	    }
	
	    private final RegularExpression e, f;
	
	}
	
	private static final class StarExpression extends RegularExpression {
		
		public StarExpression(RegularExpression aE) {
	    	e = aE;
	    }
		
		@Override
		protected RegularExpression simplify() {		
		    RegularExpression se = e.simplify();
		    return switch ( se ) {
		    	case EmptyExpression empty -> new EpsilonExpression();
		    	case EpsilonExpression epsilon -> new EpsilonExpression();
		    	case RegularExpression regular -> new StarExpression(se);
		    };
	    }
	
	    @Override
	    protected String display() {
	        return "(" + e.display() + ")*";
	    }
	
	    @Override
	    protected boolean equals(RegularExpression other) {
	        return switch ( other ) {
	        	case StarExpression star -> e.equals(star.e);
	        	case RegularExpression regular -> false;
	        };	
	    }
	
	    private final RegularExpression e;
	
	}

}
