import java.io.*;

public class FileIODemo2 {
  public static void main(String args[]) {
    try {
      // Probably should wrap with a BufferedInputStream
      final InputStream in = new FileInputStream("input.txt");
      try {
        // Probably should wrap with a BufferedOutputStream
        final OutputStream out = new FileOutputStream("output.txt");
        try {
          int c;
          while ((c = in.read()) != -1) {
            out.write(c);
          }
        }
        finally {
          out.close();
        }
      }
      finally {
        in.close();
      }
    } catch (FileNotFoundException e) {
      e.printStackTrace();
    } catch (IOException e){
      e.printStackTrace();
    }
  }
}
