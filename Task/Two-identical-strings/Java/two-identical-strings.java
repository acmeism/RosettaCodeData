public class TwoIdenticalStrings {
    public static void main(String[] args) {
        System.out.println("Decimal Binary");
        for (int i = 0; i < 1_000; i++) {
            String binStr = Integer.toBinaryString(i);
            if (binStr.length() % 2 == 0) {
                int len = binStr.length() / 2;
                if (binStr.substring(0, len).equals(binStr.substring(len))) {
                    System.out.printf("%7d %s%n", i, binStr);
                }
            }
        }
    }
}
