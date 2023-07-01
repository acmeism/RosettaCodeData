import java.awt.*;
import javax.swing.*;

class Pendulum extends JPanel implements Runnable {

    private angle = Math.PI / 2;
    private length;

    Pendulum(length) {
        this.length = length;
        setDoubleBuffered(true);
    }

    @Override
    void paint(Graphics g) {
        g.setColor(Color.WHITE);
        g.fillRect(0, 0, getWidth(), getHeight());
        g.setColor(Color.BLACK);
        int anchorX = getWidth() / 2, anchorY = getHeight() / 4;
        def ballX = anchorX + (Math.sin(angle) * length) as int;
        def ballY = anchorY + (Math.cos(angle) * length) as int;
        g.drawLine(anchorX, anchorY, ballX, ballY);
        g.fillOval(anchorX - 3, anchorY - 4, 7, 7);
        g.fillOval(ballX - 7, ballY - 7, 14, 14);
    }

    void run() {
        def angleAccel, angleVelocity = 0, dt = 0.1;
        while (true) {
            angleAccel = -9.81 / length * Math.sin(angle);
            angleVelocity += angleAccel * dt;
            angle += angleVelocity * dt;
            repaint();
            try { Thread.sleep(15); } catch (InterruptedException ex) {}
        }
    }

    @Override
    Dimension getPreferredSize() {
        return new Dimension(2 * length + 50, (length / 2 * 3) as int);
    }

    static void main(String[] args) {
        def f = new JFrame("Pendulum");
        def p = new Pendulum(200);
        f.add(p);
        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        f.pack();
        f.setVisible(true);
        new Thread(p).start();
    }
}
