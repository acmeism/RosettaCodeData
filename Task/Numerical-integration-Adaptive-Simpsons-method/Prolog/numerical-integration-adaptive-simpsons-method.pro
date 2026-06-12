%%% -*- mode: prolog; prolog-indent-width: 2; -*-

main :-
  quad_asr(sine, 0.0, 1.0, 0.000000001, 1000, QuadVal),
  write('estimate of ∫ sin x dx from 0 to 1: '),
  write(QuadVal),
  write('\n'),
  halt.

sine(X, Y) :- Y is sin(X).

quad_asr(F, A, B, Tol, Depth, QuadVal) :-
  call(F, A, FA),
  call(F, B, FB),
  simpson_rule(F, A, FA, B, FB, M, FM, Whole),
  recursive_simpson(F, A, FA, B, FB, Tol, Whole, M, FM, Depth,
                    QuadVal).

recursive_simpson(F, A, FA, B, FB, Tol, Whole, M, FM, Depth,
                  QuadVal) :-
  simpson_rule(F, A, FA, M, FM, LM, FLM, Left),
  simpson_rule(F, M, FM, B, FB, RM, FRM, Right),
  Delta is (Left + Right - Whole),
  Tol_ is (0.5 * Tol),
  ((Depth > 0,
    Tol_ =\= Tol,
    AbsDelta is abs(Delta),
    Tol15 is (15.0 * Tol),
    AbsDelta > Tol15)
  -> (Depth_ is Depth - 1,
      recursive_simpson(F, A, FA, M, FM, Tol_, Left, LM, FLM,
                        Depth_, QuadValLeft),
      recursive_simpson(F, M, FM, B, FB, Tol_, Right, RM, FRM,
                        Depth_, QuadValRight),
      QuadVal is QuadValLeft + QuadValRight)
  ;  left_right_estimate(Left, Right, Delta, QuadVal)).

left_right_estimate(Left, Right, Delta, Estimate) :-
  Estimate is Left + Right + (Delta / 15.0).

simpson_rule(F, A, FA, B, FB, M, FM, QuadVal) :-
  M is (0.5 * (A + B)),
  call(F, M, FM),
  QuadVal is ((B - A) / 6.0) * (FA + (4.0 * FM) + FB).

:- initialization(main).
