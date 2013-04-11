(defun rosetta-mod-expt (base power divisor)
  "Return BASE raised to the POWER, modulo DIVISOR.
  This function is faster than (MOD (EXPT BASE POWER) DIVISOR), but
  only works when POWER is a non-negative integer."
  (setq base (mod base divisor))
  ;; Multiply product with base until power is zero.
  (do ((product 1))
      ((zerop power) product)
    ;; Square base, and divide power by 2, until power becomes odd.
    (do () ((oddp power))
      (setq base (mod (* base base) divisor)
	    power (ash power -1)))
    (setq product (mod (* product base) divisor)
	  power (1- power))))

(let ((a 2988348162058574136915891421498819466320163312926952423791023078876139)
      (b 2351399303373464486466122544523690094744975233415544072992656881240319))
  (format t "~A~%" (rosetta-mod-expt a b (expt 10 40))))
