import java.awt.BorderLayout;
import java.awt.EventQueue;
import java.awt.Frame;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.lang.reflect.InvocationTargetException;
import javax.swing.AbstractAction;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;

public class WindowController extends JFrame {
   // Create UI on correct thread
   public static void main( final String[] args ) {
      EventQueue.invokeLater( () -> new WindowController() );
   }

   private JComboBox<ControlledWindow> list;

   // Button class to call the right method
   private class ControlButton extends JButton {
      private ControlButton( final String name ) {
         super(
            new AbstractAction( name ) {
               public void actionPerformed( final ActionEvent e ) {
                  try {
                     WindowController.class.getMethod( "do" + name )
                        .invoke ( WindowController.this );
                  } catch ( final Exception x ) { // poor practice
                     x.printStackTrace();        // also poor practice
                  }
               }
            }
         );
      }
   }

   // UI for controlling windows
   public WindowController() {
      super( "Controller" );

      final JPanel main = new JPanel();
      final JPanel controls = new JPanel();

      setLocationByPlatform( true );
      setResizable( false );
      setDefaultCloseOperation( JFrame.EXIT_ON_CLOSE );
      setLayout( new BorderLayout( 3, 3 ) );
      getRootPane().setBorder( new EmptyBorder( 3, 3, 3, 3 ) );
      add( new JLabel( "Add windows and control them." ), BorderLayout.NORTH );
      main.add( list = new JComboBox<>() );
      add( main, BorderLayout.CENTER );
      controls.setLayout( new GridLayout( 0, 1, 3, 3 ) );
      controls.add( new ControlButton( "Add"      ) );
      controls.add( new ControlButton( "Hide"     ) );
      controls.add( new ControlButton( "Show"     ) );
      controls.add( new ControlButton( "Close"    ) );
      controls.add( new ControlButton( "Maximise" ) );
      controls.add( new ControlButton( "Minimise" ) );
      controls.add( new ControlButton( "Move"     ) );
      controls.add( new ControlButton( "Resize"   ) );
      add( controls, BorderLayout.EAST );
      pack();
      setVisible( true );
   }

   // These are the windows we're controlling, but any JFrame would do
   private static class ControlledWindow extends JFrame {
      private int num;

      public ControlledWindow( final int num ) {
         super( Integer.toString( num ) );
         this.num = num;
         setLocationByPlatform( true );
         getRootPane().setBorder( new EmptyBorder( 3, 3, 3, 3 ) );
         setDefaultCloseOperation( JFrame.DISPOSE_ON_CLOSE );
         add( new JLabel( "I am window " + num + ". Use the controller to control me." ) );
         pack();
         setVisible( true );
      }

      public String toString() {
         return "Window " + num;
      }
   }

   // Here comes the useful bit - window control code
   // Everything else was just to allow us to do this!

   public void doAdd() {
      list.addItem( new ControlledWindow( list.getItemCount () + 1 ) );
      pack();
   }

   public void doHide() {
      final JFrame window = getWindow();
      if ( null == window ) {
         return;
      }
      window.setVisible( false );
   }

   public void doShow() {
      final JFrame window = getWindow();
      if ( null == window ) {
         return;
      }
      window.setVisible( true );
   }

   public void doClose() {
      final JFrame window = getWindow();
      if ( null == window ) {
         return;
      }
      window.dispose();
   }

   public void doMinimise() {
      final JFrame window = getWindow();
      if ( null == window ) {
         return;
      }
      window.setState( Frame.ICONIFIED );
   }

   public void doMaximise() {
      final JFrame window = getWindow();
      if ( null == window ) {
         return;
      }
      window.setExtendedState( Frame.MAXIMIZED_BOTH );
   }

   public void doMove() {
      final JFrame window = getWindow();
      if ( null == window ) {
         return;
      }
      final int hPos = getInt( "Horizontal position?" );
      if ( -1 == hPos ) {
         return;
      }
      final int vPos = getInt( "Vertical position?" );
      if ( -1 == vPos ) {
         return;
      }
      window.setLocation ( hPos, vPos );
   }

   public void doResize() {
      final JFrame window = getWindow();
      if ( null == window ) {
         return;
      }
      final int width = getInt( "Width?" );
      if ( -1 == width ) {
         return;
      }
      final int height = getInt( "Height?" );
      if ( -1 == height ) {
         return;
      }
      window.setBounds ( window.getX(), window.getY(), width, height );
   }

   private JFrame getWindow() {
      final JFrame window = ( JFrame ) list.getSelectedItem();
      if ( null == window ) {
         JOptionPane.showMessageDialog( this, "Add a window first" );
      }
      return window;
   }

   private int getInt(final String prompt) {
      final String s = JOptionPane.showInputDialog( prompt );
      if ( null == s ) {
         return -1;
      }
      try {
         return Integer.parseInt( s );
      } catch ( final NumberFormatException x ) {
         JOptionPane.showMessageDialog( this, "Not a number" );
         return -1;
      }
   }
}
