import java.io.File;
public class FileExistsTest {
   public static boolean isFileExists(String filename) {
       boolean exists = new File(filename).exists();
       return exists;
   }
   public static void test(String type, String filename) {
       System.out.println("The following " + type + " called " + filename +
           (isFileExists(filename) ? " exists." : " not exists.")
       );
   }
   public static void main(String args[]) {
        test("file", "input.txt");
        test("file", File.separator + "input.txt");
        test("directory", "docs");
        test("directory", File.separator + "docs" + File.separator);
   }
}
