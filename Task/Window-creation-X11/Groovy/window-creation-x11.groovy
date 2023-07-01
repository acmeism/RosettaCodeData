import javax.swing.*
import java.awt.*
import java.awt.event.WindowAdapter
import java.awt.event.WindowEvent
import java.awt.geom.Rectangle2D

class WindowCreation extends JApplet implements Runnable {
    void paint(Graphics g) {
        (g as Graphics2D).with {
            setStroke(new BasicStroke(2.0f))
            drawString("Hello Groovy!", 20, 20)
            setPaint(Color.blue)
            draw(new Rectangle2D.Double(10d, 50d, 30d, 30d))
        }
    }

    void run() {
        new JFrame("Groovy Window Demo").with {
            addWindowListener(new WindowAdapter() {
                void windowClosing(WindowEvent e) {
                    System.exit(0)
                }
            })

            getContentPane().add("Center", new WindowCreation())
            pack()
            setSize(new Dimension(150, 150))
            setVisible(true)
        }
    }
}
