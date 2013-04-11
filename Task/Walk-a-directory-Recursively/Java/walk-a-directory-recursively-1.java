import java.io.File;

public class MainEntry {
    public static void main(String[] args) {
        walkin(new File("/home/user")); //Replace this with a suitable directory
    }

    /**
     * Recursive function to descend into the directory tree and find all the files
     * that end with ".mp3"
     * @param dir A file object defining the top directory
     **/
    public static void walkin(File dir) {
        String pattern = ".mp3";

        File listFile[] = dir.listFiles();
        if (listFile != null) {
            for (int i=0; i<listFile.length; i++) {
                if (listFile[i].isDirectory()) {
                    walkin(listFile[i]);
                } else {
                    if (listFile[i].getName().endsWith(pattern)) {
                        System.out.println(listFile[i].getPath());
                    }
                }
            }
        }
    }
}
