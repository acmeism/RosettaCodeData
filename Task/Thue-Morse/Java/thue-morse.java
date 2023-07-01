public class ThueMorse {

    public static void main(String[] args) {
        sequence(6);
    }

    public static void sequence(int steps) {
        StringBuilder sb1 = new StringBuilder("0");
        StringBuilder sb2 = new StringBuilder("1");
        for (int i = 0; i < steps; i++) {
            String tmp = sb1.toString();
            sb1.append(sb2);
            sb2.append(tmp);
        }
        System.out.println(sb1);
    }
}
