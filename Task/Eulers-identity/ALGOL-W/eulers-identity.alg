begin
    % calculate an approximation to e^(i pi) + 1 which should be 0 (Euler's identity) %

    % returns e^ix for long  real  x, using the series:                               %
    %      exp(ix) = 1 - x^2/2! + x^4/4! - ... + i(x - x^3/3! + x^5/5! - x^7/7! ... ) %
    %      the expansion stops when successive terms differ by less than 1e-15        %
    long complex procedure expi ( long real value x ) ;
         begin
            long real    t, realPart, imaginaryPart, divisor, diff;
            integer      n;
            logical      evenPower, subtract;
            t             := 1;
            realPart      := 1;
            imaginaryPart := 0;
            divisor       := 1;
            evenPower     := false;
            subtract      := false;
            diff          := 1;
            n             := 0;
            while abs diff > 1'-15 do begin
                long real term;
                n       := n + 1;
                divisor := divisor * n;
                t       := t * x;
                term    := t / divisor;
                if evenPower then begin                           % this term is real %
                    long real prev;
                    subtract := not subtract;
                    prev     := realPart;
                    if subtract then realPart  := realPart - term
                                else realPart  := realPart + term;
                    diff     := prev - realPart
                    end
                else begin                                   % this term is imaginary %
                    long  real  prev;
                    prev := imaginaryPart ;
                    if subtract then imaginaryPart := imaginaryPart - term
                                else imaginaryPart := imaginaryPart + term;
                    diff := prev - imaginaryPart
                end if_evenPower__ ;
                evenPower := not evenPower
            end while_abs_diff_gt_tolerance ;
            realPart + 1i * imaginaryPart
         end expi ;

    write( s_w := 0, r_format := "A", r_w := 23, r_d := 20
         , "e^(i*pi) + 1 ~ ", expi( pi ) + 1
         )

end.
