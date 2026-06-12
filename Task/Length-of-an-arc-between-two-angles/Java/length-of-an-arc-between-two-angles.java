public static double arcLength(double r, double a1, double a2){
    return (360.0 - Math.abs(a2-a1))*Math.PI/180.0 * r;
}
