import javax.xml.bind.DatatypeConverter;
import java.security.*;
import java.util.*;
import java.util.concurrent.*;
import java.util.concurrent.atomic.*;

public class ParallelBruteForce {
    public static void main(String[] args) {
        try {
            String[] hashes = {
                "1115dd800feaacefdf481f1f9070374a2a81e27880f187396db67958b207cbad",
                "3a7bd3e2360a3d29eea436fcfb7e44c735d117c42d1c1835420b6b9942dd4f1b",
                "74e1bb62f8dabb8125a58852b63bdf6eaef667cb56ac7f7cdba6d7305c50a22f"};
            ParallelBruteForce pbf = new ParallelBruteForce(5, hashes);
            pbf.findPasswords();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private ParallelBruteForce(int length, String[] hashes) {
        this.length = length;
        this.hashes = hashes;
        digests = new byte[hashes.length][];
        for (int i = 0; i < hashes.length; ++i)
            digests[i] = DatatypeConverter.parseHexBinary(hashes[i]);
    }

    private void findPasswords() throws Exception {
        count.set(length);
        int processors = Runtime.getRuntime().availableProcessors();
        ExecutorService svc = Executors.newFixedThreadPool(processors);
        List<Future<?>> tasks = new ArrayList<>();
        for (int i = 0; i < 26; ++i)
            tasks.add(svc.submit(new PasswordFinder((byte)(97 + i))));
        for (Future<?> task : tasks)
            task.get();
        svc.shutdown();
    }

    private static boolean nextPassword(byte[] passwd, int start) {
        int len = passwd.length;
        for (int i = len - 1; i >= start; --i) {
            if (passwd[i] < 122) {
                ++passwd[i];
                return true;
            }
            passwd[i] = 97;
        }
        return false;
    }

    private class PasswordFinder implements Runnable {
        private byte ch;
        private MessageDigest md = MessageDigest.getInstance("SHA-256");
        private PasswordFinder(byte c) throws NoSuchAlgorithmException {
            ch = c;
        }
        public void run() {
            byte[] passwd = new byte[length];
            Arrays.fill(passwd, (byte)97);
            passwd[0] = ch;
            while (count.get() > 0) {
                byte[] digest = md.digest(passwd);
                for (int m = 0; m < hashes.length; ++m) {
                    if (Arrays.equals(digest, digests[m])) {
                        count.decrementAndGet();
                        System.out.println("password: " + new String(passwd) + ", hash: " + hashes[m]);
                        break;
                    }
                }
                if (!nextPassword(passwd, 1))
                    break;
            }
        }
    }

    private int length;
    private String[] hashes;
    private byte[][] digests;
    private AtomicInteger count = new AtomicInteger();
}
