import java.io.*;
import java.util.*;

public class SumDif {
   StreamTokenizer in;
   PrintWriter out;

   public static void main(String[] args) throws IOException {
      new SumDif().run();
   }

   private int nextInt() throws IOException {
      in.nextToken();
      return (int)in.nval;
   }

   public void run() throws IOException {
      in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in))); // Standard input
      out = new PrintWriter(new OutputStreamWriter(System.out)); // Standard output
      solve();
      out.flush();
   }

   private void solve() throws IOException {
      out.println(nextInt() + nextInt());
   }
}
