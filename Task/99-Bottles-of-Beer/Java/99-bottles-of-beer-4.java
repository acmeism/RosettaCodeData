import java.awt.BorderLayout;
import java.awt.event.ActionEvent;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JTextArea;

public class Beer extends JFrame {
    private int x;
    private JTextArea text;

    public static void main(String[] args) {
        new Beer().setVisible(true);
    }

    public Beer() {
        x = 99;

        JButton take = new JButton("Take one down, pass it around");
        take.addActionListener(this::onTakeClick);

        text = new JTextArea(4, 30);
        text.setText(x + " bottles of beer on the wall\n" + x + " bottles of beer");
        text.setEditable(false);

        setLayout(new BorderLayout());
        add(text, BorderLayout.CENTER);
        add(take, BorderLayout.PAGE_END);
        pack();
        setLocationRelativeTo(null);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
    }

    private void onTakeClick(ActionEvent event) {
        JOptionPane.showMessageDialog(null, --x + " bottles of beer on the wall");
        text.setText(x + " bottles of beer on the wall\n" + x + " bottles of beer");
        if (x == 0) {
            dispose();
        }
    }
}
