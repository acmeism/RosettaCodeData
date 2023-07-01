template<class InputIterator, class InputIterator2>
void writedat(const char* filename,
              InputIterator xbegin, InputIterator xend,
              InputIterator2 ybegin, InputIterator2 yend,
              int xprecision=3, int yprecision=5)
{
  std::ofstream f;
  f.exceptions(std::ofstream::failbit | std::ofstream::badbit);
  f.open(filename);
  for ( ; xbegin != xend and ybegin != yend; ++xbegin, ++ybegin)
    f << std::setprecision(xprecision) << *xbegin << '\t'
      << std::setprecision(yprecision) << *ybegin << '\n';
}
