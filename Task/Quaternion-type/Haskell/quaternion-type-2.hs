class Quaternion(a, b, c, d)

  method norm ()
    return sqrt (a*a + b*b + c*c + d*d)
  end

  method negative ()
    return Quaternion(-a, -b, -c, -d)
  end

  method conjugate ()
    return Quaternion(a, -b, -c, -d)
  end

  method add (n)
    if type(n) == "Quaternion__state"
      then return Quaternion(a+n.a, b+n.b, c+n.c, d+n.d)
      else return Quaternion(a+n, b, c, d)
  end

  method multiply (n)
    if type(n) == "Quaternion__state"
      then return Quaternion(a*n.a - b*n.b - c*n.c - d*n.d,
                             a*n.b + b*n.a + c*n.d - d*n.c,
                             a*n.c - b*n.d + c*n.a + d*n.b,
                             a*n.d + b*n.c - c*n.b + d*n.a)
      else return Quaternion(a*n, b*n, c*n, d*n)
  end

  method sign (n)
    return if n >= 0 then "+" else "-"
  end

  method string ()
    return ("" || a || sign(b) || abs(b) || "i" || sign(c) || abs(c) || "j" || sign(d) || abs(d) || "k");
  end

  initially(a, b, c, d)
    self.a := if /a then 0 else a
    self.b := if /b then 0 else b
    self.c := if /c then 0 else c
    self.d := if /d then 0 else d
end
