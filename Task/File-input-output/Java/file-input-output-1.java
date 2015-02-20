import java.io.*;

public class FileIODemo {
  public static void main(String[] args) {
    try {
      FileInputStream in = new FileInputStream("input.txt");
      FileOutputStream out = new FileOutputStream("ouput.txt");
      int c;
      while ((c = in.read()) != -1) {
        out.write(c);
      }
    } catch (FileNotFoundException e) {
      e.printStackTrace();
    } catch (IOException e){
      e.printStackTrace();
    }
  }
}
