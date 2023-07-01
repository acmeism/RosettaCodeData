import javafx.animation.AnimationTimer
import javafx.application.Application
import javafx.scene.Group
import javafx.scene.Scene
import javafx.scene.image.ImageView
import javafx.scene.image.WritableImage
import javafx.scene.paint.Color
import javafx.stage.Stage

class BarnsleyFern extends Application {

    @Override
    void start(Stage primaryStage) {
        primaryStage.title = 'Barnsley Fern'
        primaryStage.scene = getScene()
        primaryStage.show()
    }

    def getScene() {
        def root = new Group()
        def scene = new Scene(root, 640, 640)
        def imageWriter = new WritableImage(640, 640)
        def imageView = new ImageView(imageWriter)
        root.children.add imageView

        def pixelWriter = imageWriter.pixelWriter

        def x = 0, y = 0

        ({

            50.times {
                def r = Math.random()

                if (r <= 0.01) {
                    x = 0
                    y = 0.16 * y
                } else if (r <= 0.08) {
                    x = 0.2 * x - 0.26 * y
                    y = 0.23 * x + 0.22 * y + 1.6
                } else if (r <= 0.15) {
                    x = -0.15 * x + 0.28 * y
                    y = 0.26 * x + 0.24 * y + 0.44
                } else {
                    x = 0.85 * x + 0.04 * y
                    y = -0.04 * x + 0.85 * y + 1.6
                }

                pixelWriter.setColor(Math.round(640 / 2 + x * 640 / 11) as Integer, Math.round(640 - y * 640 / 11) as Integer, Color.GREEN)
            }

        } as AnimationTimer).start()

        scene
    }

    static void main(args) {
        launch(BarnsleyFern)
    }
}
