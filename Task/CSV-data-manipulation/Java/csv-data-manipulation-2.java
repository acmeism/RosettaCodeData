import java.io.*;
import java.util.*;

import org.apache.commons.csv.*;

public class RCsv {
  private static final String NL = System.getProperty("line.separator");
  private static final String FILENAME_IR = "data/csvtest_in.csv";
  private static final String FILENAME_OR = "data/csvtest_sum.csv";
  private static final String COL_NAME_SUM = "SUM, \"integers\""; // demonstrate white space, comma & quote handling

  public static void main(String[] args) {
    Reader iCvs = null;
    Writer oCvs = null;
    System.out.println(textFileContentsToString(FILENAME_IR));
    try {
      iCvs = new BufferedReader(new FileReader(FILENAME_IR));
      oCvs = new BufferedWriter(new FileWriter(FILENAME_OR));
      processCsv(iCvs, oCvs);
    }
    catch (IOException ex) {
      ex.printStackTrace();
    }
    finally {
      try {
        if (iCvs != null) { iCvs.close(); }
        if (oCvs != null) { oCvs.close(); }
      }
      catch (IOException ex) {
        ex.printStackTrace();
      }
    }
    System.out.println(textFileContentsToString(FILENAME_OR));
    return;
  }

  public static void processCsv(Reader iCvs, Writer oCvs) throws IOException {
    CSVPrinter printer = null;
    try {
      printer = new CSVPrinter(oCvs, CSVFormat.DEFAULT.withRecordSeparator(NL));
      List<String> oCvsHeaders;
      List<String> oCvsRecord;
      CSVParser records = CSVFormat.DEFAULT.withHeader().parse(iCvs);
      Map<String, Integer> irHeader = records.getHeaderMap();
      oCvsHeaders = new ArrayList<String>(Arrays.asList((irHeader.keySet()).toArray(new String[0])));
      oCvsHeaders.add(COL_NAME_SUM);
      printer.printRecord(oCvsHeaders);
      for (CSVRecord record : records) {
        oCvsRecord = record2list(record, oCvsHeaders);
        printer.printRecord(oCvsRecord);
      }
    }
    finally {
      if (printer != null) {
        printer.close();
      }
    }
    return;
  }

  private static List<String> record2list(CSVRecord record, List<String> oCvsHeaders) {
    List<String> cvsRecord;
    Map<String, String> rMap = record.toMap();
    long recNo = record.getRecordNumber();
    rMap = alterRecord(rMap, recNo);
    int sum = 0;
    sum = summation(rMap);
    rMap.put(COL_NAME_SUM, String.valueOf(sum));
    cvsRecord = new ArrayList<String>();
    for (String key : oCvsHeaders) {
      cvsRecord.add(rMap.get(key));
    }
    return cvsRecord;
  }

  private static Map<String, String> alterRecord(Map<String, String> rMap, long recNo) {
    int rv;
    Random rg = new Random(recNo);
    rv = rg.nextInt(50);
    String[] ks = rMap.keySet().toArray(new String[0]);
    int ix = rg.nextInt(ks.length);
    long yv = 0;
    String ky = ks[ix];
    String xv = rMap.get(ky);
    if (xv != null && xv.length() > 0) {
      yv = Long.valueOf(xv) + rv;
      rMap.put(ks[ix], String.valueOf(yv));
    }
    return rMap;
  }

  private static int summation(Map<String, String> rMap) {
    int sum = 0;
    for (String col : rMap.keySet()) {
      String nv = rMap.get(col);
      sum += nv != null && nv.length() > 0 ? Integer.valueOf(nv) : 0;
    }
    return sum;
  }

  private static String textFileContentsToString(String filename) {
    StringBuilder lineOut = new StringBuilder();
    Scanner fs = null;
    try {
      fs = new Scanner(new File(filename));
      lineOut.append(filename);
      lineOut.append(NL);
      while (fs.hasNextLine()) {
        String line = fs.nextLine();
        lineOut.append(line);
        lineOut.append(NL);
      }
    }
    catch (FileNotFoundException ex) {
      // TODO Auto-generated catch block
      ex.printStackTrace();
    }
    finally {
      if (fs != null) {
        fs.close();
      }
    }
    return lineOut.toString();
  }
}
