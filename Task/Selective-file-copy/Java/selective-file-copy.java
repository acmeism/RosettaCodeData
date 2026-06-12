import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.File;
import java.io.IOException;
import java.util.Scanner;

class CopysJ {

  public static void main(String[] args) {
    String ddname_IN  = "copys.in.txt";
    String ddname_OUT = "copys.out.txt";
    if (args.length >= 1) { ddname_IN  = args[0].length() > 0 ? args[0] : ddname_IN; }
    if (args.length >= 2) { ddname_OUT = args[1].length() > 0 ? args[1] : ddname_OUT; }

    File dd_IN = new File(ddname_IN);
    File dd_OUT = new File(ddname_OUT);

    try (
      Scanner scanner_IN = new Scanner(dd_IN);
      BufferedWriter writer_OUT = new BufferedWriter(new FileWriter(dd_OUT))
      ) {
      String a;
      String b;
      String c;
      String d;
      String c1;
      String x = "XXXXX";
      String data_IN;
      String data_OUT;
      int ib;

      while (scanner_IN.hasNextLine()) {
        data_IN = scanner_IN.nextLine();
        ib = 0;
        a = data_IN.substring(ib, ib += 5);
        b = data_IN.substring(ib, ib += 5);
        c = data_IN.substring(ib, ib += 4);
        c1=Integer.toHexString(new Byte((c.getBytes())[0]).intValue());
        if (c1.length()<2) { c1="0" + c1; }
        data_OUT = a + c1 + x;
        writer_OUT.write(data_OUT);
        writer_OUT.newLine();
        System.out.println(data_IN);
        System.out.println(data_OUT);
        System.out.println();
      }
    }
    catch (IOException ex) {
      ex.printStackTrace();
    }
    return;
  }
}
