import ceylon.language {
    consolePrint = print
}

shared void run() {

    class Point {

        shared variable Integer x;
        shared variable Integer y;

        shared new(Integer x = 0, Integer y = 0) {
            this.x = x;
            this.y = y;
        }

        shared new copy(Point p) {
            this.x = p.x;
            this.y = p.y;
        }

        shared default void print() {
            consolePrint("[Point ``x`` ``y``]");
        }
    }

    class Circle extends Point {

        shared variable Integer r;

        shared new(Integer x = 0, Integer y = 0, Integer r = 0) extends Point(x, y) {
            this.r = r;
        }

        shared new copy(Circle c) extends Point.copy(c){
            this.r = c.r;
        }

        shared actual void print() {
            consolePrint("[Circle ``x`` ``y`` ``r``]");
        }
    }

    value shapes = [
        Point(), Point(1), Point(1, 2), Point {y = 3;}, Point.copy(Point(4, 5)),
        Circle(), Circle(1), Circle(2, 3), Circle(4, 5, 6), Circle {y = 7; r = 8;}, Circle.copy(Circle(9, 10, 11))
    ];

    for(shape in shapes) {
        shape.print();
    }
}
