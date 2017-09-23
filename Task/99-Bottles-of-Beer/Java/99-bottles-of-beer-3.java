public class Beer {
    public static void main(String args[]) {
        song(99);
    }

    public static void song(int bottles) {
        if (bottles >= 0) {
            if (bottles > 1)
                System.out.println(bottles + " bottles of beer on the wall\n" + bottles + " bottles of beer\nTake one down, pass it around\n" + (bottles - 1) + " bottles of beer on the wall.\n");
            else if (bottles == 1)
                System.out.println(bottles + " bottle of beer on the wall\n" + bottles + " bottle of beer\nTake one down, pass it around\n" + (bottles - 1) + " bottles of beer on the wall.\n");
            else
                System.out.println(bottles + " bottles of beer on the wall\n" + bottles + " bottles of beer\nBetter go to the store and buy some more!");
            song(bottles - 1);
        }
    }
}
