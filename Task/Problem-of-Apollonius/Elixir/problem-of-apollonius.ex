defmodule Circle do
  def apollonius(c1, c2, c3, s1, s2, s3) do
    {x1, y1, r1} = c1
    {w12, w13, w14} = calc(c1, c2, s1, s2)
    {u22, u23, u24} = calc(c2, c3, s2, s3)
    {w22, w23, w24} = {u22 - w12, u23 - w13, u24 - w14}

    p = -w23 / w22
    q = w24 / w22
    m = -w12 * p - w13
    n = w14 - w12 * q

    a = n*n + q*q - 1
    b = 2*m*n - 2*n*x1 + 2*p*q - 2*q*y1 + 2*s1*r1
    c = x1*x1 + m*m - 2*m*x1 + p*p + y1*y1 - 2*p*y1 - r1*r1

    d = b*b - 4*a*c
    rs = (-b - :math.sqrt(d)) / (2*a)
    {m + n*rs, p + q*rs, rs}
  end

  defp calc({x1, y1, r1}, {x2, y2, r2}, s1, s2) do
    v1 = x2 - x1
    {(y2 - y1) / v1, (x1*x1 - x2*x2 + y1*y1 - y2*y2 - r1*r1 + r2*r2) / (2*v1), (s2*r2 - s1*r1) / v1}
  end
end

c1 = {0, 0, 1}
c2 = {2, 4, 2}
c3 = {4, 0, 1}

IO.inspect Circle.apollonius(c1, c2, c3, 1, 1, 1)
IO.inspect Circle.apollonius(c1, c2, c3, -1, -1, -1)
