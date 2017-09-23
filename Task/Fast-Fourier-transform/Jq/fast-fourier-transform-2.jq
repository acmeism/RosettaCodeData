def fft:
  length as $N
  | if $N <= 1 then .
    else   ( [ .[ range(0; $N; 2) ] ] | fft) as $even
         | ( [ .[ range(1; $N; 2) ] ] | fft) as $odd
         | (1|atan * 4) as $pi
         | [ range(0; $N/2) | cplus($even[.];  cmult( expi(-2*$pi*./$N); $odd[.] )) ] +
           [ range(0; $N/2) | cminus($even[.]; cmult( expi(-2*$pi*./$N); $odd[.] )) ]
    end;
