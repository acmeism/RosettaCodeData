import javax.swing {

	JFrame { exitOnClose }
}
import java.awt {

	Color { white, black },
	Graphics
}
import ceylon.numeric.float {

	cos,
	toRadians,
	sin
}

shared void run() {
	
    value fractalTree = object extends JFrame("fractal tree") {

        background = black;
        setBounds(100, 100, 800, 600);
        resizable = false;
        defaultCloseOperation = exitOnClose;

        shared actual void paint(Graphics g) {

            void drawTree(Integer x1, Integer y1, Float angle, Integer depth) {
                if (depth <= 0) {
                    return;
                }
                value x2 = x1 + (cos(toRadians(angle)) * depth * 10.0).integer;
                value y2 = y1 + (sin(toRadians(angle)) * depth * 10.0).integer;
                g.drawLine(x1, y1, x2, y2);
                drawTree(x2, y2, angle - 20, depth - 1);
                drawTree(x2, y2, angle + 20, depth - 1);
            }

            g.color = white;
            drawTree(400, 500, -90.0, 9);
        }
    };

    fractalTree.visible = true;
}
