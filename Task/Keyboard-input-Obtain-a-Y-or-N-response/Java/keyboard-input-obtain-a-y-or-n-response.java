import java.awt.event.KeyEvent;
import java.io.IOException;
import java.awt.EventQueue;
import java.awt.event.KeyAdapter;
import javax.swing.JFrame;

public final class KeyboardInputObtainYOrN {

	public static void main(String[] aArgs) {
		EventQueue.invokeLater( () -> { new Test("Obtain Y or N"); } );
    }
	
}

final class Test extends JFrame {
	
	public Test(String aTitle) {
        super(aTitle);
        addKeyListener( new YesOrNoKeyAdapter() );
        setVisible(true);

        try {
			while ( System.in.available() > 0 ) {
				System.in.read();
			}
		} catch (IOException ioe) {
			ioe.printStackTrace();
		}

        System.out.println("Do you want to quit the program? Y / N");
    }

}

final class YesOrNoKeyAdapter extends KeyAdapter {
	
	@Override
    public void keyPressed(KeyEvent aKeyEvent) {
		if ( aKeyEvent.getKeyCode() == KeyEvent.VK_Y ) {
			System.out.println("Y was pressed, quitting the program");
            Runtime.getRuntime().exit(0);
        } else if ( aKeyEvent.getKeyCode() == KeyEvent.VK_N ) {
        	System.out.println("N was pressed, but the program is about to end anyway");
        	Runtime.getRuntime().exit(0);
        } else {
        	System.out.println("Please try again, only Y or N are acceptable");
        }
    }	
	
}
