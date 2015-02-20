import java.io.*;
import java.nio.channels.*;

public class FileIODemo3 {
  public static void main(String args[]) {
    try {
      final FileChannel in = new FileInputStream("input.txt").getChannel();
      try {
        final FileChannel out = new FileOutputStream("output.txt").getChannel();
        try {
          out.transferFrom(in, 0, in.size());
        }
        finally {
          out.close();
        }
      }
      finally {
        in.close();
      }
    }
    catch (Exception e) {
      System.err.println("Exception while trying to copy: "+e);
      e.printStackTrace(); // stack trace of place where it happened
    }
  }
}
