begin

procedure tobern2 (a0, a1, a2, b0, b1, b2);
  value a0, a1, a2; comment pass by value;
  real a0, a1, a2;
  real b0, b1, b2;
comment Subprogram (1): transform monomial coefficients
        a0, a1, a2 to Bernstein coefficients b0, b1, b2;
begin
  b0 := a0;
  b1 := a0 + ((1/2) * a1);
  b2 := a0 + a1 + a2
end tobern2;

real procedure evalbern2 (b0, b1, b2, t);
  value b0, b1, b2, t;
  real b0, b1, b2, t;
comment Subprogram (2): evaluate, at t, the polynomial with
        Bernstein coefficients b0, b1, b2. Use de Casteljau's
        algorithm;
begin
  real s, b01, b12, b012;
  s := 1 - t;
  b01 := (s * b0) + (t * b1);
  b12 := (s * b1) + (t * b2);
  b012 := (s * b01) + (t * b12);
  evalbern2 := b012
end evalbern2;

procedure tobern3 (a0, a1, a2, a3, b0, b1, b2, b3);
  value a0, a1, a2, a3;
  real a0, a1, a2, a3;
  real b0, b1, b2, b3;
comment Subprogram (3): transform monomial coefficients
        a0, a1, a2, a3 to Bernstein coefficients b0, b1,
        b2, b3;
begin
  b0 := a0;
  b1 := a0 + ((1/3) * a1);
  b2 := a0 + ((2/3) * a1) + ((1/3) * a2);
  b3 := a0 + a1 + a2 + a3
end tobern3;

real procedure evalbern3 (b0, b1, b2, b3, t);
  value b0, b1, b2, b3, t;
  real b0, b1, b2, b3, t;
comment Subprogram (4): evaluate, at t, the polynomial
        with Bernstein coefficients b0, b1, b2, b3. Use
        de Casteljau's algorithm;
begin
  real s, b01, b12, b23, b012, b123, b0123;
  s := 1 - t;
  b01 := (s * b0) + (t * b1);
  b12 := (s * b1) + (t * b2);
  b23 := (s * b2) + (t * b3);
  b012 := (s * b01) + (t * b12);
  b123 := (s * b12) + (t * b23);
  b0123 := (s * b012) + (t * b123);
  evalbern3 := b0123
end evalbern3;

procedure bern2to3 (q0, q1, q2, c0, c1, c2, c3);
  value q0, q1, q2;
  real q0, q1, q2;
  real c0, c1, c2, c3;
comment Subprogram (5): transform the quadratic Bernstein
        coefficients q0, q1, q2 to the cubic Bernstein
        coefficients c0, c1, c2, c3;
begin
  c0 := q0;
  c1 := ((1/3) * q0) + ((2/3) * q1);
  c2 := ((2/3) * q1) + ((1/3) * q2);
  c3 := q2
end bern2to3;

  real p0m, p1m, p2m;
  real q0m, q1m, q2m;
  real r0m, r1m, r2m, r3m;

  real p0b2, p1b2, p2b2;
  real q0b2, q1b2, q2b2;

  real p0b3, p1b3, p2b3, p3b3;
  real q0b3, q1b3, q2b3, q3b3;
  real r0b3, r1b3, r2b3, r3b3;

  real pc0, pc1, pc2, pc3;
  real qc0, qc1, qc2, qc3;

  real x, y;

  p0m := 1; p1m := 0; p2m := 0;
  q0m := 1; q1m := 2; q2m := 3;
  r0m := 1; r1m := 2; r2m := 3; r3m := 4;

  tobern2 (p0m, p1m, p2m, p0b2, p1b2, p2b2);
  tobern2 (q0m, q1m, q2m, q0b2, q1b2, q2b2);
  outstring (1, "Subprogram (1) examples:\n");
  outstring (1, "  mono ( ");
  outreal (1, p0m); outstring (1, ", ");
  outreal (1, p1m); outstring (1, ", ");
  outreal (1, p2m); outstring (1, ") --> bern ( ");
  outreal (1, p0b2); outstring (1, ", ");
  outreal (1, p1b2); outstring (1, ", ");
  outreal (1, p2b2); outstring (1, ")\n");
  outstring (1, "  mono ( ");
  outreal (1, q0m); outstring (1, ", ");
  outreal (1, q1m); outstring (1, ", ");
  outreal (1, q2m); outstring (1, ") --> bern ( ");
  outreal (1, q0b2); outstring (1, ", ");
  outreal (1, q1b2); outstring (1, ", ");
  outreal (1, q2b2); outstring (1, ")\n");

  outstring (1, "Subprogram (2) examples:\n");
  x := 0.25;
  y := evalbern2 (p0b2, p1b2, p2b2, x);
  outstring (1, "  p ( "); outreal (1, x);
  outstring (1, ") = "); outreal (1, y);
  outstring (1, "\n");
  x := 7.50;
  y := evalbern2 (p0b2, p1b2, p2b2, x);
  outstring (1, "  p ( "); outreal (1, x);
  outstring (1, ") = "); outreal (1, y);
  outstring (1, "\n");
  x := 0.25;
  y := evalbern2 (q0b2, q1b2, q2b2, x);
  outstring (1, "  q ( "); outreal (1, x);
  outstring (1, ") = "); outreal (1, y);
  outstring (1, "\n");
  x := 7.50;
  y := evalbern2 (q0b2, q1b2, q2b2, x);
  outstring (1, "  q ( "); outreal (1, x);
  outstring (1, ") = "); outreal (1, y);
  outstring (1, "\n");

  tobern3 (p0m, p1m, p2m, 0, p0b3, p1b3, p2b3, p3b3);
  tobern3 (q0m, q1m, q2m, 0, q0b3, q1b3, q2b3, q3b3);
  tobern3 (r0m, r1m, r2m, r3m, r0b3, r1b3, r2b3, r3b3);
  outstring (1, "Subprogram (3) examples:\n");
  outstring (1, "  mono ( ");
  outreal (1, p0m); outstring (1, ", ");
  outreal (1, p1m); outstring (1, ", ");
  outreal (1, p2m); outstring (1, ", ");
  outreal (1, 0); outstring (1, ") --> bern ( ");
  outreal (1, p0b3); outstring (1, ", ");
  outreal (1, p1b3); outstring (1, ", ");
  outreal (1, p2b3); outstring (1, ", ");
  outreal (1, p3b3); outstring (1, ")\n");
  outstring (1, "  mono ( ");
  outreal (1, q0m); outstring (1, ", ");
  outreal (1, q1m); outstring (1, ", ");
  outreal (1, q2m); outstring (1, ", ");
  outreal (1, 0); outstring (1, ") --> bern ( ");
  outreal (1, q0b3); outstring (1, ", ");
  outreal (1, q1b3); outstring (1, ", ");
  outreal (1, q2b3); outstring (1, ", ");
  outreal (1, q3b3); outstring (1, ")\n");
  outstring (1, "  mono ( ");
  outreal (1, r0m); outstring (1, ", ");
  outreal (1, r1m); outstring (1, ", ");
  outreal (1, r2m); outstring (1, ", ");
  outreal (1, r3m); outstring (1, ") --> bern ( ");
  outreal (1, r0b3); outstring (1, ", ");
  outreal (1, r1b3); outstring (1, ", ");
  outreal (1, r2b3); outstring (1, ", ");
  outreal (1, r3b3); outstring (1, ")\n");

  outstring (1, "Subprogram (4) examples:\n");
  x := 0.25;
  y := evalbern3 (p0b3, p1b3, p2b3, p3b3, x);
  outstring (1, "  p ( "); outreal (1, x);
  outstring (1, ") = "); outreal (1, y);
  outstring (1, "\n");
  x := 7.50;
  y := evalbern3 (p0b3, p1b3, p2b3, p3b3, x);
  outstring (1, "  p ( "); outreal (1, x);
  outstring (1, ") = "); outreal (1, y);
  outstring (1, "\n");
  x := 0.25;
  y := evalbern3 (q0b3, q1b3, q2b3, q3b3, x);
  outstring (1, "  q ( "); outreal (1, x);
  outstring (1, ") = "); outreal (1, y);
  outstring (1, "\n");
  x := 7.50;
  y := evalbern3 (q0b3, q1b3, q2b3, q3b3, x);
  outstring (1, "  q ( "); outreal (1, x);
  outstring (1, ") = "); outreal (1, y);
  outstring (1, "\n");
  x := 0.25;
  y := evalbern3 (r0b3, r1b3, r2b3, r3b3, x);
  outstring (1, "  r ( "); outreal (1, x);
  outstring (1, ") = "); outreal (1, y);
  outstring (1, "\n");
  x := 7.50;
  y := evalbern3 (r0b3, r1b3, r2b3, r3b3, x);
  outstring (1, "  r ( "); outreal (1, x);
  outstring (1, ") = "); outreal (1, y);
  outstring (1, "\n");

  bern2to3 (p0b2, p1b2, p2b2, pc0, pc1, pc2, pc3);
  bern2to3 (q0b2, q1b2, q2b2, qc0, qc1, qc2, qc3);
  outstring (1, "Subprogram (5) examples:\n");
  outstring (1, "  bern ( ");
  outreal (1, p0b2); outstring (1, ", ");
  outreal (1, p1b2); outstring (1, ", ");
  outreal (1, p2b2); outstring (1, ") --> bern ( ");
  outreal (1, pc0); outstring (1, ", ");
  outreal (1, pc1); outstring (1, ", ");
  outreal (1, pc2); outstring (1, ", ");
  outreal (1, pc3); outstring (1, ")\n");
  outstring (1, "  bern ( ");
  outreal (1, q0b2); outstring (1, ", ");
  outreal (1, q1b2); outstring (1, ", ");
  outreal (1, q2b2); outstring (1, ") --> bern ( ");
  outreal (1, qc0); outstring (1, ", ");
  outreal (1, qc1); outstring (1, ", ");
  outreal (1, qc2); outstring (1, ", ");
  outreal (1, qc3); outstring (1, ")\n")
end
