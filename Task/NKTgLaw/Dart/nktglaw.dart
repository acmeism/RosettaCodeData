class Result {
  final double p;
  final double nktg1;
  final double nktg2;
  final String tendency1;
  final String tendency2;

  Result({
    required this.p,
    required this.nktg1,
    required this.nktg2,
    required this.tendency1,
    required this.tendency2,
  });
}

Result nktg(double x, double v, double m, double dm_dt) {
  double p = m * v;
  double nktg1 = x * p;
  double nktg2 = dm_dt * p;

  String tendency1;
  if (nktg1 > 0) {
    tendency1 = "Moving away from stable state";
  } else if (nktg1 < 0) {
    tendency1 = "Moving toward stable state";
  } else {
    tendency1 = "Stable equilibrium";
  }

  String tendency2;
  if (nktg2 > 0) {
    tendency2 = "Mass variation supports movement";
  } else if (nktg2 < 0) {
    tendency2 = "Mass variation resists movement";
  } else {
    tendency2 = "No mass variation effect";
  }

  return Result(
    p: p,
    nktg1: nktg1,
    nktg2: nktg2,
    tendency1: tendency1,
    tendency2: tendency2,
  );
}

void main() {
  Result result = nktg(2, 3, 4, -0.5);

  print('p: ${result.p}');
  print('NKTg1: ${result.nktg1}');
  print('NKTg2: ${result.nktg2}');
  print('Tendency1: ${result.tendency1}');
  print('Tendency2: ${result.tendency2}');
}
