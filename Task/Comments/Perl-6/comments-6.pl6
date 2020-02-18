#| Compute the distance between two points in the plane.
sub distance(
    Rat \x1, #= First point's abscissa,
    Rat \y1, #= First point's ordinate,
    Rat \x2, #= Second point's abscissa,
    Rat \y2, #= Second point's ordinate,
){
    return sqrt((x2 - x1)**2 + (y2 - y1)**2)
}
