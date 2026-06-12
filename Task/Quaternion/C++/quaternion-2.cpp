int main()
{
  Quaternion<> q0(1, 2, 3, 4);
  Quaternion<> q1(2, 3, 4, 5);
  Quaternion<> q2(3, 4, 5, 6);
  double r = 7;

  cout << "q0:      " << q0 << endl;
  cout << "q1:      " << q1 << endl;
  cout << "q2:      " << q2 << endl;
  cout << "r:       " << r << endl;
  cout << endl;
  cout << "-q0:     " << -q0 << endl;
  cout << "~q0:     " << ~q0 << endl;
  cout << endl;
  cout << "r * q0:  " << r*q0 << endl;
  cout << "r + q0:  " << r+q0 << endl;
  cout << "q0 / r:  " << q0/r << endl;
  cout << "q0 - r:  " << q0-r << endl;
  cout << endl;
  cout << "q0 + q1: " << q0+q1 << endl;
  cout << "q0 - q1: " << q0-q1 << endl;
  cout << "q0 * q1: " << q0*q1 << endl;
  cout << "q0 / q1: " << q0/q1 << endl;
  cout << endl;
  cout << "q0 * ~q0:     " << q0*~q0 << endl;
  cout << "q0 + q1*q2:   " << q0+q1*q2 << endl;
  cout << "(q0 + q1)*q2: " << (q0+q1)*q2 << endl;
  cout << "q0*q1*q2:     " << q0*q1*q2 << endl;
  cout << "(q0*q1)*q2:   " << (q0*q1)*q2 << endl;
  cout << "q0*(q1*q2):   " << q0*(q1*q2) << endl;
  cout << endl;
  cout << "||q0||:  " << sqrt(q0.normSquared()) << endl;
  cout << endl;
  cout << "q0*q1 - q1*q0: " << (q0*q1 - q1*q0) << endl;

  // Other base types
  Quaternion<int> q5(2), q6(3);
  cout << endl << q5*q6 << endl;
}
