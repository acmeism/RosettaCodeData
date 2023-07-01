class Point {
    int x, y;
    void create(int _x, int _y)
    {
        x = _x;
        y = _y;
    }
}

void main()
{
    object point = Point(10, 20);
    write("%d %d\n", point->x, point->y);
}
