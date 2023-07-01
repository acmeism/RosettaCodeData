import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.KeyEvent;
import java.util.function.Consumer;
import java.util.function.Predicate;
import java.util.stream.Stream;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTextField;

public interface Interact {
  public static final JFrame FRAME = new JFrame();
  public static final JTextField FIELD = new JTextField();
  public static final JPanel PANEL = new JPanel();

  public static void setDefaultCloseOperation(JFrame frame) {
    frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
  }

  public static void setText(JTextField field) {
    field.setText("0");
  }

  public static void setEditable(JTextField field) {
    field.setEditable(false);
  }

  public static boolean isDigitKeyChar(KeyEvent event) {
    return !Character.isDigit(event.getKeyChar());
  }

  public static void keyTyped(KeyEvent event) {
    Stream.of(event)
      .parallel()
      .filter(Interact::isDigitKeyChar)
      .forEach(KeyEvent::consume)
    ;
  }

  public static void addKeyListener(JTextField field) {
    field.addKeyListener((FunctionalKeyListener.Typed) Interact::keyTyped);
  }

  public static String mapText(String text) {
    return text.isEmpty()
      ? "1"
      : String.valueOf(Long.valueOf(text) + 1)
    ;
  }

  public static void actionPerformedOnIncrementButton(ActionEvent event) {
    Stream.of(FIELD)
      .parallel()
      .map(JTextField::getText)
      .map(Interact::mapText)
      .forEach(FIELD::setText)
    ;
  }

  public static void addActionListenerToIncrementButton(JButton button) {
    button.addActionListener(Interact::actionPerformedOnIncrementButton);
  }

  public static void addIncrementButton(JPanel panel) {
    Stream.of("Increment")
      .parallel()
      .map(JButton::new)
      .peek(Interact::addActionListenerToIncrementButton)
      .forEach(panel::add)
    ;
  }

  public static int showConfirmDialog(String question) {
    return JOptionPane.showConfirmDialog(null, question);
  }

  public static void setFieldText(int integer) {
    FIELD.setText(
      String.valueOf(
        (long) (Math.random() * Long.MAX_VALUE))
      )
    ;
  }

  public static void actionPerformedOnRandomButton(ActionEvent event) {
    Stream.of("Are you sure?")
      .parallel()
      .map(Interact::showConfirmDialog)
      .filter(Predicate.isEqual(JOptionPane.YES_OPTION))
      .forEach(Interact::setFieldText)
    ;
  }

  public static void addActionListenerToRandomButton(JButton button) {
    button.addActionListener(Interact::actionPerformedOnRandomButton);
  }

  public static void addRandomButton(JPanel panel) {
    Stream.of("Random")
      .parallel()
      .map(JButton::new)
      .peek(Interact::addActionListenerToRandomButton)
      .forEach(panel::add)
    ;
  }

  public static void acceptField(Consumer<JTextField> consumer) {
    consumer.accept(FIELD);
  }

  public static void prepareField(JTextField field) {
    Stream.<Consumer<JTextField>>of(
      Interact::setEditable,
      Interact::setText,
      Interact::addKeyListener
    )
      .parallel()
      .forEach(Interact::acceptField)
    ;
  }

  public static void addField(JFrame frame) {
    Stream.of(FIELD)
      .parallel()
      .peek(Interact::prepareField)
      .forEach(frame::add)
    ;
  }

  public static void acceptPanel(Consumer<JPanel> consumer) {
    consumer.accept(PANEL);
  }

  public static void processPanel(JPanel panel) {
    Stream.<Consumer<JPanel>>of(
      Interact::setLayout,
      Interact::addIncrementButton,
      Interact::addRandomButton
    )
      .parallel()
      .forEach(Interact::acceptPanel)
    ;
  }

  public static void addPanel(JFrame frame) {
    Stream.of(PANEL)
      .parallel()
      .peek(Interact::processPanel)
      .forEach(frame::add)
    ;
  }

  public static void setLayout(JFrame frame) {
    frame.setLayout(new GridLayout(2, 1));
  }

  public static void setLayout(JPanel panel) {
    panel.setLayout(new GridLayout(1, 2));
  }

  public static void setVisible(JFrame frame) {
    frame.setVisible(true);
  }

  public static void acceptFrame(Consumer<JFrame> consumer) {
    consumer.accept(FRAME);
  }

  public static void processField(JFrame frame) {
    Stream.<Consumer<JFrame>>of(
      Interact::setDefaultCloseOperation,
      Interact::setLayout,
      Interact::addField,
      Interact::addPanel,
      Interact::setVisible
    )
      .parallel()
      .forEach(Interact::acceptFrame)
    ;
  }

  public static void main(String... arguments) {
    Stream.of(FRAME)
      .parallel()
      .peek(Interact::processField)
      .forEach(JFrame::pack)
    ;
  }
}
