public class Beer {
    public static void main(String[] args) {
        int bottles = 99;
        StringBuilder sb = new StringBuilder();
        String verse1 = " bottles of beer on the wall\n";
        String verse2 = " bottles of beer.\nTake one down, pass it around,\n";
        String verse3 = "Better go to the store and buy some more.";

        while (bottles > 0)
            sb.append(bottles).append(verse1).append(bottles).append(verse2).append(--bottles).append(verse1).append("\n");

        System.out.println(sb.append(verse3));
    }
}
