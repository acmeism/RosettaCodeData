public class Main {
    static Object mutex = new Object();
    static int i = 0;

    public void addAndPrint()
    {
        System.out.print("" + i + " + 1 = ");
        i++;
        System.out.println("" + i);
    }

    public void subAndPrint()
    {
        System.out.print("" + i + " - 1 = ");
        i--;
        System.out.println("" + i);
    }


    public static void main(String[] args){
        final Main m = new Main();
        new Thread() {
            public void run()
            {
                while (true) { synchronized(m.mutex) { m.addAndPrint(); } }
            }
        }.start();
        new Thread() {
            public void run()
            {
                while (true) { synchronized(m.mutex) { m.subAndPrint(); } }
            }
        }.start();
    }
}
