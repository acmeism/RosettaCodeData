import java.awt.*;
import javax.swing.JFrame;

public class Test extends JFrame {

    public static void main(String[] args) {
        new Test();
    }

    Test() {
        Toolkit toolkit = Toolkit.getDefaultToolkit();

        Dimension screenSize = toolkit.getScreenSize();
        System.out.println("Physical screen size: " + screenSize);

        Insets insets = toolkit.getScreenInsets(getGraphicsConfiguration());
        System.out.println("Insets: " + insets);

        screenSize.width -= (insets.left + insets.right);
        screenSize.height -= (insets.top + insets.bottom);
        System.out.println("Max available: " + screenSize);
    }
}
