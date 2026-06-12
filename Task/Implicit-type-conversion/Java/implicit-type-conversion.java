public class ImplicitTypeConversion{
   public static void main(String...args){
      System.out.println( "Primitive conversions" );
      byte  by = -1;
      short sh = by;
      int   in = sh;
      long  lo = in;
      System.out.println( "byte value    -1         to 3 integral types:  " + lo );

      float  fl = 0.1f;
      double db = fl;
      System.out.println( "float value   0.1        to double:            " + db );

      int    in2 = -1;
      float  fl2 = in2;
      double db2 = fl2;
      System.out.println( "int value     -1         to float and double:  " + db2 );

      int    in3 = Integer.MAX_VALUE;
      float  fl3 = in3;
      double db3 = fl3;
      System.out.println( "int value     " + Integer.MAX_VALUE + " to float and double:  " + db3 );

      char   ch  = 'a';
      int    in4 = ch;
      double db4 = in4;
      System.out.println( "char value    '" + ch + "'        to int and double:    " + db4 );

      System.out.println();
      System.out.println( "Boxing and unboxing" );
      Integer in5 = -1;
      int     in6 = in5;
      System.out.println( "int  value    -1         to Integer and int:   " + in6 );

      Double db5 = 0.1;
      double db6 = db5;
      System.out.println( "double value  0.1        to Double and double: " + db6 );
   }
}
