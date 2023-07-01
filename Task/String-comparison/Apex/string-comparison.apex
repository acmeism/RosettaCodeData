public class Compare
{
	/**
	 * Test in the developer console:
	 * Compare.compare('Hello', 'Hello');
	 * Compare.compare('5', '5.0');
	 * Compare.compare('java', 'Java');
	 * Compare.compare('ĴÃVÁ', 'ĴÃVÁ');
	*/

    public static void compare (String A, String B)
    {
        if (A.equals(B))
            System.debug(A + ' and  ' + B + ' are lexically equal.');
        else
            System.debug(A + ' and  ' + B + ' are not lexically equal.');

        if (A.equalsIgnoreCase(B))
            System.debug(A + ' and  ' + B + ' are case-insensitive lexically equal.');
        else
            System.debug(A + ' and  ' + B + ' are not case-insensitive lexically equal.');

        if (A.compareTo(B) < 0)
            System.debug(A + ' is lexically before ' + B);
        else if (A.compareTo(B) > 0)
            System.debug(A + ' is lexically after ' + B);

        if (A.compareTo(B) >= 0)
            System.debug(A + ' is not lexically before ' + B);
        if (A.compareTo(B) <= 0)
            System.debug(A + ' is not lexically after ' + B);

        System.debug('The lexical relationship is: ' + A.compareTo(B));
    }
}
