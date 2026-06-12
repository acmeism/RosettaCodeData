import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.math.BigInteger;
import java.security.SecureRandom;
import java.util.Random;
import java.util.Scanner;
/*
* Numbers to try:
* p = 11 or BigInteger.probablePrime(BIT1_LENGTH, rand)
* q = 23 or BigInteger.probablePrime(BIT_LENGTH, rand)
* seed = 3 or BigInteger.probablePrime(BIT_LENGTH,rand)
* */

public class csprngBBS {
    public static Scanner input = new Scanner(System.in);
    private static final String fileformat = "png";
    private static String bitsStri = "";
    private static String parityEven = "";
    private static String leastSig = "";
    private static String randomJavaUtil = "";
    private static int width = 0;
    private static int BIT_LENGTH = 0;
    private static final Random rand = new SecureRandom();
    private static BigInteger p = null; // 11
    private static BigInteger q = null; // 23
    private static BigInteger m = null;
    private static BigInteger seed = null; // 3
    private static BigInteger seedFinal = null;
    private static final Random randMathUtil = new SecureRandom();
    public static void main(String[] args) throws IOException {
        System.out.print("Width: ");
        width = input.nextInt();
        System.out.print("Bit-Length: ");
        BIT_LENGTH = input.nextInt();
        System.out.print("Generator format: ");
        String useGenerator = input.next();
        p = BigInteger.probablePrime(BIT_LENGTH, rand);
        q = BigInteger.probablePrime(BIT_LENGTH, rand);
        m = p.multiply(q);
        seed = BigInteger.probablePrime(BIT_LENGTH,rand);
        seedFinal = seed.add(BigInteger.ZERO);
        if(useGenerator.contains("parity") && useGenerator.contains("significant")) {
            findLeastSignificant();
            findBitParityEven();
            createImage(parityEven, "parityEven");
            createImage(leastSig, "significant");
        }

        if(useGenerator.contains("parity") && !useGenerator.contains("significant")){
            findBitParityEven();
        }

        if(useGenerator.contains("significant") && !useGenerator.contains("parity")){
            findLeastSignificant();
            createImage(leastSig, "significant");
        }

        if(useGenerator.contains("util")){
            findRandomJava(randMathUtil);
            createImage(randomJavaUtil, "randomUtilJava");
        }
    }
    public static void findRandomJava(Random random){
        for(int x = 1; x <= Math.pow(width, 2); x++){
            randomJavaUtil += random.nextInt(2);
        }
    }

    public static void findBitParityEven(){
        for(int x = 1; x <= Math.pow(width, 2); x++) {
            seed = seed.pow(2).mod(m);
            bitsStri = convertBinary(seed);
            char[] bits = bitsStri.toCharArray();
            int counter = 0;
            for (char bit : bits) {
                if (bit == '1') {
                    counter++;
                }
            }
            if (counter % 2 != 0) {
                parityEven += "1";
            } else {
                parityEven += "0";
            }
        }
    }

    public static void findLeastSignificant(){
        seed = seedFinal;
        for(int x = 1; x <= Math.pow(width, 2); x++){
            seed = seed.pow(2).mod(m);
            leastSig += bitsStri.substring(bitsStri.length() - 1);
        }
    }

    public static String convertBinary(BigInteger value){
        StringBuilder total = new StringBuilder();
        BigInteger two = BigInteger.TWO;
        while(value.compareTo(BigInteger.ZERO) > 0){
            total.append(value.mod(two));
            value = value.divide(two);
        }
        return total.reverse().toString();
    }

    public static void createImage(String useThis, String fileName) throws IOException {
        int length = csprngBBS.width;
        // Constructs a BufferedImage of one of the predefined image types.
        BufferedImage bufferedImage = new BufferedImage(length, length, 1/*BufferedImage.TYPE_INT_RGB*/);
        // Create a graphics which can be used to draw into the buffered image
        Graphics2D g2d = bufferedImage.createGraphics();
        for (int y = 1; y <= length; y++) {
            for (int x = 1; x <= length; x++) {
                if (useThis.startsWith("1")) {
                    useThis = useThis.substring(1);
                    g2d.setColor(Color.BLACK);
                    g2d.fillRect(x, y, 1, 1);
                } else if (useThis.startsWith("0")) {
                    useThis = useThis.substring(1);
                    g2d.setColor(Color.WHITE);
                    g2d.fillRect(x, y, 1, 1);
                }
            }
            System.out.print(y + "\t");
        }
        // Disposes of this graphics context and releases any system resources that it is using.
        g2d.dispose();
        // Save as file
        File file = new File("REPLACEFILEPATHHERE" + fileName + "." + fileformat);
        ImageIO.write(bufferedImage, fileformat, file);
    }
}
