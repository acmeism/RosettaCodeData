import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.util.Timer;
import java.util.TimerTask;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.WindowConstants;

public class Rotate {

    private static class State {
        private final String text = "Hello World! ";
        private int startIndex = 0;
        private boolean rotateRight = true;
    }

    public static void main(String[] args) {
        State state = new State();

        JLabel label = new JLabel(state.text);
        label.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseClicked(MouseEvent event) {
                state.rotateRight = !state.rotateRight;
            }
        });

        TimerTask task = new TimerTask() {
            public void run() {
                int delta = state.rotateRight ? 1 : -1;
                state.startIndex = (state.startIndex + state.text.length() + delta) % state.text.length();
                label.setText(rotate(state.text, state.startIndex));
            }
        };
        Timer timer = new Timer(false);
        timer.schedule(task, 0, 500);

        JFrame rot = new JFrame();
        rot.setDefaultCloseOperation(WindowConstants.DISPOSE_ON_CLOSE);
        rot.add(label);
        rot.pack();
        rot.setLocationRelativeTo(null);
        rot.addWindowListener(new WindowAdapter() {
            @Override
            public void windowClosed(WindowEvent e) {
                timer.cancel();
            }
        });
        rot.setVisible(true);
    }

    private static String rotate(String text, int startIdx) {
        char[] rotated = new char[text.length()];
        for (int i = 0; i < text.length(); i++) {
            rotated[i] = text.charAt((i + startIdx) % text.length());
        }
        return String.valueOf(rotated);
    }
}
