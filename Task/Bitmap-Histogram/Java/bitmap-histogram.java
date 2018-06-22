import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import javax.imageio.ImageIO;

public enum ImageProcessing {
    ;

    public static void main(String[] args) throws IOException {
        BufferedImage img = ImageIO.read(new File("example.png"));

        BufferedImage bwimg = toBlackAndWhite(img);

        ImageIO.write(bwimg, "png", new File("example-bw.png"));
    }

    private static int luminance(int rgb) {
        int r = (rgb >> 16) & 0xFF;
        int g = (rgb >> 8) & 0xFF;
        int b = rgb & 0xFF;
        return (r + b + g) / 3;
    }

    private static BufferedImage toBlackAndWhite(BufferedImage img) {
        int width = img.getWidth();
        int height = img.getHeight();

        int[] histo = computeHistogram(img);

        int median = getMedian(width * height, histo);

        BufferedImage bwimg = new BufferedImage(width, height, img.getType());
        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                bwimg.setRGB(x, y, luminance(img.getRGB(x, y)) >= median ? 0xFFFFFFFF : 0xFF000000);
            }
        }
        return bwimg;
    }

    private static int[] computeHistogram(BufferedImage img) {
        int width = img.getWidth();
        int height = img.getHeight();

        int[] histo = new int[256];
        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                histo[luminance(img.getRGB(x, y))]++;
            }
        }
        return histo;
    }

    private static int getMedian(int total, int[] histo) {
        int median = 0;
        int sum = 0;
        for (int i = 0; i < histo.length && sum + histo[i] < total / 2; i++) {
            sum += histo[i];
            median++;
        }
        return median;
    }
}
