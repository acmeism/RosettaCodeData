public final class CentreAndRadiusOfACirclePassingThrough3PointsInAPlane {

	public static void main(String[] args) {
		Circle circle = computeCircle( new Point(22.83, 2.07), new Point(14.39, 30.24), new Point(33.65, 17.31) );
		System.out.println(circle);
	}
	
	private static Circle computeCircle(Point pointOne, Point pointTwo, Point pointThree) {
	    double centreX = 0.5 *
	    	(
	            ( pointOne.x * pointOne.x + pointOne.y * pointOne.y ) * ( pointThree.y - pointTwo.y ) +
	            ( pointTwo.x * pointTwo.x + pointTwo.y * pointTwo.y ) * ( pointOne.y - pointThree.y ) +
	            ( pointThree.x * pointThree.x + pointThree.y * pointThree.y ) * ( pointTwo.y - pointOne.y )
	        )
                /
	    	(
	              pointOne.x * ( pointThree.y - pointTwo.y ) +
	              pointTwo.x * ( pointOne.y - pointThree.y ) +
	              pointThree.x * ( pointTwo.y - pointOne.y )
            );
	
	    double centreY = 0.5 *
	    	(
	    		( pointOne.x * pointOne.x + pointOne.y * pointOne.y ) * ( pointThree.x - pointTwo.x ) +
	 	        ( pointTwo.x * pointTwo.x + pointTwo.y * pointTwo.y ) * ( pointOne.x - pointThree.x ) +
	 	        ( pointThree.x * pointThree.x + pointThree.y * pointThree.y ) * ( pointTwo.x - pointOne.x )
	        )
                /
	    	(
	    		  pointOne.y * ( pointThree.x - pointTwo.x ) +
		          pointTwo.y * ( pointOne.x - pointThree.x ) +
		          pointThree.y * ( pointTwo.x - pointOne.x )
	    	);

	    double radius = Math.sqrt( ( centreX - pointOne.x ) * ( centreX - pointOne.x ) +
	    						   ( centreY - pointOne.y ) * ( centreY - pointOne.y ) );
	
	    return new Circle( new Point(centreX, centreY), radius);	
	}
	
	private static record Circle(Point centre, double radius) {

		public String toString() {
			return "centre: (" + format(centre.x) + ", " + format(centre.y) + "), radius = " + format(radius);
		}
		
		private String format(double value) {
			return String.format("%.5f", value);
		}
		
	}
	
	private static record Point(double x, double y) {}

}
