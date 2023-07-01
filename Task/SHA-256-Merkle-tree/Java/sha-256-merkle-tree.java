import java.io.*;
import java.security.*;
import java.util.*;

public class SHA256MerkleTree {
    public static void main(String[] args) {
        if (args.length != 1) {
            System.err.println("missing file argument");
            System.exit(1);
        }
        try (InputStream in = new BufferedInputStream(new FileInputStream(args[0]))) {
            byte[] digest = sha256MerkleTree(in, 1024);
            if (digest != null)
                System.out.println(digestToString(digest));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static String digestToString(byte[] digest) {
        StringBuilder result = new StringBuilder();
        for (int i = 0; i < digest.length; ++i)
            result.append(String.format("%02x", digest[i]));
        return result.toString();
    }

    private static byte[] sha256MerkleTree(InputStream in, int blockSize) throws Exception {
        byte[] buffer = new byte[blockSize];
        int bytes;
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        List<byte[]> digests = new ArrayList<>();
        while ((bytes = in.read(buffer)) > 0) {
            md.reset();
            md.update(buffer, 0, bytes);
            digests.add(md.digest());
        }
        int length = digests.size();
        if (length == 0)
            return null;
        while (length > 1) {
            int j = 0;
            for (int i = 0; i < length; i += 2, ++j) {
                byte[] digest1 = digests.get(i);
                if (i + 1 < length) {
                    byte[] digest2 = digests.get(i + 1);
                    md.reset();
                    md.update(digest1);
                    md.update(digest2);
                    digests.set(j, md.digest());
                } else {
                    digests.set(j, digest1);
                }
            }
            length = j;
        }
        return digests.get(0);
    }
}
