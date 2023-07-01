import com.sun.jna.Library;
import com.sun.jna.Native;

public class LoadLibJNA{
   private interface YourSharedLibraryName extends Library{
      //put shared library functions here with no definition
      public void sharedLibraryfunction();
   }

   public static void main(String[] args){
      YourSharedLibraryName lib = (YourSharedLibraryName)Native.loadLibrary("sharedLibrary",//as in "sharedLibrary.dll"
                                                                          YourSharedLibraryName.class);
      lib.sharedLibraryFunction();
   }
}
