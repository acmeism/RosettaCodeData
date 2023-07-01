public class Compare
{
    public static void main (String[] args)
    {
        compare("Hello", "Hello");
        compare("5", "5.0");
        compare("java", "Java");
        compare("ĴÃVÁ", "ĴÃVÁ");
        compare("ĴÃVÁ", "ĵãvá");
    }
    public static void compare (String A, String B)
    {
        if (A.equals(B))
            System.out.printf("'%s' and '%s' are lexically equal.", A, B);
        else
            System.out.printf("'%s' and '%s' are not lexically equal.", A, B);
        System.out.println();

        if (A.equalsIgnoreCase(B))
            System.out.printf("'%s' and '%s' are case-insensitive lexically equal.", A, B);
        else
            System.out.printf("'%s' and '%s' are not case-insensitive lexically equal.", A, B);
        System.out.println();

        if (A.compareTo(B) < 0)
            System.out.printf("'%s' is lexically before '%s'.\n", A, B);
        else if (A.compareTo(B) > 0)
            System.out.printf("'%s' is lexically after '%s'.\n", A, B);

        if (A.compareTo(B) >= 0)
            System.out.printf("'%s' is not lexically before '%s'.\n", A, B);
        if (A.compareTo(B) <= 0)
            System.out.printf("'%s' is not lexically after '%s'.\n", A, B);

        System.out.printf("The lexical relationship is: %d\n", A.compareTo(B));
        System.out.printf("The case-insensitive lexical relationship is: %d\n\n", A.compareToIgnoreCase(B));
    }
}
