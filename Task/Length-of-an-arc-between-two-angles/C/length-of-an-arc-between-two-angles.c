#define PI 3.14159265358979323846
#define ABS(x)  (x<0?-x:x)

double arc_length(double radius, double angle1, double angle2) {
    return (360 - ABS(angle2 - angle1)) * PI / 180 * radius;
}

void main()
{
    printf("%.7f\n",arc_length(10, 10, 120));
}
