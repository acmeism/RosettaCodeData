public final class NKTgLaw {

	public static void main() {
		nktg(2.0, 3.0, 4.0, -0.5).display();
	}
	
	private static Result nktg(double x, double v, double m, double dm_dt) {
	    final double p     = m * v;
	    final double nktg1 = x * p;
	    final double nktg2 = dm_dt * p;

	    String tendency1 = ( nktg1 > 0 ) ? "Moving away from stable state"
	    	             : ( nktg1 < 0 ) ? "Moving toward stable state" : "Stable equilibrium";

	    String tendency2 = ( nktg2 > 0 ) ? "Mass variation supports movement"
	    		         : ( nktg2 < 0 ) ? "Mass variation resists movement" : "No mass variation effect";

	    return new Result(p, nktg1, nktg2, tendency1, tendency2);
	}
	
	private record Result(double momentum, double NKTg1, double NKTg2, String tendency1, String tendency2) {
		
		public void display() {			
			IO.println("p         : " + momentum);
			IO.println("NKTg1     : " + NKTg1);
			IO.println("NKTg2     : " + NKTg2);
			IO.println("Tendency1 : " + tendency1);
			IO.println("Tendency2 : " + tendency2);
		}
		
	}

}
