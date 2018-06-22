import static org.junit.Assert.assertEquals;

import java.awt.Color;
import org.junit.Test;

public class BasicBitmapStorageTest {

    @Test
    public void testHappy() {
        int width = 640;
        int height = 480;

        BasicBitmapStorage bbs = new BasicBitmapStorage(width, height);
        bbs.fill(Color.CYAN);
        bbs.setPixel(width / 2, height / 2, Color.BLACK);
        Color c1 = bbs.getPixel(width / 2, height / 2);
        Color c2 = bbs.getPixel(20, 20);

        assertEquals(Color.BLACK, c1);
        assertEquals(Color.CYAN, c2);
    }
}
