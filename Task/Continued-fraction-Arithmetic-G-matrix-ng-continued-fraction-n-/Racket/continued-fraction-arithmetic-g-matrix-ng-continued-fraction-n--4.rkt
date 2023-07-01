(display "[1;5,2] + 1/2 ->")
(cf-showln (combine-ng-cf->cf (ng 2 1 0 2) (rational->cf 13 11)) 20)

(display "[3;7] + 1/2 ->")
(cf-showln (combine-ng-cf->cf (ng 2 1 0 2) (rational->cf 22 7)) 20)

(display "[3;7] / 4 ->")
(cf-showln (combine-ng-cf->cf (ng 1 0 0 4) (rational->cf 22 7)) 20)

(display "sqrt(2)/2 ->")
(cf-showln (combine-ng-cf->cf (ng 1 0 0 2) (sqrt2->cf)) 20)

(display "1/sqrt(2) ->")
(cf-showln (combine-ng-cf->cf (ng 0 1 1 0) (sqrt2->cf)) 20)

(display "(1+sqrt(2))/2 ->")
(cf-showln (combine-ng-cf->cf (ng 1 1 0 2) (sqrt2->cf)) 20)
