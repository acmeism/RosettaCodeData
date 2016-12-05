> (set funcs (list-comp ((<- m (lists:seq 1 10)))
                      (lambda () (math:pow m 2))))
