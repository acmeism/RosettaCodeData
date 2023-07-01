import java.awt.*;
import java.awt.event.*;
import java.awt.geom.*;
import javax.swing.*;

public class WindowExample extends JApplet {
    public void paint(Graphics g) {
        Graphics2D g2 = (Graphics2D) g;

        g2.setStroke(new BasicStroke(2.0f));
        g2.drawString("Hello java", 20, 20);
        g2.setPaint(Color.blue);
        g2.draw(new Rectangle2D.Double(40, 40, 20, 20));
    }

    public static void main(String s[]) {
        JFrame f = new JFrame("ShapesDemo2D");
        f.addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {System.exit(0);}
        });
        JApplet applet = new ShapesDemo2D();
        f.getContentPane().add("Center", applet);
        f.pack();
        f.setSize(new Dimension(150, 150));
        f.setVisible(true);
    }
}
