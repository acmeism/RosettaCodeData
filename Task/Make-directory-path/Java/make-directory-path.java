import java.io.File;

public interface Test {

    public static void main(String[] args) {
        try {
            File f = new File("C:/parent/test");
            if (f.mkdirs())
                System.out.println("path successfully created");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
