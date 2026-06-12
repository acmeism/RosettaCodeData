#include <array>
#include "vec.hpp"

template<class S>
constexpr SM_INLINE std::pair<S,S> sincos(S arg) { return { std::sin(arg), std::cos(arg) }; }

template<typename T, size_t N = 3>
struct alignas(2*sizeof(vec<T,N>)) line : std::array<vec<T,N>,2>
{
  constexpr INLINE vec<T,N>& dir() { return (*this)[0]; }
  constexpr INLINE vec<T,N>& pos() { return (*this)[1]; }
};

template<typename T>
struct quat : vec<T,4>
{
   constexpr INLINE vec<T,3>& vector() { return this->xyz(); }
   constexpr INLINE T&        scalar() { return this->w();   }
};

template<typename T>
struct alignas(2*sizeof(quat<T>)) motor : std::array<quat<T>,2>
{
  /* accessors */
  constexpr INLINE quat<T>& rotor()  { return (*this)[0]; }
  constexpr INLINE quat<T>& screw()  { return (*this)[1]; }
  constexpr INLINE quat<T>& weight() { return (*this)[0]; }
  constexpr INLINE quat<T>& bulk()   { return (*this)[1]; }
  constexpr INLINE quat<T>& v()      { return (*this)[0]; }
  constexpr INLINE quat<T>& m()      { return (*this)[1]; }

  constexpr INLINE motor<T>& unitize() { ((*this) *= (*this)[0].inv_mag()); }
  motor<T>(const vec<T,3>& p, const vec<T,3>& q)
  {
     (*this)[0] = { 0.0F, 0.0F, 0.0F, -1.0F };
     (*this)[1] = (p - q).dir();
  }
  motor<T>(const line<T,3>& k, const line<T,3>& l)
  {
      (*this)[0] = quat<T>(k.v() ^  l.m(), -dot(k.v(), l.v()));
      (*this)[1] = quat<T>((l.v() ^ !k.m()) -   (k.v() ^ !l.m()), -(l.v() ^ k.m()) - (k.v() ^ l.m()));
  }
  motor<T>(const plane<T,3>& g, const plane<T,3>& h)
  {
       v() = quat<T>(cross3(g,h),dot3(g,h));
       m() = quat<T>(g.w * h.dir() - h.w * g.dir(), static_cast<T>(0));
  }

};

template<typename T>
constexpr INLINE vec<T,3> cross3(motor<T> a, motor<T> b)
{
     return a.rotor().yzx() * b.rotor().zxy()
          - a.rotor().zxy() * b.rotor().yzx();
}

template<typename T>
constexpr INLINE motor<T> make_screw(T const angle, const line<T>& axis, T const disp)
{
     auto const[s c] = sincos(angle / static_cast<T>(2));
     return motor<T>{ (quat<T>)(axis.dir().pos() * (vec<T,4>){ s, s, s,  c }),
                      (quat<T>)(axis.dir().pos() * (vec<T,4>){ c, c, c, -1 } * disp / static_cast<T>(2) +
                                axis.pos().pos() * (vec<T,4>){ s, s, s,  s })};
}
template<typename T>
constexpr INLINE motor<T> make_rotation(T const angle, const line<T>& axis)
{
     auto const[s c] = sincos(angle / static_cast<T>(2));
     return motor<T>{ (quat<T>)(axis.dir().pos() * (vec<T,4>){ s, s, s,  c }),(quat<T>)0};
}
template<typename T>
constexpr INLINE motor<T> make_translation(const vec<T,3>& offset)
{
     return motor<T>{ (quat<T>)((vec<T,3>)0).pos(), (quat<T>)(offset / static_cast<T>(2)).dir() };
}

