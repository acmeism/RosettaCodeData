public final class InnerClasses {

		public static void main(String[] args) {
		/**
		In Java, inner classes are used to increase encapsulation
		and to logically group together classes that will only be used in one place.
		This can lead to more readable and maintainable code.
		
		For further information visit: https://docs.oracle.com/javase/tutorial/java/javaOO/nested.html
		
		The most common use of inner classes is create an Iterator or Comparator for the outer class.
		For example, the Java language source code uses an inner class to provide a Comparator for the String class.
		
		A good example of inner class use is that the Set and List classes have different implementations of
		an inner Iterator class.
		 */
				
		OuterClass outer = new OuterClass(22);
		OuterClass.InnerClass inner = outer.new InnerClass(20);
		System.out.println(inner.totalValue());
		
		/**
		The inner class cannot be instantiated without using an instance of the outer class,
		unless we have defined a static inner class.
		 */
	}

}

// Define an outer class
final class OuterClass {

    // Constructor for Outer class
    public OuterClass(int aValue) {
    	outerValue = aValue;
    }

    // Define an inner class
    final class InnerClass {

    	 // Constructor for Inner class
    	public InnerClass(int aValue) {
    		innerValue = aValue;
    	}
    	
    	// The inner class has access to the private fields of the outer class
    	public int totalValue() {
    		return outerValue + innerValue;
    	}
    	
    	private int innerValue;    	
    }

    private int outerValue;

}
