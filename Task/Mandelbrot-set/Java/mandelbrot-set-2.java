import static java.awt.Color.HSBtoRGB;
import static java.awt.Color.black;
import static java.awt.event.KeyEvent.VK_BACK_SLASH;
import static java.awt.event.KeyEvent.VK_ESCAPE;
import static java.awt.image.BufferedImage.TYPE_INT_RGB;
import static java.lang.Integer.signum;
import static java.lang.Math.abs;
import static java.lang.Math.max;
import static java.lang.Math.min;
import static java.lang.System.currentTimeMillis;
import static java.util.Locale.ROOT;

import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Insets;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.image.BufferedImage;
import java.util.function.Consumer;
import java.util.function.Predicate;

import javax.swing.JFrame;

/*
 *      click: point to center
 * ctrl-click: point to origin
 *       drag: point to mouse release point
 *  ctrl-drag: point to origin + zoom
 * back-slash: back to previous point
 *        esc: back to previous zoom point - zoom
 */

public class Mandelbrot extends JFrame {
	private static final long serialVersionUID = 1L;
	
	private Insets insets;
	private int width, height;
	private double widthHeightRatio;
	private int minX, minY;
	private double Zoom;
		
	private int mpX, mpY, mdX, mdY;
	private boolean isCtrlDown, ctrl;
	private Stack stack = new Stack();
	
	private BufferedImage image;
	private boolean newImage = true;
	
	public static void main(String[] args) {
		new Mandelbrot(800, 600); // (800, 600), (1024, 768), (1600, 900), (1920, 1080)
		//new Mandelbrot(800, 600, 4.5876514379235943e-09, -0.6092161175392330, -0.4525577210859453);
		//new Mandelbrot(800, 600, 5.9512354925205320e-10, -0.6092146769531246, -0.4525564820098262);
		//new Mandelbrot(800, 600, 6.7178527589983420e-08, -0.7819036465400592, -0.1298363433443265);
		//new Mandelbrot(800, 600, 4.9716091454775210e-09, -0.7818800036717134, -0.1298044093748981);
		//new Mandelbrot(800, 600, 7.9333341281639390e-06, -0.7238770725243187, -0.2321214232559487);
		/*
		new Mandelbrot(800, 600, new double[][] {
			{5.0000000000000000e-03, -2.6100000000000000, -1.4350000000000000}, // done!
			{3.5894206549118390e-04, -0.7397795969773300, -0.4996473551637279}, // done!
			{3.3905106941862460e-05, -0.6270410477828043, -0.4587021918164572}, // done!
			{6.0636337351945460e-06, -0.6101531446039512, -0.4522561221394852}, // done!
			{1.5502741161769430e-06, -0.6077214060084073, -0.4503995886987711}, // done!
		});
		//*/
	}
	
	public Mandelbrot(int width, int height) {
		this(width, height, .005, -2.61, -1.435);
	}
	
	public Mandelbrot(int width, int height, double Zoom, double r, double i) {
		this(width, height, new double[] {Zoom, r, i});
	}
	
	public Mandelbrot(int width, int height, double[] ... points) {
		super("Mandelbrot Set");
		setResizable(false);
		setDefaultCloseOperation(EXIT_ON_CLOSE);
		Dimension screen = getToolkit().getScreenSize();
		setBounds(
			rint((screen.getWidth() - width) / 2),
			rint((screen.getHeight() - height) / 2),
			width,
			height
		);
		addMouseListener(mouseAdapter);
		addMouseMotionListener(mouseAdapter);
		addKeyListener(keyAdapter);
		Point point = stack.push(points);
		this.Zoom = point.Zoom;
		this.minX = point.minX;
		this.minY = point.minY;
		setVisible(true);
		insets = getInsets();
		this.width = width -= insets.left + insets.right;
		this.height = height -= insets.top + insets.bottom;
		widthHeightRatio = (double) width / height;
	}
	
	private int rint(double d) {
		return (int) Math.rint(d); // half even
	}

	private void repaint(boolean newImage) {
		this.newImage = newImage;
		repaint();
	}

	private MouseAdapter mouseAdapter = new MouseAdapter() {
		public void mouseClicked(MouseEvent e) {
			stack.push(false);
			if (!ctrl) {
				minX -= width / 2 ;
				minY -= height / 2;
			}
			minX += e.getX() - insets.left;
			minY += e.getY() - insets.top;
			ctrl = false;
			repaint(true);
	 	}
		public void mousePressed(MouseEvent e) {
			mpX = e.getX();
			mpY = e.getY();
			ctrl = isCtrlDown;
		}
		public void mouseDragged(MouseEvent e) {
			if (!ctrl) return;
			setMdCoord(e);
			repaint();
		}
		private void setMdCoord(MouseEvent e) {
			int dx = e.getX() - mpX;
			int dy = e.getY() - mpY;
			mdX = mpX + max(abs(dx), rint(abs(dy) * widthHeightRatio) * signum(dx));
			mdY = mpY + max(abs(dy), rint(abs(dx) / widthHeightRatio) * signum(dy));
			acceptIf(insets.left, ge(mdX), setMdXY);
			acceptIf(insets.top,  ge(mdY), setMdYX);
			acceptIf(insets.left+width-1, le(mdX), setMdXY);
			acceptIf(insets.top+height-1, le(mdY), setMdYX);
		}
		private void acceptIf(int value, Predicate<Integer> p, Consumer<Integer> c) { if (p.test(value)) c.accept(value); }
		private Predicate<Integer> ge(int md) { return v-> v >= md; }
		private Predicate<Integer> le(int md) { return v-> v <= md; }
		private Consumer<Integer> setMdXY = v-> mdY = mpY + rint(abs((mdX=v)-mpX) / widthHeightRatio) * signum(mdY-mpY);
		private Consumer<Integer> setMdYX = v-> mdX = mpX + rint(abs((mdY=v)-mpY) * widthHeightRatio) * signum(mdX-mpX);
		public void mouseReleased(MouseEvent e) {
			if (e.getX() == mpX && e.getY() == mpY) return;
			stack.push(ctrl);
			if (!ctrl) {
				minX += mpX - (mdX = e.getX());
				minY += mpY - (mdY = e.getY());
			}
			else {
				setMdCoord(e);
				if (mdX < mpX) { int t=mpX; mpX=mdX; mdX=t; }
				if (mdY < mpY) { int t=mpY; mpY=mdY; mdY=t; }
				minX += mpX - insets.left;
				minY += mpY - insets.top;
				double rZoom = (double) width / abs(mdX - mpX);
				minX *= rZoom;
				minY *= rZoom;
				Zoom /= rZoom;
			}
			ctrl = false;
			repaint(true);		
		}
	};
	
	private KeyAdapter keyAdapter = new KeyAdapter() {
		public void keyPressed(KeyEvent e) {
			isCtrlDown = e.isControlDown();
		}
		public void keyReleased(KeyEvent e) {
			isCtrlDown = e.isControlDown();
		}
		public void keyTyped(KeyEvent e) {
			char c = e.getKeyChar();
			boolean isEsc = c == VK_ESCAPE;
			if (!isEsc && c != VK_BACK_SLASH) return;
			repaint(stack.pop(isEsc));
		}
	};
	
	private class Point {
		public boolean type;
		public double Zoom;
		public int minX;
		public int minY;
		Point(boolean type, double Zoom, int minX, int minY) {
			this.type = type;
			this.Zoom = Zoom;
			this.minX = minX;
			this.minY = minY;
		}
	}
	private class Stack extends java.util.Stack<Point> {
		private static final long serialVersionUID = 1L;
		public Point push(boolean type) {
			return push(type, Zoom, minX, minY);
		}
		public Point push(boolean type, double ... point) {
			double Zoom = point[0];
			return push(type, Zoom, rint(point[1]/Zoom), rint(point[2]/Zoom));
		}
		public Point push(boolean type, double Zoom, int minX, int minY) {
			return push(new Point(type, Zoom, minX, minY));
		}
		public Point push(double[] ... points) {
			Point lastPoint = push(false, points[0]);
			for (int i=0, e=points.length-1; i<e; i+=1) {
				double[] point = points[i];
				lastPoint = push(point[0] != points[i+1][0], point);
				done(printPoint(lastPoint));
			}
			return lastPoint;
		}
		public boolean pop(boolean type) {
			for (;;) {
				if (empty()) return false;
				Point d = super.pop();
				Zoom = d.Zoom;
				minX = d.minX;
				minY = d.minY;
				if (!type || d.type) return true;
			}
		}
	}
	
	@Override
	public void paint(Graphics g) {
		if (newImage) newImage();
		g.drawImage(image, insets.left, insets.top, this);
		//g.drawLine(insets.left+width/2, insets.top+0,        insets.left+width/2, insets.top+height);
		//g.drawLine(insets.left+0,       insets.top+height/2, insets.left+width,   insets.top+height/2);
		if (!ctrl) return;
		g.drawRect(min(mpX, mdX), min(mpY, mdY), abs(mpX - mdX), abs(mpY - mdY));
	}

	private void newImage() {
		long milli = printPoint();
		image = new BufferedImage(width, height, TYPE_INT_RGB);
		int maxX = minX + width;
		int maxY = minY + height;
		for (int x = minX; x < maxX; x+=1) {
			double r = x * Zoom;
			for (int y = minY; y < maxY; y+=1) {
				double i = y * Zoom;
				//System.out.printf("%+f%+fi\n", r, i);
				//             0f    1/6f  1/3f 1/2f 2/3f    5/6f
				//straight -> red  yellow green cian blue magenta <- reverse
				image.setRGB(x-minX, y-minY, color(r, i, 360, false, 2/3f));
			}
		}
		newImage = false;
		done(milli);
	}

	private long printPoint() {
		return printPoint(Zoom, minX, minY);
	}
	private long printPoint(Point point) {
		return printPoint(point.Zoom, point.minX, point.minY);
	}
	private long printPoint(double Zoom, int minX, int minY) {
		return printPoint(Zoom, minX*Zoom, minY*Zoom);
	}
	private long printPoint(Object ... point) {
		System.out.printf(ROOT,	"{%.16e, %.16g, %.16g},", point);
		return currentTimeMillis();
	}
	
	private void done(long milli) {
		milli = currentTimeMillis() - milli;
		System.out.println(" // " + milli + "ms done!");
	}

	private int color(double r0, double i0, int max, boolean straight, float shift) {
		int n = -1;
		double r=0, i=0, r2=0, i2=0;
		do {
			i = r*(i+i) + i0;
			r = r2-i2 + r0;
			r2 = r*r;
			i2 = i*i;
		}
		while (++n < max && r2 + i2 < 4);
		return n == max
			? black.getRGB()
			: HSBtoRGB(shift + (float) (straight ? n : max-n) / max * 11/12f + (straight ? 0f : 1/12f), 1, 1)
		;		
	}
}
