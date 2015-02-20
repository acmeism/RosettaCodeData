import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

public class RecordAppender {

    public static class Record {

        String account, password;
        Integer uid, gid;
        String[] gecos;
        String directory, shell;

        public Record(String account, String password, int uid, int gid,
                String gecos[], String directory, String shell) {
            this.account = account;
            this.password = password;
            this.uid = uid;
            this.gid = gid;
            this.gecos = gecos;
            this.directory = directory;
            this.shell = shell;
        }

        public Record(String line) {
            String[] token = line.trim().split(":");
            if ((token == null) || (token.length < 7)) {
                throw new IllegalArgumentException(line);
            }
            this.account = token[0].trim();
            this.password = token[1].trim();
            this.uid = Integer.parseInt(token[2].trim());
            this.gid = Integer.parseInt(token[3].trim());
            this.gecos = token[4].trim().split(",");
            this.directory = token[5].trim();
            this.shell = token[6].trim();
        }

        public String asLine() {
            StringBuilder sb = new StringBuilder();
            sb.append(account + ":" + password + ":");
            sb.append(uid + ":" + gid + ":");
            for (int i = 0; i < gecos.length; i++) {
                sb.append((i == 0 ? "" : ",") + gecos[i].trim());
            }
            sb.append(":" + directory + ":" + shell + "\n");
            return sb.toString();
        }
    }

    public static void main(String[] args) {
        File file = null;
        FileWriter writer = null;
        BufferedReader br = null;
        String line = null;
        Record record = null;
        try {
            file = File.createTempFile("_rosetta", ".passwd");

            writer = new FileWriter(file);

            writer.write(new Record("jsmith", "x", 1001, 1000, new String[] {
                    "Joe Smith", "Room 1007", "(234)555-8917", "(234)555-0077",
                    "jsmith@rosettacode.org" }, "/home/jsmith", "/bin/bash")
                    .asLine());

            writer.write(new Record("jdoe", "x", 1002, 1000, new String[] {
                    "Jane Doe", "Room 1004", "(234)555-8914", "(234)555-0044",
                    "jdoe@rosettacode.org" }, "/home/jdoe", "/bin/bash")
                    .asLine());

            writer.close();

            // Setting the 'append'-Parameter to true writes data
            // to the end of the file rather than the beginning

            writer = new FileWriter(file, true);

            writer.write(new Record("xyz", "x", 1003, 1000, new String[] {
                    "X Yz", "Room 1003", "(234)555-8913", "(234)555-0033",
                    "xyz@rosettacode.org" }, "/home/xyz", "/bin/bash")
                    .asLine());

            writer.close();

            br = new BufferedReader(new FileReader(file));
            while ((line = br.readLine()) != null) {
                record = new Record(line);
                if (record.account.equals("xyz")) {
                    System.out.println("Appended Record: " + record.asLine());
                }
            }

            br.close();

        } catch (IOException e) {
            System.err.println("Running Example failed: " + e.getMessage());
        } finally {
            try {
                if (br != null) {
                    br.close();
                }
            } catch (IOException ignored) {
            }
            try {
                if (writer != null) {
                    writer.close();
                }
            } catch (IOException ignored) {
            }
            if (file != null) {
                file.delete();
            }
        }
    }

}
