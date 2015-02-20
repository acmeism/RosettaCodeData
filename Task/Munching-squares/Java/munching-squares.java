import java.awt.Color;
import java.awt.Graphics;

import javax.swing.JFrame;
import javax.swing.JPanel;

public class XorPattern extends JFrame{
    private JPanel xorPanel;

    public XorPattern(){
        xorPanel = new JPanel(){
            @Override
            public void paint(Graphics g) {
                for(int y = 0; y < getHeight();y++){
                    for(int x = 0; x < getWidth();x++){
                        g.setColor(new Color(0, (x ^ y) % 256, 0));
                        g.drawLine(x, y, x, y);
                    }
                }
            }
        };
        add(xorPanel);
        setSize(300, 300);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setVisible(true);
    }

    public static void main(String[] args){
        new XorPattern();
    }
}
