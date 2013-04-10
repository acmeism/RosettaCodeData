import java.awt.Color;
import java.awt.Graphics;
import java.awt.Image;
import java.awt.image.BufferedImage;

public class BasicBitmapStorage
{
 private BufferedImage image;

 public BasicBitmapStorage(final int width, final int height)
 {
  image = new BufferedImage(width, height, BufferedImage.TYPE_3BYTE_BGR);
 }

 public void fill(final Color c)
 {
  Graphics g = image.getGraphics();
  g.setColor(c);
  g.fillRect(0, 0, image.getWidth(), image.getHeight());
 }

 public void setPixel(final int x, final int y, final Color c)
 {
  image.setRGB(x, y, c.getRGB());
 }

 public Color getPixel(final int x, final int y)
 {
  return new Color(image.getRGB(x, y));
 }

 public Image getImage()
 {
  return image;
 }
}
