public final class IntegerOverflow {

	public static void main(String[] args) {
		// The following examples show that Java allows integer overflow without warning
		// and calculates an incorrect result.
		
		// From version 8, Java introduced methods which throw an ArithmeticException when overflow occurs,
        // which prevents the calculation of an incorrect result. It also allows the programmer to replace an "int"
        // with a "long" and to replace a "long" with a BigInteger.
		
		// Uncomment the lines below to see the use of the new methods:
		// addExact(), subtractExact(), multiplyExact() and negateExact().
		System.out.println("Signed 32-bit:");
        System.out.println(-(-2_147_483_647 - 1));
//      System.out.println(Math.negateExact(-2_147_483_647 - 1));

        System.out.println(2_000_000_000 + 2_000_000_000);
//      System.out.println(Math.addExact(2_000_000_000, 2_000_000_000));

        System.out.println(-2_147_483_647 - 2_147_483_647);
//      System.out.println(Math.subtractExact(-2_147_483_647, 2_147_483_647));

        System.out.println(46_341 * 46_341);
//      System.out.println(Math.multiplyExact(46_341, 46_341));

        System.out.println((-2_147_483_647 - 1) / -1);
//      System.out.println(Math.negateExact(Math.subtractExact(-2_147_483_647, 1) / 1));

        System.out.println();
        System.out.println("Signed 64-bit:");
        System.out.println(-(-9_223_372_036_854_775_807L - 1));
//      System.out.println(Math.negateExact(-9_223_372_036_854_775_807L - 1));

        System.out.println(5_000_000_000_000_000_000L + 5_000_000_000_000_000_000L);
//      System.out.println(Math.addExact(5_000_000_000_000_000_000L, 5_000_000_000_000_000_000L));

        System.out.println(-9_223_372_036_854_775_807L - 9_223_372_036_854_775_807L);
//      System.out.println(Math.subtractExact(-9_223_372_036_854_775_807L, 9_223_372_036_854_775_807L));

        System.out.println(3_037_000_500L * 3_037_000_500L);
//      System.out.println(Math.multiplyExact(3_037_000_500L, 3_037_000_500L));

        System.out.println((-9_223_372_036_854_775_807L - 1) / -1);
//      System.out.println(Math.negateExact(Math.subtractExact(-9_223_372_036_854_775_807L, 1) / 1));
	}

}
