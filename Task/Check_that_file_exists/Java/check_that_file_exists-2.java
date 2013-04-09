import java.nio.file.FileSystem;
import java.nio.file.FileSystems;
import java.nio.file.Files;
public class FileExistsTest{
   private static FileSystem defaultFS = FileSystems.getDefault();
   public static boolean isFileExists(String filename){
       return Files.exists(defaultFS.getPath(filename));
   }
   public static void test(String type, String filename){
       System.out.println("The following " + type + " called " + filename +
           (isFileExists(filename) ? " exists." : " not exists.")
       );
   }
   public static void main(String args[]){
        test("file", "input.txt");
        test("file", defaultFS.getSeparator() + "input.txt");
        test("directory", "docs");
        test("directory", defaultFS.getSeparator() + "docs" + defaultFS.getSeparator());
   }
}
