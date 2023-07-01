import javax.swing.JFrame;
import javax.swing.SwingUtilities;

public class WindowExample {

  public static void main(String[] args) {
    Runnable runnable = new Runnable() {
      public void run() {
	createAndShow();
      }
    };
    SwingUtilities.invokeLater(runnable);
  }
	
  static void createAndShow() {
    JFrame frame = new JFrame("Hello World");
    frame.setSize(640,480);
    frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    frame.setVisible(true);
  }
}
