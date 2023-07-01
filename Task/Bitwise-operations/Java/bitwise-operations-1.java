public static void bitwise(int a, int b){
  System.out.println("a AND b: " + (a & b));
  System.out.println("a OR b: "+ (a | b));
  System.out.println("a XOR b: "+ (a ^ b));
  System.out.println("NOT a: " + ~a);
  System.out.println("a << b: " + (a << b)); // left shift
  System.out.println("a >> b: " + (a >> b)); // arithmetic right shift
  System.out.println("a >>> b: " + (a >>> b)); // logical right shift
  System.out.println("a rol b: " + Integer.rotateLeft(a, b)); //rotate left, Java 1.5+
  System.out.println("a ror b: " + Integer.rotateRight(a, b)); //rotate right, Java 1.5+
}
