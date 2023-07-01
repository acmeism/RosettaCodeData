import java.io.*;
import java.nio.*;
import java.nio.file.*;
import java.nio.file.attribute.*;
import java.security.*;
import java.util.*;

public class DuplicateFiles {
    public static void main(String[] args) {
        if (args.length != 2) {
            System.err.println("Directory name and minimum file size are required.");
            System.exit(1);
        }
        try {
            findDuplicateFiles(args[0], Long.parseLong(args[1]));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static void findDuplicateFiles(String directory, long minimumSize)
        throws IOException, NoSuchAlgorithmException {
        System.out.println("Directory: '" + directory + "', minimum size: " + minimumSize + " bytes.");
        Path path = FileSystems.getDefault().getPath(directory);
        FileVisitor visitor = new FileVisitor(path, minimumSize);
        Files.walkFileTree(path, visitor);
        System.out.println("The following sets of files have the same size and checksum:");
        for (Map.Entry<FileKey, Map<Object, List<String>>> e : visitor.fileMap_.entrySet()) {
            Map<Object, List<String>> map = e.getValue();
            if (!containsDuplicates(map))
                continue;
            List<List<String>> fileSets = new ArrayList<>(map.values());
            for (List<String> files : fileSets)
                Collections.sort(files);
            Collections.sort(fileSets, new StringListComparator());
            FileKey key = e.getKey();
            System.out.println();
            System.out.println("Size: " + key.size_ + " bytes");
            for (List<String> files : fileSets) {
                for (int i = 0, n = files.size(); i < n; ++i) {
                    if (i > 0)
                        System.out.print(" = ");
                    System.out.print(files.get(i));
                }
                System.out.println();
            }
        }
    }

    private static class StringListComparator implements Comparator<List<String>> {
        public int compare(List<String> a, List<String> b) {
            int len1 = a.size(), len2 = b.size();
            for (int i = 0; i < len1 && i < len2; ++i) {
                int c = a.get(i).compareTo(b.get(i));
                if (c != 0)
                    return c;
            }
            return Integer.compare(len1, len2);
        }
    }

    private static boolean containsDuplicates(Map<Object, List<String>> map) {
        if (map.size() > 1)
            return true;
        for (List<String> files : map.values()) {
            if (files.size() > 1)
                return true;
        }
        return false;
    }

    private static class FileVisitor extends SimpleFileVisitor<Path> {
        private MessageDigest digest_;
        private Path directory_;
        private long minimumSize_;
        private Map<FileKey, Map<Object, List<String>>> fileMap_ = new TreeMap<>();

        private FileVisitor(Path directory, long minimumSize) throws NoSuchAlgorithmException {
            directory_ = directory;
            minimumSize_ = minimumSize;
            digest_ = MessageDigest.getInstance("MD5");
        }

        public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) throws IOException {
            if (attrs.size() >= minimumSize_) {
                FileKey key = new FileKey(file, attrs, getMD5Sum(file));
                Map<Object, List<String>> map = fileMap_.get(key);
                if (map == null)
                    fileMap_.put(key, map = new HashMap<>());
                List<String> files = map.get(attrs.fileKey());
                if (files == null)
                    map.put(attrs.fileKey(), files = new ArrayList<>());
                Path relative = directory_.relativize(file);
                files.add(relative.toString());
            }
            return FileVisitResult.CONTINUE;
        }

        private byte[] getMD5Sum(Path file) throws IOException {
            digest_.reset();
            try (InputStream in = new FileInputStream(file.toString())) {
                byte[] buffer = new byte[8192];
                int bytes;
                while ((bytes = in.read(buffer)) != -1) {
                    digest_.update(buffer, 0, bytes);
                }
            }
            return digest_.digest();
        }
    }

    private static class FileKey implements Comparable<FileKey> {
        private byte[] hash_;
        private long size_;

        private FileKey(Path file, BasicFileAttributes attrs, byte[] hash) throws IOException {
            size_ = attrs.size();
            hash_ = hash;
        }

        public int compareTo(FileKey other) {
            int c = Long.compare(other.size_, size_);
            if (c == 0)
                c = hashCompare(hash_, other.hash_);
            return c;
        }
    }

    private static int hashCompare(byte[] a, byte[] b) {
        int len1 = a.length, len2 = b.length;
        for (int i = 0; i < len1 && i < len2; ++i) {
            int c = Byte.compare(a[i], b[i]);
            if (c != 0)
                return c;
        }
        return Integer.compare(len1, len2);
    }
}
