public class JNIDemo
{
  static
  {  System.loadLibrary("JNIDemo");  }

  public static void main(String[] args)
  {
    System.out.println(callStrdup("Hello World!"));
  }

  private static native String callStrdup(String s);
}
