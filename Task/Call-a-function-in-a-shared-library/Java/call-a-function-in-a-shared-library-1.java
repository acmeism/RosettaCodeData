public class LoadLib{
   private static native void functionInSharedLib(); //change return type or parameters as necessary

   public static void main(String[] args){
      System.loadLibrary("Path/to/library/here/lib.dll");
      functionInSharedLib();
   }
}
