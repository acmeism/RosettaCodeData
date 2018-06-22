import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.SwingUtilities;
public class Clicks extends JFrame{
	private long clicks = 0;

	public Clicks(){
		super("Clicks");//set window title
		JLabel label = new JLabel("There have been no clicks yet");
		JButton clicker = new JButton("click me");
		clicker.addActionListener(//listen to the button
			new ActionListener(){
				@Override
				public void actionPerformed(ActionEvent e) {
					label.setText("There have been " + (++clicks) + " clicks");//change the text
				}
			}
		);
		setLayout(new BorderLayout());//handles placement of components
		add(label,BorderLayout.CENTER);//add the label to the biggest section
		add(clicker,BorderLayout.SOUTH);//put the button underneath it
		label.setPreferredSize(new Dimension(300,100));//nice big label
		label.setHorizontalAlignment(JLabel.CENTER);//text not up against the side
		pack();//fix layout
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);//stop the program on "X"
		setVisible(true);//show it
	}
	public static void main(String[] args){
		SwingUtilities.invokeLater( //Swing UI updates should not happen on the main thread
			() -> new Clicks() //call the constructor where all the magic happens
		);
	}
}
