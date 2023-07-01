import javafx.animation.AnimationTimer
import javafx.application.Application
import javafx.scene.Scene
import javafx.scene.layout.Pane
import javafx.scene.paint.Color
import javafx.scene.shape.Circle
import javafx.stage.Stage

class ChaosGame extends Application {

    final randomNumberGenerator = new Random()

    @Override
    void start(Stage primaryStage) {
        primaryStage.title = 'Chaos Game'
        primaryStage.scene = getScene()
        primaryStage.show()
    }

    def getScene() {
        def colors = [Color.RED, Color.GREEN, Color.BLUE]

        final width = 640, height = 640, margin = 60
        final size = width - 2 * margin

        def points = [
                new Circle(width / 2, margin, 1, colors[0]),
                new Circle(margin, size, 1, colors[1]),
                new Circle(margin + size, size, 1, colors[2])
        ]

        def pane = new Pane()
        pane.style = '-fx-background-color: black;'
        points.each {
            pane.children.add it
        }

        def currentPoint = new Circle().with {
            centerX = randomNumberGenerator.nextInt(size - margin) + margin
            centerY =  randomNumberGenerator.nextInt(size - margin) + margin
            it
        }

        ({

            def newPoint = generatePoint(currentPoint, points, colors)
            pane.children.add newPoint
            currentPoint = newPoint

        } as AnimationTimer).start()

        new Scene(pane, width, height)
    }

    def generatePoint(currentPoint, points, colors) {
        def selection = randomNumberGenerator.nextInt 3
        new Circle().with {
            centerX = (currentPoint.centerX + points[selection].centerX) / 2
            centerY = (currentPoint.centerY + points[selection].centerY) / 2
            radius = 1
            fill = colors[selection]
            it
        }
    }

    static main(args) {
        launch(ChaosGame)
    }
}
