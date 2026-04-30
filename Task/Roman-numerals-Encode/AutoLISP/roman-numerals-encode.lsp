(defun c:roman() (romanNumber (getint "\n Enter number > "))
(defun romanNumber (n / uni dec hun tho nstr strlist nlist rom)
  (if (and (> n 0) (<= n 3999))
    (progn
       (setq
         UNI (list "" "I" "II" "III" "IV" "V" "VI" "VII" "VIII" "IX")
         DEC (list "" "X" "XX" "XXX" "XL" "L" "LX" "LXX" "LXXX" "XC")
         HUN (list "" "C" "CC" "CCC" "CD" "D" "DC" "DCC" "DCCC" "CM")
         THO (list "" "M" "MM" "MMM")
         nstr (itoa n)
       )
       (while (> (strlen nstr) 0) (setq strlist (append strlist (list (substr nstr 1 1))) nstr (substr nstr 2 (strlen nstr))))
       (setq nlist (mapcar 'atoi strlist))
       (cond
          ((> n 999)(setq rom(strcat(nth (car nlist) THO)(nth (cadr nlist) HUN)(nth (caddr nlist) DEC) (nth (last nlist)UNI ))))
          ((and (> n 99)(<= n 999))(setq rom(strcat (nth (car nlist) HUN)(nth (cadr nlist) DEC) (nth (last nlist)UNI ))))
          ((and (> n 9)(<= n 99))(setq rom(strcat (nth (car nlist) DEC) (nth (last nlist)UNI ))))
          ((<= n 9)(setq rom(nth (last nlist)UNI)))
          )
        )
        (princ "\nNumber out of range!")
    )
rom
)
