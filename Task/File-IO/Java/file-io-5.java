import java.nio.file.*;
public class Copy{
   public static void main(String[] args) throws Exception{
      FileSystem fs = FileSystems.getDefault();
      Path in = fs.getPath("input.txt");
      Path out = fs.getPath("output.txt");
      Files.copy(in, out, StandardCopyOption.REPLACE_EXISTING);
   }
}
