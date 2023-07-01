(let ((a "2988348162058574136915891421498819466320163312926952423791023078876139")
      (b "2351399303373464486466122544523690094744975233415544072992656881240319"))
  ;; "$ ^ $$ mod (10 ^ 40)" performs modular exponentiation.
  ;; "unpack(-5, x)_1" unpacks the integer from the modulo form.
  (message "%s" (calc-eval "unpack(-5, $ ^ $$ mod (10 ^ 40))_1" nil a b)))
