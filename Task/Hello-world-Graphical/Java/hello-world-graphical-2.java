import javax.swing.*;
import java.awt.*;

public class HelloWorld {
    public static void main(String[] args) {

        SwingUtilities.invokeLater(() -> {
            JOptionPane.showMessageDialog(null, "Goodbye, world!");
            JFrame frame = new JFrame("Goodbye, world!");
            JTextArea text = new JTextArea("Goodbye, world!");
            JButton button = new JButton("Goodbye, world!");

            frame.setLayout(new FlowLayout());
            frame.add(button);
            frame.add(text);
            frame.pack();
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            frame.setVisible(true);
        });
    }
}
