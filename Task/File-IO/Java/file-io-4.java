import java.io.*;
public class Test {
  public static void main (String[] args) throws IOException {
    BufferedReader br = new BufferedReader(new FileReader("input.txt"));
    BufferedWriter bw = new BufferedWriter(new FileWriter("output.txt"));
    String line;
    while (line = br.readLine() != null) {
      bw.write(line);
      bw.newLine();
    }
    br.close();
    bw.close();
  }
}
