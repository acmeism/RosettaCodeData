// Moebius function

function moebius(n) {
  m = 1;
  if (n != 1) {
    f = 2;
    do {
      if (n % (f * f) == 0) {
        m = 0;
      } else {
        if (n % f == 0) {
          m = -m;
          n /= f;
        }
        f++;
      }
    } while (f <= n && m != 0);
  }
  return m;
}

document.write("<table style=\"text-align:right\">");
for (t = 0; t <= 9; t++) {
  document.write("<tr>");
  for (u = 1; u <= 10; u++) {
    document.write("<td>");
    document.write(moebius(10 * t + u));
    document.write("</td>");
  }
  document.write("</tr>");
}
document.write("</table>");
