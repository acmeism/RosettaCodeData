#include <iostream>
using namespace std;

template<class T = double>
class Quaternion
{
public:
  T w, x, y, z;

  // Numerical constructor
  Quaternion(const T &w, const T &x, const T &y, const T &z): w(w), x(x), y(y), z(z) {};
  Quaternion(const T &x, const T &y, const T &z): w(T()), x(x), y(y), z(z) {}; // For 3-rotations
  Quaternion(const T &r): w(r), x(T()), y(T()), z(T()) {};
  Quaternion(): w(T()), x(T()), y(T()), z(T()) {};

  // Copy constructor and assignment
  Quaternion(const Quaternion &q): w(q.w), x(q.x), y(q.y), z(q.z) {};
  Quaternion& operator=(const Quaternion &q) { w=q.w; x=q.x; y=q.y; z=q.z; return *this; }

  // Unary operators
  Quaternion operator-() const { return Quaternion(-w, -x, -y, -z); }
  Quaternion operator~() const { return Quaternion(w, -x, -y, -z); } // Conjugate

  // Norm-squared. SQRT would have to be made generic to be used here
  T normSquared() const { return w*w + x*x + y*y + z*z; }

  // In-place operators
  Quaternion& operator+=(const T &r)
    { w += r; return *this; }
  Quaternion& operator+=(const Quaternion &q)
    { w += q.w; x += q.x; y += q.y; z += q.z; return *this; }

  Quaternion& operator-=(const T &r)
    { w -= r; return *this; }
  Quaternion& operator-=(const Quaternion &q)
    { w -= q.w; x -= q.x; y -= q.y; z -= q.z; return *this; }

  Quaternion& operator*=(const T &r)
    { w *= r; x *= r; y *= r; z *= r; return *this; }
  Quaternion& operator*=(const Quaternion &q)
  {
    T oldW(w), oldX(x), oldY(y), oldZ(z);
    w = oldW*q.w - oldX*q.x - oldY*q.y - oldZ*q.z;
    x = oldW*q.x + oldX*q.w + oldY*q.z - oldZ*q.y;
    y = oldW*q.y + oldY*q.w + oldZ*q.x - oldX*q.z;
    z = oldW*q.z + oldZ*q.w + oldX*q.y - oldY*q.x;
    return *this;
  }

  Quaternion& operator/=(const T &r)
    { w /= r; x /= r; y /= r; z /= r; return *this; }
  Quaternion& operator/=(const Quaternion &q)
  {
    T oldW(w), oldX(x), oldY(y), oldZ(z), n(q.normSquared());
    w = (oldW*q.w + oldX*q.x + oldY*q.y + oldZ*q.z) / n;
    x = (oldX*q.w - oldW*q.x + oldY*q.z - oldZ*q.y) / n;
    y = (oldY*q.w - oldW*q.y + oldZ*q.x - oldX*q.z) / n;
    z = (oldZ*q.w - oldW*q.z + oldX*q.y - oldY*q.x) / n;
    return *this;
  }

  // Binary operators based on in-place operators
  Quaternion operator+(const T &r) const { return Quaternion(*this) += r; }
  Quaternion operator+(const Quaternion &q) const { return Quaternion(*this) += q; }
  Quaternion operator-(const T &r) const { return Quaternion(*this) -= r; }
  Quaternion operator-(const Quaternion &q) const { return Quaternion(*this) -= q; }
  Quaternion operator*(const T &r) const { return Quaternion(*this) *= r; }
  Quaternion operator*(const Quaternion &q) const { return Quaternion(*this) *= q; }
  Quaternion operator/(const T &r) const { return Quaternion(*this) /= r; }
  Quaternion operator/(const Quaternion &q) const { return Quaternion(*this) /= q; }

  // Comparison operators, as much as they make sense
  bool operator==(const Quaternion &q) const
    { return (w == q.w) && (x == q.x) && (y == q.y) && (z == q.z); }
  bool operator!=(const Quaternion &q) const { return !operator==(q); }

  // The operators above allow quaternion op real. These allow real op quaternion.
  // Uses the above where appropriate.
  template<class T> friend Quaternion<T> operator+(const T &r, const Quaternion<T> &q);
  template<class T> friend Quaternion<T> operator-(const T &r, const Quaternion<T> &q);
  template<class T> friend Quaternion<T> operator*(const T &r, const Quaternion<T> &q);
  template<class T> friend Quaternion<T> operator/(const T &r, const Quaternion<T> &q);

  // Allows cout << q
  template<class T> friend ostream& operator<<(ostream &io, const Quaternion<T> &q);
};

// Friend functions need to be outside the actual class definition
template<class T>
Quaternion<T> operator+(const T &r, const Quaternion<T> &q)
  { return q+r; }

template<class T>
Quaternion<T> operator-(const T &r, const Quaternion<T> &q)
  { return Quaternion<T>(r-q.w, q.x, q.y, q.z); }

template<class T>
Quaternion<T> operator*(const T &r, const Quaternion<T> &q)
  { return q*r; }

template<class T>
Quaternion<T> operator/(const T &r, const Quaternion<T> &q)
{
  T n(q.normSquared());
  return Quaternion(r*q.w/n, -r*q.x/n, -r*q.y/n, -r*q.z/n);
}

template<class T>
ostream& operator<<(ostream &io, const Quaternion<T> &q)
{
  io << q.w;
  (q.x < T()) ? (io << " - " << (-q.x) << "i") : (io << " + " << q.x << "i");
  (q.y < T()) ? (io << " - " << (-q.y) << "j") : (io << " + " << q.y << "j");
  (q.z < T()) ? (io << " - " << (-q.z) << "k") : (io << " + " << q.z << "k");
  return io;
}
