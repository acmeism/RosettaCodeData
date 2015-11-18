import javax.swing.*;
import java.awt.*;

/**
* SierpinskyTriangle.java
* Draws a SierpinskyTriangle in a JFrame
* The order of complexity is given from command line, but
* defaults to 3
*
* @author Istarnion
*/

class SierpinskyTriangle {

	public static void main(String[] args) {
		int i = 3;		// Default to 3
		if(args.length >= 1) {
			try {
				i = Integer.parseInt(args[0]);
			}
			catch(NumberFormatException e) {
				System.out.println("Usage: 'java SierpinskyTriangle [level]'\nNow setting level to "+i);
			}
		}
		final int level = i;

		JFrame frame = new JFrame("Sierpinsky Triangle - Java");
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

		JPanel panel = new JPanel() {
			@Override
			public void paintComponent(Graphics g) {
				g.setColor(Color.BLACK);
				drawSierpinskyTriangle(level, 20, 20, 360, (Graphics2D)g);
			}
		};

		panel.setPreferredSize(new Dimension(400, 400));

		frame.add(panel);
		frame.pack();
		frame.setResizable(false);
		frame.setLocationRelativeTo(null);
		frame.setVisible(true);
	}

	private static void drawSierpinskyTriangle(int level, int x, int y, int size, Graphics2D g) {
		if(level <= 0) return;

		g.drawLine(x, y, x+size, y);
		g.drawLine(x, y, x, y+size);
		g.drawLine(x+size, y, x, y+size);

		drawSierpinskyTriangle(level-1, x, y, size/2, g);
		drawSierpinskyTriangle(level-1, x+size/2, y, size/2, g);
		drawSierpinskyTriangle(level-1, x, y+size/2, size/2, g);
	}
}
