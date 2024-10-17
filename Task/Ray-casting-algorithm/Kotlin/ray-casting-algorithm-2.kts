fun main(args: Array<String>) {
    val figures = arrayOf(Figure("Square", arrayOf(Edge(Point(0.0, 0.0), Point(10.0, 0.0)), Edge(Point(10.0, 0.0), Point(10.0, 10.0)),
            Edge(Point(10.0, 10.0), Point(0.0, 10.0)),Edge(Point(0.0, 10.0), Point(0.0, 0.0)))),
    Figure("Square hole", arrayOf(Edge(Point(0.0, 0.0), Point(10.0, 0.0)), Edge(Point(10.0, 0.0), Point(10.0, 10.0)),
            Edge(Point(10.0, 10.0), Point(0.0, 10.0)), Edge(Point(0.0, 10.0), Point(0.0, 0.0)), Edge(Point(2.5, 2.5), Point(7.5, 2.5)),
            Edge(Point(7.5, 2.5), Point(7.5, 7.5)),Edge(Point(7.5, 7.5), Point(2.5, 7.5)), Edge(Point(2.5, 7.5), Point(2.5, 2.5)))),
    Figure("Strange", arrayOf(Edge(Point(0.0, 0.0), Point(2.5, 2.5)), Edge(Point(2.5, 2.5), Point(0.0, 10.0)),
            Edge(Point(0.0, 10.0), Point(2.5, 7.5)), Edge(Point(2.5, 7.5), Point(7.5, 7.5)), Edge(Point(7.5, 7.5), Point(10.0, 10.0)),
            Edge(Point(10.0, 10.0), Point(10.0, 0.0)), Edge(Point(10.0, 0.0), Point(2.5, 2.5)))),
    Figure("Exagon", arrayOf(Edge(Point(3.0, 0.0), Point(7.0, 0.0)), Edge(Point(7.0, 0.0), Point(10.0, 5.0)), Edge(Point(10.0, 5.0), Point(7.0, 10.0)),
            Edge(Point(7.0, 10.0), Point(3.0, 10.0)), Edge(Point(3.0, 10.0), Point(0.0, 5.0)), Edge(Point(0.0, 5.0), Point(3.0, 0.0)))))

    val points = listOf(Point(5.0, 5.0), Point(5.0, 8.0), Point(-10.0, 5.0), Point(0.0, 5.0),
            Point(10.0, 5.0), Point(8.0, 5.0), Point(10.0, 10.0))

    Ray_casting.check(figures, points)
}
