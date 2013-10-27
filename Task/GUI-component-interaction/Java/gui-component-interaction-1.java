import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTextField;

public class Interact extends JFrame{
	final JTextField numberField;
	final JButton incButton, randButton;
	
	public Interact(){
		//stop the GUI threads when the user hits the X button
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		
		numberField = new JTextField();
		incButton = new JButton("Increment");
		randButton = new JButton("Random");
		
		numberField.setText("0");//start at 0
		
		//listen for button presses in the text field
		numberField.addKeyListener(new KeyListener(){
			@Override
			public void keyTyped(KeyEvent e) {
				//if the entered character is not a digit
				if(!Character.isDigit(e.getKeyChar())){
					//eat the event (i.e. stop it from being processed)
					e.consume();
				}
			}
			@Override
			public void keyReleased(KeyEvent e){}
			@Override
			public void keyPressed(KeyEvent e){}
		});
		
		//listen for button clicks on the increment button
		incButton.addActionListener(new ActionListener(){
			@Override
			public void actionPerformed(ActionEvent e) {
				String text = numberField.getText();
				if(text.isEmpty()){
					numberField.setText("1");
				}else{
					numberField.setText((Long.valueOf(text) + 1) + "");
				}
			}
		});
		
		//listen for button clicks on the random button
		randButton.addActionListener(new ActionListener(){
			@Override
			public void actionPerformed(ActionEvent e) {
				//show a dialog and if they answer "Yes"
				if(JOptionPane.showConfirmDialog(null, "Are you sure?") ==
					JOptionPane.YES_OPTION){
					//set the text field text to a random positive long
					numberField.setText(Long.toString((long)(Math.random()
							* Long.MAX_VALUE)));
				}
			}
		});
		
		//arrange the components in a grid with 2 rows and 1 column
		setLayout(new GridLayout(2, 1));
		
		//a secondary panel for arranging both buttons in one grid space in the window
		JPanel buttonPanel = new JPanel();
		
		//the buttons are in a grid with 1 row and 2 columns
		buttonPanel.setLayout(new GridLayout(1, 2));
		//add the buttons
		buttonPanel.add(incButton);
		buttonPanel.add(randButton);
		
		//put the number field on top of the buttons
		add(numberField);
		add(buttonPanel);
		//size the window appropriately
		pack();
		
	}

	public static void main(String[] args){
		new Interact().setVisible(true);
	}
}
