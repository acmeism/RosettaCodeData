import java.awt.Color;
import java.awt.Dimension;
import java.awt.EventQueue;
import java.awt.Font;
import java.awt.Graphics;

import javax.swing.JFrame;
import javax.swing.JPanel;

public final class MosaicMatrix extends JPanel {

  public static void main(String[] args) {
    EventQueue.invokeLater( () -> {
      JFrame.setDefaultLookAndFeelDecorated(true);
      JFrame frame = new JFrame("Mosaic Matrix");
      frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
      frame.setLocationByPlatform(true);
      frame.setResizable(false);
      frame.add( new MosaicMatrix() );
      frame.pack();
      frame.setVisible(true);
    } );
  }

  @Override
    public void paintComponent(Graphics graphics) {
      super.paintComponent(graphics);
      graphics.setColor(Color.BLACK);
      graphics.fillRect(0, 0, 610, 610);

      for ( int row = 0; row < 10; row++ ) {
      for ( int col = 0; col < 10; col++ ) {
                final int cx = row * 60 + 10;
                final int cy = col * 60 + 10;
                if ( ( row + col ) % 2 == 0 ) {
                  graphics.setColor(Color.GREEN);
                    graphics.fillRect(cx, cy, 50, 50);
                    graphics.setColor(Color.BLACK);
                    graphics.drawString("1", cx + 20, cy + 30);
                } else {
                  graphics.setColor(Color.CYAN);
                    graphics.fillRect(cx, cy, 50, 50);
                    graphics.setColor(Color.BLACK);
                    graphics.drawString("0", cx + 20, cy + 30);
                 }
            }
        }
    }

  private MosaicMatrix() {
    setPreferredSize( new Dimension(610, 610) );
    setFont( new Font("Calibri", Font.PLAIN, 20) );
  }

}
