import java.awt.BorderLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JTextArea;
public class Beer extends JFrame implements ActionListener{
        private int x;
        private JButton take;
        private JTextArea text;
        public static void main(String[] args){
                new Beer();//build and show the GUI
        }

        public Beer(){
                x= 99;
                take= new JButton("Take one down, pass it around");
                text= new JTextArea(4,30);//size the area to 4 lines, 30 chars each
                text.setText(x + " bottles of beer on the wall\n" + x + " bottles of beer");
                text.setEditable(false);//so they can't change the text after it's displayed
                take.addActionListener(this);//listen to the button
                setLayout(new BorderLayout());//handle placement of components
                add(text, BorderLayout.CENTER);//put the text area in the largest section
                add(take, BorderLayout.SOUTH);//put the button underneath it
                pack();//auto-size the window
                setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);//exit on "X" (I hate System.exit...)
                setVisible(true);//show it
        }

        public void actionPerformed(ActionEvent arg0){
                if(arg0.getSource() == take){//if they clicked the button
                        JOptionPane.showMessageDialog(null, --x + " bottles of beer on the wall");//show a popup message
                        text.setText(x + " bottles of beer on the wall\n" + x + " bottles of beer");//change the text
                }
                if(x == 0){//if it's the end
                        dispose();//end
                }
        }
}
