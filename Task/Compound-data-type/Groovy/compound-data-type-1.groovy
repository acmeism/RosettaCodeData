class Point {
    int x
    int y

    // Default values make this a 0-, 1-, and 2-argument constructor
    Point(int x = 0, int y = 0) { this.x = x; this.y = y }
    String toString() { "{x:${x}, y:${y}}" }
}
