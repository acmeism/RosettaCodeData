import java.awt.Color;
import java.awt.Graphics;
import java.awt.Image;
import java.awt.image.BufferedImage;

public class BasicBitmapStorage {

    private final BufferedImage image;

    public BasicBitmapStorage(int width, int height) {
        image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
    }

    public void fill(Color c) {
        Graphics g = image.getGraphics();
        g.setColor(c);
        g.fillRect(0, 0, image.getWidth(), image.getHeight());
    }

    public void setPixel(int x, int y, Color c) {
        image.setRGB(x, y, c.getRGB());
    }

    public Color getPixel(int x, int y) {
        return new Color(image.getRGB(x, y));
    }

    public Image getImage() {
        return image;
    }
}
