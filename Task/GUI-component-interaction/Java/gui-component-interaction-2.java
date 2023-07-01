import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;

public interface FunctionalKeyListener extends KeyListener {
  @Override
  public default void keyPressed(KeyEvent event) {}
  @Override
  public default void keyTyped(KeyEvent event) {}
  @Override
  public default void keyReleased(KeyEvent event) {}

  @FunctionalInterface
  public static interface Pressed extends FunctionalKeyListener {
    @Override
    public void keyPressed(KeyEvent event);
  }

  @FunctionalInterface
  public static interface Typed extends FunctionalKeyListener {
    @Override
    public void keyTyped(KeyEvent event);
  }

  @FunctionalInterface
  public static interface Released extends FunctionalKeyListener {
    @Override
    public void keyReleased(KeyEvent event);
  }
}
