import java.awt.Color;
import junit.framework.TestCase;

public class BasicBitmapStorageTest extends TestCase
{
 public static final int WIDTH = 640, HEIGHT = 480;

 BasicBitmapStorage bbs = new BasicBitmapStorage(WIDTH, HEIGHT);

 public void testHappy()
 {
  bbs.fill(Color.cyan);
  bbs.setPixel(WIDTH / 2, HEIGHT / 2, Color.BLACK);
  Color c1 = bbs.getPixel(WIDTH / 2, HEIGHT / 2);
  Color c2 = bbs.getPixel(20, 20);
  assertEquals(Color.BLACK, c1);
  assertEquals(Color.CYAN, c2);
 }
}
