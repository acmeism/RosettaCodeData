define Point => type {
    parent pair

    public onCreate(x,y) => {
        ..onCreate(#x=#y)
    }

    public x => .first
    public y => .second
}

local(point) = Point(33, 42)
#point->x
#point->y
