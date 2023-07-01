import "graphics" for Canvas, Color, Point
import "dome" for Window

class Game {
    static init() {
        Window.title = "Sierpinski Arrowhead Curve"
        __width = 770
        __height = 770
        Window.resize(__width, __height)
        Canvas.resize(__width, __height)
        var order = 6
        __iy = (order&1 == 0) ? -1: 1  // apex will point upwards
        __theta = 0
        __cx = __width / 2
        __cy = __height
        __h  = __cx / 2
        __prev = Point.new(__cx-__width/2 +__h, (__height-__cy)*__iy + 2*__h)
        __col = Color.white
        arrowhead(order, __cx)
    }

    static update() {}

    static draw(alpha) {}

    static arrowhead(order, length) {
        // if order is even, we can just draw the curve
        if (order&1 == 0) {
            curve(order, length, 60)
        } else {
            turn(60)
            curve(order, length, -60)
        }
        drawLine(length) // needed to make base symmetric
    }

    static drawLine(length) {
        var curr = Point.new(__cx-__width/2 +__h, (__height-__cy)*__iy + 2*__h)
        Canvas.line(__prev.x, __prev.y, curr.x, curr.y, __col)
        var rads = __theta * Num.pi / 180
        __cx = __cx + length*(rads.cos)
        __cy = __cy + length*(rads.sin)
        __prev = curr
    }

    static turn(angle) { __theta = (__theta + angle) % 360 }

    static curve(order, length, angle) {
        if (order == 0) {
            drawLine(length)
        } else {
            curve(order-1, length/2, -angle)
            turn(angle)
            curve(order-1, length/2, angle)
            turn(angle)
            curve(order-1, length/2, -angle)
        }
    }
}
