import javafx.application {
    Application
}
import javafx.stage {
    Stage
}
import javafx.scene {
    Scene
}
import javafx.scene.layout {
    BorderPane
}
import javafx.scene.image {
    WritableImage,
    ImageView
}
import ceylon.numeric.float {
    sin,
    sqrt,
    remainder
}
import javafx.scene.paint {
    Color
}
import javafx.animation {
    AnimationTimer
}

shared void run() {
    Application.launch(`Plasma`);
}

shared class Plasma() extends Application() {

    function createPlasma(Integer width, Integer height) => [
        for (j in 0:height) [
            for (i in 0:width)
            let (x = i.float, y = j.float)
            ( sin(x / 16.0)
            + sin(y / 8.0)
            + sin((x + y) / 16.0)
            + sin(sqrt(x ^ 2.0 + y ^ 2.0) / 8.0)
            + 4.0 )
            / 8.0
        ]
    ];

    void writeImage(Float[][] plasma, WritableImage img, Float hueShift = 0.0) {
        value writer = img.pixelWriter;
        for(j->row in plasma.indexed) {
            for(i->percent in row.indexed) {
                value hue = remainder(hueShift + percent, 1.0)  * 360.0;
                writer.setColor(i, j, Color.hsb(hue, 1.0, 1.0));
            }
        }
    }

    shared actual void start(Stage primaryStage) {

        value w = 500;
        value h = 500;
        value plasma = createPlasma(w, h);
        value img = WritableImage(w, h);
        writeImage(plasma, img);

        value root = BorderPane();
        root.center = ImageView(img);

        variable value hueShift = 0.0;
        value timer = object extends AnimationTimer() {
            shared actual void handle(Integer now) {
                hueShift = remainder(hueShift + 0.02, 1.0);
                writeImage(plasma, img, hueShift);
            }
        };
        timer.start();

        value scene = Scene(root);
        primaryStage.title = "Plasma";
        primaryStage.setScene(scene);
        primaryStage.sizeToScene();
        primaryStage.show();
    }

}
