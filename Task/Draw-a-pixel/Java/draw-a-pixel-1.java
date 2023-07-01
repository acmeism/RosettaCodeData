import java.awt.Color;
import java.awt.Graphics;
import javax.swing.JFrame;

public class DrawAPixel extends JFrame{
	public DrawAPixel() {
		super("Red Pixel");
		setSize(320, 240);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setVisible(true);
	}
	@Override
	public void paint(Graphics g) {
		g.setColor(new Color(255, 0, 0));
		g.drawRect(100, 100, 1, 1);
	}
	public static void main(String[] args) {
		new DrawAPixel();
	}
}
