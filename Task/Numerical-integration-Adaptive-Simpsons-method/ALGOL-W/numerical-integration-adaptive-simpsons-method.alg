begin % Numerical integration using an Adaptive Simpson's method %

    real procedure quad_asr ( real procedure f; real value a, b, eps ) ;
    begin
        record triple ( real mOf, fmOf, simpOf );

        % "structured" adaptive version, translated from Racket %
        reference(triple) procedure quad_simpsons_mem ( real procedure f
                                                      ; real value a, fa, b, fb
                                                      ) ;
        begin % Evaluates Simpson's Rule, also returning m and f(m) to reuse. %
            real m, fm, simp;
            m    := ( a + b ) / 2;
            fm   := f( m );
            simp := abs ( b - a ) / 6 * ( fa + 4*fm + fb );
            triple( m, fm, simp )
        end quad_simpsons_mem ;

        real procedure quad_asr_rec ( real procedure f
                                    ; real value a, fa, b, fb, eps, whole, m, fm
                                    ) ;
        begin
            % Efficient recursive implementation of adaptive Simpson's rule. %
            % Function values at the start, middle, end of the intervals are retained. %
            reference(triple) lt, rt;
            real              delta;
            lt    := quad_simpsons_mem( f, a, fa, m, fm );
            rt    := quad_simpsons_mem( f, m, fm, b, fb );
            delta := simpOf(lt) + simpOf(rt) - whole;
            if abs delta <= eps * 15
            then simpOf(lt) + simpOf(rt) + delta / 15
            else quad_asr_rec( f, a, fa, m, fm, eps / 2, simpOf(lt), mOf(lt), fmOf(lt) )
               + quad_asr_rec( f, m, fm, b, fb, eps / 2, simpOf(rt), mOf(rt), fmOf(rt) )
        end quad_asr ;

        real              fa, fb;
        reference(triple) t;

        % Integrate f from a to b using ASR with max error of eps. %
        fa := f( a );
        fb := f( b );
        t  := quad_simpsons_mem( f, a, fa, b, fb );
        quad_asr_rec( f, a, fa, b, fb, eps, simpOf(t), mOf(t), fmOf(t) )
    end quad_asr ;

    real a, b, sinx;
    a := 0.0; b := 1.0;
    sinx := quad_asr( sin, a, b, 1'-09 );
    write( s_w := 0, r_format := "A", r_w := 6, r_d := 3
         , "Simpson's integration of sine from ", a, " to ", b, " = "
         , r_w := 12, r_d := 8
         , sinx
         )
end.
