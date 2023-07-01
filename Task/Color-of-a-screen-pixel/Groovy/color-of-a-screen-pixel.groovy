import java.awt.Robot

class GetPixelColor {
    static void main(args) {
        println getColorAt(args[0] as Integer, args[1] as Integer)
    }

    static getColorAt(x, y) {
        new Robot().getPixelColor(x, y)
    }
}
