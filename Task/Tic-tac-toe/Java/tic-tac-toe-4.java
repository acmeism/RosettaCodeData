import javax.swing.*;
import javax.swing.border.Border;
import java.awt.*;

public class TicTacToe {
        private static int turnNumber = 0;
        private static final JPanel panel = new JPanel();
        private static final JTextField ta = new JTextField("Player A's Turn (X)");
        private static final JButton r1c1 = new JButton("");
        private static final JButton r1c2 = new JButton("");
        private static final JButton r1c3 = new JButton("");
        private static final JButton r2c1 = new JButton("");
        private static final JButton r2c2 = new JButton("");
        private static final JButton r2c3 = new JButton("");
        private static final JButton r3c1 = new JButton("");
        private static final JButton r3c2 = new JButton("");
        private static final JButton r3c3 = new JButton("");
        private static final JButton restart = new JButton("New Game");
        private static final JPanel startMain = new JPanel();

    public static void main(String[]args){
        JFrame frame = new JFrame("Tic Tac Toe");
        frame.setSize(600,650);
        ta.setEditable(false);
        restart.addActionListener(e -> {
            enableAll();
            ta.setText("Player A's Turn (X)");
        });
        r1c1.setSize(67,67);
        r1c1.setFont(new Font("Trebuchet MS", Font.PLAIN, 70));
        r1c1.addActionListener(e -> {
            turnNumber++;
            if(turnNumber % 2 == 0){
                r1c1.setText("O");
                r1c1.setEnabled(false);
                ta.setText("Player A's Turn (X)");
            }else{
                r1c1.setText("X");
                r1c1.setEnabled(false);
                ta.setText("Player B's Turn (O)");
            }
            checkWin();
        });
        r1c2.setSize(67,67);
        r1c2.setFont(new Font("Trebuchet MS", Font.PLAIN, 70));
        r1c2.addActionListener(e -> {
            turnNumber++;
            if(turnNumber % 2 == 0){
                r1c2.setText("O");
                r1c2.setEnabled(false);
                ta.setText("Player A's Turn (X)");
            }else{
                r1c2.setText("X");
                r1c2.setEnabled(false);
                ta.setText("Player B's Turn (O)");
            }
            checkWin();
        });
        r1c3.setSize(67,67);
        r1c3.setFont(new Font("Trebuchet MS", Font.PLAIN, 70));
        r1c3.addActionListener(e -> {
            turnNumber++;
            if(turnNumber % 2 == 0){
                r1c3.setText("O");
                r1c3.setEnabled(false);
                ta.setText("Player A's Turn (X)");
            }else{
                r1c3.setText("X");
                r1c3.setEnabled(false);
                ta.setText("Player B's Turn (O)");
            }
            checkWin();
        });
        r2c1.setSize(67,67);
        r2c1.setFont(new Font("Trebuchet MS", Font.PLAIN, 70));
        r2c1.addActionListener(e -> {
            turnNumber++;
            if(turnNumber % 2 == 0){
                r2c1.setText("O");
                r2c1.setEnabled(false);
                ta.setText("Player A's Turn (X)");
            }else{
                r2c1.setText("X");
                r2c1.setEnabled(false);
                ta.setText("Player B's Turn (O)");
            }
            checkWin();
        });
        r2c2.setSize(67,67);
        r2c2.setFont(new Font("Trebuchet MS", Font.PLAIN, 70));
        r2c2.addActionListener(e -> {
            turnNumber++;
            if(turnNumber % 2 == 0){
                r2c2.setText("O");
                r2c2.setEnabled(false);
                ta.setText("Player A's Turn (X)");
            }else{
                r2c2.setText("X");
                r2c2.setEnabled(false);
                ta.setText("Player B's Turn (O)");
            }
            checkWin();
        });
        r2c3.setSize(67,67);
        r2c3.setFont(new Font("Trebuchet MS", Font.PLAIN, 70));
        r2c3.addActionListener(e -> {
            turnNumber++;
            if(turnNumber % 2 == 0){
                r2c3.setText("O");
                r2c3.setEnabled(false);
                ta.setText("Player A's Turn (X)");
            }else{
                r2c3.setText("X");
                r2c3.setEnabled(false);
                ta.setText("Player B's Turn (O)");
            }
            checkWin();
        });
        r3c1.setSize(67,67);
        r3c1.setFont(new Font("Trebuchet MS", Font.PLAIN, 70));
        r3c1.addActionListener(e -> {
            turnNumber++;
            if(turnNumber % 2 == 0){
                r3c1.setText("O");
                r3c1.setEnabled(false);
                ta.setText("Player A's Turn (X)");
            }else{
                r3c1.setText("X");
                r3c1.setEnabled(false);
                ta.setText("Player B's Turn (O)");
            }
            checkWin();
        });
        r3c2.setSize(67,67);
        r3c2.setFont(new Font("Trebuchet MS", Font.PLAIN, 70));
        r3c2.addActionListener(e -> {
            turnNumber++;
            if(turnNumber % 2 == 0){
                r3c2.setText("O");
                r3c2.setEnabled(false);
                ta.setText("Player A's Turn (X)");
            }else{
                r3c2.setText("X");
                r3c2.setEnabled(false);
                ta.setText("Player B's Turn (O)");
            }
            checkWin();
        });
        r3c3.setSize(67,67);
        r3c3.setFont(new Font("Trebuchet MS", Font.PLAIN, 70));
        r3c3.addActionListener(e -> {
            turnNumber++;
            if(turnNumber % 2 == 0){
                r3c3.setText("O");
                r3c3.setEnabled(false);
                ta.setText("Player A's Turn (X)");
            }else{
                r3c3.setText("X");
                r3c3.setEnabled(false);
                ta.setText("Player B's Turn (O)");
            }
            checkWin();
        });
        panel.setLayout(new GridLayout(3,3));

        panel.add(r1c1);
        panel.add(r1c2);
        panel.add(r1c3);
        panel.add(r2c1);
        panel.add(r2c2);
        panel.add(r2c3);
        panel.add(r3c1);
        panel.add(r3c2);
        panel.add(r3c3);
        startMain.setLayout(new GridLayout(5,5));
        JButton start = new JButton("Start");
        JLabel main = new JLabel("Tic Tac Toe", SwingConstants.CENTER);
        main.setFont(new Font("Trebuchet MS", Font.PLAIN, 70));
        main.setSize(400,400);
        startMain.add(main);
        startMain.add(start);
        frame.add(startMain);
        frame.setVisible(true);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        start.addActionListener(e -> {
            startMain.setVisible(false);
            frame.add(restart, BorderLayout.PAGE_START);
            frame.add(ta, BorderLayout.PAGE_END);
            frame.add(panel, BorderLayout.CENTER);
        });
    }
    public static void checkWin(){
        if(r1c1.getText().equals("X") && r1c2.getText().equals("X") && r1c3.getText().equals("X")){
            ta.setText("Player A Won! (X)");
            disableAll();
        }else if(r1c1.getText().equals("O") && r1c2.getText().equals("O") && r1c3.getText().equals("O")){
            ta.setText("Player B Won! (O)");
            disableAll();
        }else if(r1c1.getText().equals("X") && r2c2.getText().equals("X") && r3c3.getText().equals("X")){
            ta.setText("Player A Won! (X)");
            disableAll();
        }else if(r1c1.getText().equals("O") && r2c2.getText().equals("O") && r3c3.getText().equals("O")){
            ta.setText("Player B Won! (O)");
            disableAll();
        }else if(r1c1.getText().equals("X") && r2c1.getText().equals("X") && r3c1.getText().equals("X")){
            ta.setText("Player A Won! (X)");
            disableAll();
        }else if(r1c1.getText().equals("O") && r2c1.getText().equals("O") && r3c1.getText().equals("O")){
            ta.setText("Player B Won! (O)");
            disableAll();
        }else if(r2c1.getText().equals("X") && r2c2.getText().equals("X") && r2c3.getText().equals("X")){
            ta.setText("Player A Won! (X)");
            disableAll();
        }else if(r2c1.getText().equals("O") && r2c2.getText().equals("O") && r2c3.getText().equals("O")){
            ta.setText("Player B Won! (O)");
            disableAll();
        }else if(r1c2.getText().equals("X") && r2c2.getText().equals("X") && r3c2.getText().equals("X")){
            ta.setText("Player A Won! (X)");
            disableAll();
        }else if(r1c2.getText().equals("O") && r2c2.getText().equals("O") && r3c2.getText().equals("O")){
            ta.setText("Player B Won! (O)");
            disableAll();
        }else if(r1c3.getText().equals("X") && r2c3.getText().equals("X") && r3c3.getText().equals("X")){
            ta.setText("Player A Won! (X)");
            disableAll();
        }else if(r1c3.getText().equals("O") && r2c3.getText().equals("O") && r3c3.getText().equals("O")){
            ta.setText("Player B Won! (O)");
            disableAll();
        }else if(r3c1.getText().equals("X") && r3c2.getText().equals("X") && r3c3.getText().equals("X")){
            ta.setText("Player A Won! (X)");
            disableAll();
        }else if(r3c1.getText().equals("O") && r3c2.getText().equals("O") && r3c3.getText().equals("O")){
            ta.setText("Player B Won! (O)");
            disableAll();
        }else if(r3c1.getText().equals("X") && r2c2.getText().equals("X") && r1c3.getText().equals("X")){
            ta.setText("Player A Won! (X)");
            disableAll();
        }else if(r3c1.getText().equals("O") && r2c2.getText().equals("O") && r1c3.getText().equals("O")){
            ta.setText("Player B Won! (O)");
            disableAll();
        }else if(!r1c1.isEnabled() && !r1c2.isEnabled() && !r1c3.isEnabled() && !r2c1.isEnabled() && !r2c2.isEnabled() && !r2c3.isEnabled() && !r3c1.isEnabled() && !r3c2.isEnabled() && !r3c3.isEnabled()){
            ta.setText("Draw!");
            disableAll();
        }
    }
    public static void disableAll(){
        r1c1.setEnabled(false);
        r1c2.setEnabled(false);
        r1c3.setEnabled(false);
        r2c1.setEnabled(false);
        r2c2.setEnabled(false);
        r2c3.setEnabled(false);
        r3c1.setEnabled(false);
        r3c2.setEnabled(false);
        r3c3.setEnabled(false);
    }

    public static void enableAll(){
        turnNumber = 0;
        r1c1.setEnabled(true);
        r1c2.setEnabled(true);
        r1c3.setEnabled(true);
        r2c1.setEnabled(true);
        r2c2.setEnabled(true);
        r2c3.setEnabled(true);
        r3c1.setEnabled(true);
        r3c2.setEnabled(true);
        r3c3.setEnabled(true);
        r1c1.setText("");
        r1c2.setText("");
        r1c3.setText("");
        r2c1.setText("");
        r2c2.setText("");
        r2c3.setText("");
        r3c1.setText("");
        r3c2.setText("");
        r3c3.setText("");
        panel.setEnabled(true);
    }
}
