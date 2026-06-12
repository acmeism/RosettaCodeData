import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.EventQueue;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Rectangle;
import java.util.concurrent.ThreadLocalRandom;

import javax.swing.JComponent;
import javax.swing.JFrame;

public final class HarrissSpiral extends JComponent {

   public static void main(String[] args) {
        EventQueue.invokeLater( () -> {
         JFrame.setDefaultLookAndFeelDecorated(true);
            JFrame frame = new JFrame("Harriss Spiral");
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            frame.setPreferredSize( new Dimension(WIDTH, HEIGHT) );
            frame.setResizable(false);
            frame.add( new HarrissSpiral() );
            frame.pack();
            frame.setLocationRelativeTo(null);
            frame.setVisible(true);
        } );
    }

   @Override
   protected void paintComponent(Graphics graphics) {
        super.paintComponent(graphics);
        Graphics2D graphics2D = (Graphics2D) graphics;
        graphics2D.setColor(SHOW_LINES ? Color.WHITE : Color.DARK_GRAY);
        graphics2D.fill(SCREEN);
        drawHarrissSpiral(graphics2D);
   }

   private static void drawHarrissSpiral(Graphics2D graphics2D) {
      final double HR2 = HR * HR;
      final double HR3 = HR2 * HR;
      final double HR4 = HR2 * HR2;
      final double HR5 = HR4 * HR;
      final double HR6 = HR4 * HR2;
      final double HR8 = HR4 * HR4;
      final double startX = WIDTH / 2.0 + 50.0;
      final double startY = HEIGHT - 75.0;
      final double initialLength = 600 / HR2;

      drawArcSegment(startX + initialLength / HR, startY - ( initialLength + initialLength / HR2 ),
         0.0, initialLength / HR4, 4, 6, graphics2D);

      drawArcSegment(startX + initialLength / HR4, startY - ( initialLength + initialLength / HR2 ),
         270.0, initialLength / HR5, 3, 6, graphics2D);

      drawArcSegment(startX - ( initialLength / HR + initialLength / HR3 ),
         startY - ( initialLength + initialLength / HR2 ), 270.0, initialLength / HR5, 3, 6, graphics2D);

      drawArcSegment(startX - ( initialLength / HR + initialLength / HR3 ),
         startY - initialLength / HR8, 180.0, initialLength / HR6, 2, 6, graphics2D);

      drawArcSegment(startX - initialLength / HR4, startY - initialLength / HR3,
         -270.0, initialLength / HR4, 3, 8, graphics2D);

      drawArcSegment(startX - initialLength / HR4, startY - initialLength / HR,
         0.0, initialLength / HR5, 2, 8, graphics2D);

      drawArcSegment(startX - initialLength / HR, startY - initialLength,
         270.0, initialLength / HR2, 5, 12, graphics2D);

      drawArcSegment(startX - initialLength / HR, startY - initialLength / HR3,
         180.0, initialLength / HR3, 4, 12, graphics2D);

      drawArcSegment(startX, startY - initialLength, 0.0, initialLength / HR, 6, 16, graphics2D);

      drawArcSegment(startX, startY, -90.0, initialLength, 7, 16, graphics2D);
   }

   private static void drawArcSegment(double x, double y, double angle, double length,
                                     int iteration, int lineWidth, Graphics2D graphics2D) {
      String heading = "";
      Color arcColor = Color.WHITE;

       if ( iteration > 0 ) {

          final double xEnd = x + length * Math.cos(Math.toRadians(angle));
          final double yEnd = y + length * Math.sin(Math.toRadians(angle));

          if ( Math.floor(yEnd) < Math.floor(y) ) { heading = "RIGHT"; }
          if ( Math.floor(xEnd) < Math.floor(x) ) { heading = "UPPER"; }
          if ( Math.floor(yEnd) > Math.floor(y) ) { heading = "LEFT"; }
          if ( Math.floor(xEnd) > Math.floor(x) ) { heading = "LOWER"; }

          if ( SHOW_LINES ) {
            graphics2D.setColor(Color.BLACK);
            graphics2D.setStroke( new BasicStroke(1) );
             graphics2D.drawLine((int) x, (int) y, (int) xEnd, (int) yEnd);
          }

          double centreX = 0.0, centreY = 0.0;

          switch ( heading ) {
             case "RIGHT" -> {
                 centreX = x - length / 2.0;
                 centreY = y - length / 2.0;
                 arcColor = ( RANDOM.nextInt(2) == 1 ) ? Color.YELLOW : Color.GREEN;
             }
             case "UPPER" -> {
                 centreX = x - length / 2.0;
                 centreY = y + length / 2.0;
                 angle += 180;
                 arcColor = Color.RED;
             }
             case "LEFT" -> {
                 centreX = x + length / 2.0;
                 centreY = y + length / 2.0;
                 arcColor = Color.BLUE;
             }
             case "LOWER" -> {
                 centreX = x + length / 2.0;
                 centreY = y - length / 2.0;
                 angle += 180;
                 arcColor = ( RANDOM.nextInt(2) == 1 ) ? Color.ORANGE : Color.BLACK;
             }
          }

          final double radius = 0.7 * length;

          graphics2D.setColor(arcColor);
          graphics2D.setStroke( new BasicStroke(lineWidth, BasicStroke.CAP_ROUND, BasicStroke.JOIN_BEVEL) );
          graphics2D.drawArc((int) ( centreX - radius ), (int) ( centreY - radius ),
                          (int) radius * 2, (int) radius * 2, (int) angle + 45, 90);

          if ( heading.equals("UPPER") || heading.equals("LOWER") ) { angle -= 180; }

          drawArcSegment(xEnd, yEnd, angle - 90, length / HR, iteration - 1, lineWidth, graphics2D);
       }
   }

   private static final int WIDTH = 1_000;
   private static final int HEIGHT = 750;
   private static final double HR = 1.3247; // Harriss ratio
   private static final boolean SHOW_LINES = false;
   private static final Rectangle SCREEN = new Rectangle(0, 0, WIDTH, HEIGHT);
   private static final ThreadLocalRandom RANDOM = ThreadLocalRandom.current();

}
