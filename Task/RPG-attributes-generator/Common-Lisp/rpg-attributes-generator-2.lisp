;; 22.11.07  Draft

(defun score-jet-des ()
  (loop :for resultat = (+ (random 6) 1)
        :repeat 4
        :sum resultat :into total
        :minimize resultat :into minimum
        :finally (return (- total minimum))))

(defun calcule-attributs-personnage ()
  (loop named a
        :do (loop :for score = (score-jet-des)
                  :repeat 6
                  :collect score :into scores
                  :sum score :into total
                  :count (>= score 15) :into frequence
                  :finally (when (and (>= total 75) (>= frequence 2))
                             (return-from a (values scores total))))))
