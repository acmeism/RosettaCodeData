import javafx.application {
    Application
}
import javafx.stage {
    Stage
}
import javafx.animation {
    AnimationTimer
}
import ceylon.numeric.float {
    remainder,
    cos,
    sin,
    toRadians
}
import javafx.scene.layout {
    BorderPane
}
import javafx.scene.canvas {
    Canvas
}
import javafx.scene {
    Scene
}
import javafx.scene.paint {
    Color
}

shared void run() {
    Application.launch(`PolySpiralApp`);
}

shared class PolySpiralApp() extends Application() {

    value width = 600.0;
    value height = 600.0;

    variable value incr = 0.0;

    shared actual void start(Stage primaryStage) {

        value canvas = Canvas(width, height);
        value graphics = canvas.graphicsContext2D;

        object extends AnimationTimer() {

            shared actual void handle(Integer now) {

                incr = remainder(incr + 0.05, 360.0);

                variable value x = width / 2.0;
                variable value y = width / 2.0;
                variable value length = 5.0;
                variable value angle = incr;

                graphics.fillRect(0.0, 0.0, width, height);
                graphics.beginPath();
                graphics.moveTo(x, y);

                for (i in 1..150) {
                    value radians = toRadians(angle);
                    x = x + cos(radians) * length;
                    y = y + sin(radians)  * length;
                    graphics.stroke = Color.hsb(angle, 1.0, 1.0);
                    graphics.lineTo(x, y);
                    length += 3;
                    angle = remainder(angle + incr, 360.0);
                }

                graphics.stroke();
            }
        }.start();

        value root = BorderPane();
        root.center = canvas;
        value scene = Scene(root);
        primaryStage.title = "poly-spiral";
        primaryStage.setScene(scene);
        primaryStage.show();
    }
}
