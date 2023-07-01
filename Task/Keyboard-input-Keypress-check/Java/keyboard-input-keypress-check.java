import java.awt.event.*;
import javax.swing.*;

public class Test extends JFrame {

    Test() {
        addKeyListener(new KeyAdapter() {
            @Override
            public void keyPressed(KeyEvent e) {
                int keyCode = e.getKeyCode();
                System.out.println(keyCode);
            }
        });
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            Test f = new Test();
            f.setFocusable(true);
            f.setVisible(true);
        });
    }
}
