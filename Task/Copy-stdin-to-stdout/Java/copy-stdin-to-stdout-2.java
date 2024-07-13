public class CopyStdinToStdout {
    public static void main(String[] args) throws java.io.IOException {
        System.in.transferTo(System.out);
    }
}
