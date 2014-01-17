import javax.swing.*;
import java.awt.event.*;
import java.awt.*;


//Make sure the name of the class is the same as the .java file name.
//If you change the class name you should change the class object name in runGUI method
public class ticTacToeCallum implements ActionListener {

  static JFrame frame;
  static JPanel contentPane;
  static JLabel lblEnterFirstPlayerName, lblEnterSecondPlayerName, lblFirstPlayerScore, lblSecondPlayerScore;
  static JButton btnButton1, btnButton2, btnButton3, btnButton4, btnButton5, btnButton6, btnButton7, btnButton8, btnButton9, btnClearBoard, btnClearAll, btnCloseGame;
  static JTextField txtEnterFirstPlayerName, txtEnterSecondPlayerName;
  static Icon imgicon = new ImageIcon("saveIcon.JPG");

  Font buttonFont = new Font("Arial", Font.PLAIN, 20);


  //to adjust the frame size change the values in pixels
  static int width = 600;
  static int length = 400;
  static int firstPlayerScore = 0;
  static int secondPlayerScore = 0;
  static int playerTurn = 1;
  static int roundComplete = 0;
  static int button1 = 1, button2 = 1, button3 = 1, button4 = 1, button5 = 1, button6 = 1, button7 = 1, button8 = 1, button9 = 1; // 1 is true, 0 is false


  public ticTacToeCallum(){
	
    frame = new JFrame("Tic Tac Toe ^_^");
    frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

    contentPane = new JPanel();
    contentPane.setLayout(new GridLayout(6, 3, 10, 10));
    contentPane.setBorder(BorderFactory.createEmptyBorder(20, 20, 20, 20));

    btnButton1 = new JButton("");
    btnButton1.setFont(buttonFont);
    btnButton1.setAlignmentX(JButton.CENTER_ALIGNMENT);
    btnButton1.setIcon(imgicon);
    btnButton1.setActionCommand("CLICK1");
    btnButton1.addActionListener(this);
    contentPane.add(btnButton1);

    btnButton2 = new JButton("");
    btnButton2.setFont(buttonFont);
    btnButton2.setAlignmentX(JButton.CENTER_ALIGNMENT);
    btnButton2.setIcon(imgicon);
    btnButton2.setActionCommand("CLICK2");
    btnButton2.addActionListener(this);
    contentPane.add(btnButton2);

    btnButton3 = new JButton("");
    btnButton3.setFont(buttonFont);
    btnButton3.setAlignmentX(JButton.CENTER_ALIGNMENT);
    btnButton3.setIcon(imgicon);
    btnButton3.setActionCommand("CLICK3");
    btnButton3.addActionListener(this);
    contentPane.add(btnButton3);

    btnButton4 = new JButton("");
    btnButton4.setFont(buttonFont);
    btnButton4.setAlignmentX(JButton.CENTER_ALIGNMENT);
    btnButton4.setIcon(imgicon);
    btnButton4.setActionCommand("CLICK4");
    btnButton4.addActionListener(this);
    contentPane.add(btnButton4);

    btnButton5 = new JButton("");
    btnButton5.setFont(buttonFont);
    btnButton5.setAlignmentX(JButton.CENTER_ALIGNMENT);
    btnButton5.setIcon(imgicon);
    btnButton5.setActionCommand("CLICK5");
    btnButton5.addActionListener(this);
    contentPane.add(btnButton5);

    btnButton6 = new JButton("");
    btnButton6.setFont(buttonFont);
    btnButton6.setAlignmentX(JButton.CENTER_ALIGNMENT);
    btnButton6.setIcon(imgicon);
    btnButton6.setActionCommand("CLICK6");
    btnButton6.addActionListener(this);
    contentPane.add(btnButton6);

    btnButton7 = new JButton("");
    btnButton7.setFont(buttonFont);
    btnButton7.setAlignmentX(JButton.CENTER_ALIGNMENT);
    btnButton7.setIcon(imgicon);
    btnButton7.setActionCommand("CLICK7");
    btnButton7.addActionListener(this);
    contentPane.add(btnButton7);

    btnButton8 = new JButton("");
    btnButton8.setFont(buttonFont);
    btnButton8.setAlignmentX(JButton.CENTER_ALIGNMENT);
    btnButton8.setIcon(imgicon);
    btnButton8.setActionCommand("CLICK8");
    btnButton8.addActionListener(this);
    contentPane.add(btnButton8);

    btnButton9 = new JButton("");
    btnButton9.setFont(buttonFont);
    btnButton9.setAlignmentX(JButton.CENTER_ALIGNMENT);
    btnButton9.setIcon(imgicon);
    btnButton9.setActionCommand("CLICK9");
    btnButton9.addActionListener(this);
    contentPane.add(btnButton9);

    lblEnterFirstPlayerName = new JLabel("Enter First Player's Name");
    contentPane.add(lblEnterFirstPlayerName);

    txtEnterFirstPlayerName = new JTextField("");
    contentPane.add(txtEnterFirstPlayerName);

    lblFirstPlayerScore = new JLabel("Score: " + firstPlayerScore);
    contentPane.add(lblFirstPlayerScore);

    lblEnterSecondPlayerName = new JLabel("Enter Second Player's Name");
    contentPane.add(lblEnterSecondPlayerName);

    txtEnterSecondPlayerName = new JTextField("");
    contentPane.add(txtEnterSecondPlayerName);

    lblSecondPlayerScore = new JLabel("Score: " + secondPlayerScore);
    contentPane.add(lblSecondPlayerScore);

    btnClearBoard = new JButton("Clear Board");
    btnClearBoard.setAlignmentX(JButton.CENTER_ALIGNMENT);
    btnClearBoard.setIcon(imgicon);
    btnClearBoard.setActionCommand("CLICKClearBoard");
    btnClearBoard.addActionListener(this);
    contentPane.add(btnClearBoard);

    btnClearAll = new JButton("Clear All");
    btnClearAll.setAlignmentX(JButton.CENTER_ALIGNMENT);
    btnClearAll.setIcon(imgicon);
    btnClearAll.setActionCommand("CLICKClearAll");
    btnClearAll.addActionListener(this);
    contentPane.add(btnClearAll);

    btnCloseGame = new JButton("Close Game");
    btnCloseGame.setAlignmentX(JButton.CENTER_ALIGNMENT);
    btnCloseGame.setIcon(imgicon);
    btnCloseGame.setActionCommand("CLICKCloseGame");
    btnCloseGame.addActionListener(this);
    contentPane.add(btnCloseGame);

    frame.setContentPane(contentPane);
    frame.pack();
    frame.setSize(width,length);
    frame.setVisible(true);

  }

  public void actionPerformed(ActionEvent event) {
    String eventName = event.getActionCommand();
     if (eventName.equals("CLICK1")) {
    	 if (button1 == 1){
    		 if (playerTurn == 1){
    			 btnButton1.setForeground(Color.RED);
    			 btnButton1.setText("X");
   	  			 playerTurn = 2;
    			 button1 = 0;
    		 } else if (playerTurn == 2) {
    			 btnButton1.setForeground(Color.GREEN);
    			 btnButton1.setText("O");
    			 playerTurn = 1;
    			 button1 = 0;
    		 }
    	 }
      } else if (eventName.equals ("CLICK2")) {
    	  if (button2 == 1){	
    	  	if (playerTurn == 1){
    	  		btnButton2.setForeground(Color.RED);
    	  		btnButton2.setText("X");
  	  			playerTurn = 2;
    	  		button2 = 0;
    	  	} else if (playerTurn == 2) {
    	  		btnButton2.setForeground(Color.GREEN);
    	  		btnButton2.setText("O");
    	  		playerTurn = 1;
    	  		button2 = 0;
    	  	}
    	  }	
      }	else if (eventName.equals ("CLICK3")) {
    	  if (button3 == 1){	
      	  	if (playerTurn == 1){
      	  		btnButton3.setForeground(Color.RED);
      	  		btnButton3.setText("X");
  	  			playerTurn = 2;
      	  		button3 = 0;
      	  	} else if (playerTurn == 2) {
      	  		btnButton3.setForeground(Color.GREEN);
      	  		btnButton3.setText("O");
      	  		playerTurn = 1;
      	  		button3 = 0;
      	  	}
      	  }
      }	else if (eventName.equals ("CLICK4")) {
    	  if (button4 == 1){	
      	  	if (playerTurn == 1){
      	  		btnButton4.setForeground(Color.RED);
      	  		btnButton4.setText("X");
  	  			playerTurn = 2;
      	  		button4 = 0;
      	  	} else if (playerTurn == 2) {
      	  		btnButton4.setForeground(Color.GREEN);
      	  		btnButton4.setText("O");
      	  		playerTurn = 1;
      	  		button4 = 0;
      	  	}
      	  }
      }	else if (eventName.equals ("CLICK5")) {
    	  if (button5 == 1){	
      	  	if (playerTurn == 1){
      	  		btnButton5.setForeground(Color.RED);
  	  			btnButton5.setText("X");
  	  			playerTurn = 2;
  	  			button5 = 0;
      	  	} else if (playerTurn == 2) {
      	  		btnButton5.setForeground(Color.GREEN);
  	  			btnButton5.setText("O");
  	  			playerTurn = 1;
  	  			button5 = 0;
      	  	}
      	  }
      } else if (eventName.equals ("CLICK6")) {
    	  if (button6 == 1){	
      	  	if (playerTurn == 1){
      	  		btnButton6.setForeground(Color.RED);
  	  			btnButton6.setText("X");
  	  			playerTurn = 2;
  	  			button6 = 0;
      	  	} else if (playerTurn == 2) {
      	  		btnButton6.setForeground(Color.GREEN);
  	  			btnButton6.setText("O");
  	  			playerTurn = 1;
  	  			button6 = 0;
      	  	}
      	  }
      } else if (eventName.equals ("CLICK7")) {
    	  if (button7 == 1){	
      	  	if (playerTurn == 1){
      	  		btnButton7.setForeground(Color.RED);
  	  			btnButton7.setText("X");
  	  			playerTurn = 2;
  	  			button7 = 0;
      	  	} else if (playerTurn == 2) {
      	  		btnButton7.setForeground(Color.GREEN);
  	  			btnButton7.setText("O");
  	  			playerTurn = 1;
  	  			button7 = 0;
      	  	}
      	  }
      } else if (eventName.equals ("CLICK8")) {
    	  if (button8 == 1){	
      	  	if (playerTurn == 1){
      	  		btnButton8.setForeground(Color.RED);
  	  			btnButton8.setText("X");
  	  			playerTurn = 2;
  	  			button8 = 0;
      	  	} else if (playerTurn == 2) {
      	  		btnButton8.setForeground(Color.GREEN);
  	  			btnButton8.setText("O");
  	  			playerTurn = 1;
  	  			button8 = 0;
      	  	}
      	  }
      } else if (eventName.equals ("CLICK9")) {
    	  if (button9 == 1){	
      	  	if (playerTurn == 1){
      	  		btnButton9.setForeground(Color.RED);
  	  			btnButton9.setText("X");
  	  			playerTurn = 2;
  	  			button9 = 0;
      	  	} else if (playerTurn == 2) {
      	  		btnButton9.setForeground(Color.GREEN);
  	  			btnButton9.setText("O");
  	  			playerTurn = 1;
  	  			button9 = 0;
      	  	}
      	  }
      } else if (eventName.equals ("CLICKClearBoard")) {

    	  btnButton1.setText("");
          btnButton2.setText("");
          btnButton3.setText("");
          btnButton4.setText("");
          btnButton5.setText("");
          btnButton6.setText("");
          btnButton7.setText("");
          btnButton8.setText("");
          btnButton9.setText("");

          button1 = 1;
          button2 = 1;
          button3 = 1;
          button4 = 1;
          button5 = 1;
          button6 = 1;
          button7 = 1;
          button8 = 1;
          button9 = 1;

          playerTurn = 1;

          roundComplete = 0;

      } else if (eventName.equals ("CLICKClearAll")) {
    	
    	  btnButton1.setText("");
          btnButton2.setText("");
          btnButton3.setText("");
          btnButton4.setText("");
          btnButton5.setText("");
          btnButton6.setText("");
          btnButton7.setText("");
          btnButton8.setText("");
          btnButton9.setText("");

          firstPlayerScore = 0;
          lblFirstPlayerScore.setText("Score: " + firstPlayerScore);
          secondPlayerScore = 0;
          lblSecondPlayerScore.setText("Score: " + secondPlayerScore);

          txtEnterFirstPlayerName.setText("");
          txtEnterSecondPlayerName.setText("");

          button1 = 1;
          button2 = 1;
          button3 = 1;
          button4 = 1;
          button5 = 1;
          button6 = 1;
          button7 = 1;
          button8 = 1;
          button9 = 1;

          playerTurn = 1;

          roundComplete = 0;

      } else if (eventName.equals ("CLICKCloseGame")) {
    	  System.exit(0);
      }
     score();
    }


  public static void score(){
	  if (roundComplete == 0){
	  if (btnButton1.getText().equals(btnButton2.getText())  && btnButton1.getText().equals(btnButton3.getText())){
	    	if (btnButton1.getText().equals("X")){
	    		firstPlayerScore += 1;
	    		lblFirstPlayerScore.setText("Score: " + firstPlayerScore);
	    		roundComplete = 1;
	    	} else if (btnButton1.getText().equals("O")){
	    		secondPlayerScore += 1;
	    		lblSecondPlayerScore.setText("Score: " + secondPlayerScore);
	    		roundComplete = 1;
	    	}
	    }
	    if (btnButton1.getText().equals(btnButton4.getText())  && btnButton1.getText().equals(btnButton7.getText())){
	    	if (btnButton1.getText().equals("X")){
	    		firstPlayerScore += 1;
	    		lblFirstPlayerScore.setText("Score: " + firstPlayerScore);
	    		roundComplete = 1;
	    	} else if (btnButton1.getText().equals("O")){
	    		secondPlayerScore += 1;
	    		lblSecondPlayerScore.setText("Score: " + secondPlayerScore);
	    		roundComplete = 1;
	    	}
	    }
	    if (btnButton1.getText().equals(btnButton5.getText())  && btnButton1.getText().equals(btnButton9.getText())){
	    	if (btnButton1.getText().equals("X")){
	    		firstPlayerScore += 1;
	    		lblFirstPlayerScore.setText("Score: " + firstPlayerScore);
	    		roundComplete = 1;
	    	} else if (btnButton1.getText().equals("O")){
	    		secondPlayerScore += 1;
	    		lblSecondPlayerScore.setText("Score: " + secondPlayerScore);
	    		roundComplete = 1;
	    	}
	    }
	    if (btnButton7.getText().equals(btnButton8.getText())  && btnButton7.getText().equals(btnButton9.getText())){
	    	if (btnButton7.getText().equals("X")){
	    		firstPlayerScore += 1;
	    		lblFirstPlayerScore.setText("Score: " + firstPlayerScore);
	    		roundComplete = 1;
	    	} else if (btnButton7.getText().equals("O")){
	    		secondPlayerScore += 1;
	    		lblSecondPlayerScore.setText("Score: " + secondPlayerScore);
	    		roundComplete = 1;
	    	}
	    }
	    if (btnButton7.getText().equals(btnButton5.getText())  && btnButton7.getText().equals(btnButton3.getText())){
	    	if (btnButton7.getText().equals("X")){
	    		firstPlayerScore += 1;
	    		lblFirstPlayerScore.setText("Score: " + firstPlayerScore);
	    		roundComplete = 1;
	    	} else if (btnButton7.getText().equals("O")){
	    		secondPlayerScore += 1;
	    		lblSecondPlayerScore.setText("Score: " + secondPlayerScore);
	    		roundComplete = 1;
	    	}
	    }
	    if (btnButton3.getText().equals(btnButton6.getText())  && btnButton3.getText().equals(btnButton9.getText())){
	    	if (btnButton3.getText().equals("X")){
	    		firstPlayerScore += 1;
	    		lblFirstPlayerScore.setText("Score: " + firstPlayerScore);
	    		roundComplete = 1;
	    	} else if (btnButton3.getText().equals("O")){
	    		secondPlayerScore += 1;
	    		lblSecondPlayerScore.setText("Score: " + secondPlayerScore);
	    		roundComplete = 1;
	    	}
	    }
	    if (btnButton4.getText().equals(btnButton5.getText())  && btnButton4.getText().equals(btnButton6.getText())){
	    	if (btnButton4.getText().equals("X")){
	    		firstPlayerScore += 1;
	    		lblFirstPlayerScore.setText("Score: " + firstPlayerScore);
	    		roundComplete = 1;
	    	} else if (btnButton4.getText().equals("O")){
	    		secondPlayerScore += 1;
	    		lblSecondPlayerScore.setText("Score: " + secondPlayerScore);
	    		roundComplete = 1;
	    	}
	    }
	    if (btnButton2.getText().equals(btnButton5.getText())  && btnButton2.getText().equals(btnButton8.getText())){
	    	if (btnButton2.getText().equals("X")){
	    		firstPlayerScore += 1;
	    		lblFirstPlayerScore.setText("Score: " + firstPlayerScore);
	    		roundComplete = 1;
	    	} else if (btnButton2.getText().equals("O")){
	    		secondPlayerScore += 1;
	    		lblSecondPlayerScore.setText("Score: " + secondPlayerScore);
	    		roundComplete = 1;
	    	}
	    }
	  }
	    if (roundComplete == 1){
	    	button1 = 0;
	    	button2 = 0;
	    	button3 = 0;
	    	button4 = 0;
	    	button5 = 0;
	    	button6 = 0;
	    	button7 = 0;
	    	button8 = 0;
	    	button9 = 0;
	    }
  }

  /**
   * Create and show the GUI.
   */
  private static void runGUI() {
    ticTacToeCallum        greeting     = new ticTacToeCallum();
  }



  //Do not change this method
  public static void main(String[] args) {
    /* Methods that create and show a GUI should be run from an event-dispatching thread */
    javax.swing.SwingUtilities.invokeLater(new Runnable() {
      public void run() {
        runGUI();
      }
    });
  }
}
