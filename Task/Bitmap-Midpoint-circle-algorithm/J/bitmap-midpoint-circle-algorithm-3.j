import java.awt.Color;

public class MidPointCircle {
	private BasicBitmapStorage image;

	public MidPointCircle(final int imageWidth, final int imageHeight) {
		this.image = new BasicBitmapStorage(imageWidth, imageHeight);
	}

	private void drawCircle(final int centerX, final int centerY, final int radius) {
		int d = (5 - r * 4)/4;
		int x = 0;
		int y = radius;
		Color circleColor = Color.white;

		do {
			image.setPixel(centerX + x, centerY + y, circleColor);
			image.setPixel(centerX + x, centerY - y, circleColor);
			image.setPixel(centerX - x, centerY + y, circleColor);
			image.setPixel(centerX - x, centerY - y, circleColor);
			image.setPixel(centerX + y, centerY + x, circleColor);
			image.setPixel(centerX + y, centerY - x, circleColor);
			image.setPixel(centerX - y, centerY + x, circleColor);
			image.setPixel(centerX - y, centerY - x, circleColor);
			if (d < 0) {
				d += 2 * x + 1;
			} else {
				d += 2 * (x - y) + 1;
				y--;
			}
			x++;
		} while (x <= y);

	}
}
