double meanAngle(double[] angles) {
  double y_part = 0.0;
  double x_part = 0.0;

  for (int i = 0; i < angles.length; i++) {
    x_part += Math.cos(angles[i] * Math.PI / 180.0);
    y_part += Math.sin(angles[i] * Math.PI / 180.0);
  }

  return Math.atan2(y_part / angles.length, x_part / angles.length) * 180 / Math.PI;
}

void main() {
  double[] angleSet1 = {350.0, 10.0};
  double[] angleSet2 = {90.0, 180.0, 270.0, 360.0};
  double[] angleSet3 = {10.0, 20.0, 30.0};

  print("\nMean Angle for 1st set :  %lf degrees", meanAngle(angleSet1));
  print("\nMean Angle for 2nd set : %lf degrees", meanAngle(angleSet2));
  print("\nMean Angle for 3rd set :  %lf degrees\n", meanAngle(angleSet3));
}
