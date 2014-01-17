import qd;

double lensqr(cdouble c) { return c.re * c.re + c.im * c.im; }

const Limit = 150;

void main() {
  screen(640, 480);
  for (int y = 0; y < screen.h; ++y) {
    flip; events;
    for (int x = 0; x < screen.w; ++x) {
      auto
        c_x = x * 1.0 / screen.w - 0.5,
        c_y = y * 1.0 / screen.h - 0.5,
        c = c_y * 2.0i + c_x * 3.0 - 1.0,
        z = 0.0i + 0.0,
        i = 0;
      for (; i < Limit; ++i) {
        z = z * z + c;
        if (lensqr(z) > 4) break;
      }
      auto value = cast(ubyte) (i * 255.0 / Limit);
      pset(x, y, rgb(value, value, value));
    }
  }
  while (true) { flip; events; }
}
