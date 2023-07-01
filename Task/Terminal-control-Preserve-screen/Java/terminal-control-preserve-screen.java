public class PreserveScreen
{
    public static void main(String[] args) throws InterruptedException {
        System.out.print("\033[?1049h\033[H");
        System.out.println("Alternate screen buffer\n");
        for (int i = 5; i > 0; i--) {
            String s = (i > 1) ? "s" : "";
            System.out.printf("\rgoing back in %d second%s...", i, s);
            Thread.sleep(1000);
        }
        System.out.print("\033[?1049l");
    }
}
