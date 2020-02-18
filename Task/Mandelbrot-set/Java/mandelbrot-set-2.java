import static java.awt.Color.HSBtoRGB;
import static java.awt.Color.black;
import static java.awt.event.KeyEvent.VK_BACK_SLASH;
import static java.awt.event.KeyEvent.VK_ESCAPE;
import static java.awt.image.BufferedImage.TYPE_INT_RGB;
import static java.lang.Math.abs;
import static java.lang.Math.max;
import static java.lang.Math.min;
import static java.lang.Math.signum;
import static java.util.stream.Stream.of;

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
    private boolean paint = true;

    public static void main(String[] args) {
        new Mandelbrot(800, 600); // (800, 600), (1024, 768), (1600, 900)
    }

    public Mandelbrot(int width, int height) {
        super("Mandelbrot Set");
        setResizable(false);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        Dimension screen = getToolkit().getScreenSize();
        setBounds(
            ((int) screen.getWidth() - width) / 2,
            ((int) screen.getHeight() - height) / 2,
            width,
            height
        );
        addMouseListener(mouseAdapter);
        addMouseMotionListener(mouseAdapter);
        addKeyListener(
            new KeyAdapter() {
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
                    if (stack.pop(isEsc)) {
                        paint = true;
                        printPoint();
                    }
                    repaint();
                }
            }
        );
        setVisible(true);
        insets = getInsets();
        this.width = width -= insets.left + insets.right;
        this.height = height -= insets.top + insets.bottom;
        widthHeightRatio = (double) width / height;
        minX = -width / 2 - 125;
        minY = -height / 2;
        Zoom = .005;
        paint = true;
        printPoint();
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
            paint = true;
            printPoint();
            repaint();
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
            mdX = (int) (mpX + max(abs(dx), abs(dy)*widthHeightRatio) * signum(dx));
            mdY = (int) (mpY + max(abs(dy), abs(dx)/widthHeightRatio) * signum(dy));
            acceptIf(insets.left, ge(mdX), setMdXY);
            acceptIf(insets.top,  ge(mdY), setMdYX);
            acceptIf(insets.left+width-1, le(mdX), setMdXY);
            acceptIf(insets.top+height-1, le(mdY), setMdYX);
        }
        private void acceptIf(int value, Predicate<Integer> p, Consumer<Integer> c) { if (p.test(value)) c.accept(value); }
        private Predicate<Integer> ge(int md) { return v-> v >= md; }
        private Predicate<Integer> le(int md) { return v-> v <= md; }
        private Consumer<Integer> setMdXY = v-> mdY = (int) (mpY + abs((mdX=v)-mpX)/widthHeightRatio * signum(mdY-mpY));
        private Consumer<Integer> setMdYX = v-> mdX = (int) (mpX + abs((mdY=v)-mpY)*widthHeightRatio * signum(mdX-mpX));
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
            paint = true;
            printPoint();
            repaint();
        }
    };

    private void printPoint() {
        System.out.printf(
            "%.19e (%.19g%+.19gi) .. (%.19g%+.19gi) ", of(1, minX, minY, minX+width, minY+height).map(i->Zoom * i).toArray()
        );
    }

    private class Stack extends java.util.Stack<Object[]> {
        private static final long serialVersionUID = 1L;
        public void push(boolean type) {
            push(new Object[] {type, minX, minY, Zoom});
        }
        public boolean pop(boolean type) {
            for (;;) {
                if (empty()) return false;
                Object[] d = super.pop();
                minX = (Integer) d[1];
                minY = (Integer) d[2];
                Zoom = (Double)  d[3];
                if (!type || (Boolean) d[0]) return true;
            }
        }
    }

    @Override
    public void paint(Graphics g) {
        if (paint) {
            image = newImage();
            paint = false;
            System.out.println("done!");
        }
        g.drawImage(image, insets.left, insets.top, this);
        //g.drawLine(insets.left+width/2, insets.top+0,        insets.left+width/2, insets.top+height);
        //g.drawLine(insets.left+0,       insets.top+height/2, insets.left+width,   insets.top+height/2);
        if (!ctrl) return;
        g.drawRect(min(mpX, mdX), min(mpY, mdY), abs(mpX - mdX), abs(mpY - mdY));
    }

    private BufferedImage newImage() {
        BufferedImage image = new BufferedImage(width, height, TYPE_INT_RGB);
        int maxX = minX + width;
        int maxY = minY + height;
        for (int x = minX; x < maxX; x+=1) {
            double r = Zoom * x;
            for (int y = minY; y < maxY; y+=1) {
                double i = Zoom * y;
                //System.out.printf("%+f%+fi\n", r, i);
                //             0f    1/6f  1/3f 1/2f 2/3f    5/6f
                //straight -> red  yellow green cian blue magenta <- reverse
                image.setRGB(x-minX, y-minY, color(r, i, 360, false, 2/3f));
            }
        }
        return image;
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
            : HSBtoRGB(shift + (float) (straight ? n : max-n) / max /* * 11/12f + (straight ? 0f : 1/12f) */, 1, 1)
        ;
    }
}
