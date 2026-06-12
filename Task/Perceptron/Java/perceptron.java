import java.awt.*;
import java.awt.event.ActionEvent;
import java.util.*;
import javax.swing.*;
import javax.swing.Timer;

public class Perceptron extends JPanel {

    class Trainer {
        double[] inputs;
        int answer;

        Trainer(double x, double y, int a) {
            inputs = new double[]{x, y, 1};
            answer = a;
        }
    }

    Trainer[] training = new Trainer[2000];
    double[] weights;
    double c = 0.00001;
    int count;

    public Perceptron(int n) {
        Random r = new Random();
        Dimension dim = new Dimension(640, 360);
        setPreferredSize(dim);
        setBackground(Color.white);

        weights = new double[n];
        for (int i = 0; i < weights.length; i++) {
            weights[i] = r.nextDouble() * 2 - 1;
        }

        for (int i = 0; i < training.length; i++) {
            double x = r.nextDouble() * dim.width;
            double y = r.nextDouble() * dim.height;

            int answer = y < f(x) ? -1 : 1;

            training[i] = new Trainer(x, y, answer);
        }

        new Timer(10, (ActionEvent e) -> {
            repaint();
        }).start();
    }

    private double f(double x) {
        return x * 0.7 + 40;
    }

    int feedForward(double[] inputs) {
        assert inputs.length == weights.length : "weights and input length mismatch";

        double sum = 0;
        for (int i = 0; i < weights.length; i++) {
            sum += inputs[i] * weights[i];
        }
        return activate(sum);
    }

    int activate(double s) {
        return s > 0 ? 1 : -1;
    }

    void train(double[] inputs, int desired) {
        int guess = feedForward(inputs);
        double error = desired - guess;
        for (int i = 0; i < weights.length; i++) {
            weights[i] += c * error * inputs[i];
        }
    }

    @Override
    public void paintComponent(Graphics gg) {
        super.paintComponent(gg);
        Graphics2D g = (Graphics2D) gg;
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                RenderingHints.VALUE_ANTIALIAS_ON);

        // we're drawing upside down
        int x = getWidth();
        int y = (int) f(x);
        g.setStroke(new BasicStroke(2));
        g.setColor(Color.orange);
        g.drawLine(0, (int) f(0), x, y);

        train(training[count].inputs, training[count].answer);
        count = (count + 1) % training.length;

        g.setStroke(new BasicStroke(1));
        g.setColor(Color.black);
        for (int i = 0; i < count; i++) {
            int guess = feedForward(training[i].inputs);

            x = (int) training[i].inputs[0] - 4;
            y = (int) training[i].inputs[1] - 4;

            if (guess > 0)
                g.drawOval(x, y, 8, 8);
            else
                g.fillOval(x, y, 8, 8);
        }
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            JFrame f = new JFrame();
            f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            f.setTitle("Perceptron");
            f.setResizable(false);
            f.add(new Perceptron(3), BorderLayout.CENTER);
            f.pack();
            f.setLocationRelativeTo(null);
            f.setVisible(true);
        });
    }
}
