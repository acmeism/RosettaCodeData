; version 1 (11 Frimaire 234)
; inspired by BBC Basic
; see https://rosettacode.org/wiki/French_Republican_calendar

(import (scheme base) (scheme char))

; ex: (date->jour-mois-annee '(2025 12 1)) -> 1 12 2025
(define (date->jour-mois-annee date)
  (values (list-ref date 2) (list-ref date 1) (list-ref date 0)))

; ex: (jours-bissextiles 1900) -> 460
(define (jours-bissextiles annee)
  (- (+ (quotient annee 4) (quotient annee 400)) (quotient annee 100)))

; ex: (bissextile? 1900) -> #f
(define (bissextile? annee)
  (and (zero? (remainder annee 4))
       (or (zero? (remainder annee 400)) (positive? (remainder annee 100)))))

; ex: (jour-bissextile 1900) -> 0
(define (jour-bissextile annee)
  (if (bissextile? annee) 1 0))

; ex: (gregorien->jours '(1792 9 22)) -> 1
; ex: (gregorien->jours '(2025 12 1)) -> 85172
(define (gregorien->jours date)
  (let*-values (((jour mois annee)  (date->jour-mois-annee date))
                ((mois annee)       (if (< mois 3)
                                      (values (+ mois 12) (- annee 1))
                                      (values mois annee))))
    (- (+ (* annee 365)
          (jours-bissextiles annee)
          (exact (floor (* 30.6 (+ mois 1))))
          jour)
       654842)))

; ex: (republicain->jours '(1 1 1)) -> 1
; ex: (republicain->jours '(2025 12 1)) -> 85172
(define (republicain->jours date)
  (let*-values (((jour mois annee)  (date->jour-mois-annee date))
                ((mois jour)        (if (= mois 13)
                                      (values 12 (+ jour 30))
                                      (values mois jour))))
    (- (+ (* annee 365)
          (* 30 mois)
          (jours-bissextiles (+ annee 1))
          jour)
       (jour-bissextile (+ annee 1))
       395)))

; ex: (jours->gregorien 1) -> (1792 9 22)
; ex: (jours->gregorien 85172) -> (2025 12 1)
(define (jours->gregorien jours)
  (let* ((annee  (exact (floor (/ jours 365.25))))
         (jour   (+ (- jours (exact (floor (* annee 365.25)))) 21))
         (annee  (+ annee 1792))
         (jour   (- (+ jour (exact (quotient annee 100))) (exact (quotient annee 400)) 13)))
    (let boucle ((jour jour)(mois 8)(annee annee))
      (let* ((duree-mois (vector-ref #(31 28 31 30 31 30 31 31 30 31 30 31) mois))
             (duree-mois (+ duree-mois (if (and (= mois 1) (bissextile? annee)) 1 0))))
        (if (<= jour duree-mois)
          (list annee (+ mois 1) jour)
          (let ((jour (- jour duree-mois))
                (mois (+ mois 1)))
            (if (= mois 12)
              (boucle jour 0 (+ annee 1))
              (boucle jour mois annee))))))))

; ex: (jours->republicain 1) -> (1 1 1)
; ex: (jours->republicain 85172) -> (234 3 11)
(define (jours->republicain jours)
  (let* ((annee  (exact (floor (/ jours 365.25))))
         (annee  (- annee (jour-bissextile (+ annee 1))))
         (jour   (- jours (exact (floor (* annee 365.25)))))
         (annee  (+ annee 1))
         (jour   (- (+ jour (exact (quotient annee 100))) (exact (quotient annee 400)))))
    (let boucle ((jour jour)(mois 1)(annee annee))
      (let ((duree-mois (if (< mois 13) 30 (+ 5 (jour-bissextile (+ annee 1))))))
        (if (<= jour duree-mois)
          (list annee mois jour)
          (let ((jour (- jour duree-mois))
                (mois (+ mois 1)))
            (if (= mois 14)
              (boucle jour 1 (+ annee 1))
              (boucle jour mois annee))))))))

; ex: (normalise-caractere #\E) -> #\e
; ex: (normalise-caractere #\ê) -> #\e
(define (normalise-caractere caractere)
  (let* ((caractere (char-downcase caractere))
         (autre     (assoc caractere '((#\é . #\e) (#\ê . #\e) (#\ô . #\o)))))
    (if autre
      (cdr autre)
      caractere)))

; ex: (normalise-texte "Ventôse") -> "ventose"
(define (normalise-texte texte)
  (string-map normalise-caractere texte))

; ex: (normalise-texte '("Ventôse" "Germinal")) -> ("ventose" "germinal")
(define (normalise-liste liste)
  (map normalise-texte liste))

(define mois-republicains '(
        "Vendémiaire" "Brumaire" "Frimaire" "Nivôse"   "Pluviôse"  "Ventôse"
        "Germinal"    "Floréal"  "Prairial" "Messidor" "Thermidor" "Fructidor"
        "Sansculottide"))

(define sansculottides '(
        "Fête de la vertu"  "Fête du génie"        "Fête du travail"
        "Fête de l'opinion" "Fête des récompenses" "Fête de la Révolution" ))

(define mois-gregoriens '(
        "January"   "February" "March"     "April"   "May"      "June"
        "July"      "August"   "September" "October" "November" "December" ))

(define mois-republicains-normal (normalise-liste mois-republicains))

(define sansculottides-normal (normalise-liste sansculottides))

(define mois-gregoriens-normal (normalise-liste mois-gregoriens))

; ex: (gregorien->texte '(2025 12 1)) -> "1 December 2025)"
(define (gregorien->texte date)
  (string-append
    (number->string (list-ref date 2))
    " "
    (list-ref mois-gregoriens (- (list-ref date 1) 1))
    " "
    (number->string (list-ref date 0))))

; ex: (republicain->texte '(2025 12 1)) -> "1 Fructidor 2025)"
; ex: (republicain->texte '(2025 13 1)) -> "Fête de la vertu 2025)"
(define (republicain->texte date)
  (if (= (list-ref date 1) 13)
    (string-append
      (list-ref sansculottides (- (list-ref date 2) 1))
      " "
      (number->string (list-ref date 0)))
    (string-append
      (number->string (list-ref date 2))
      " "
      (list-ref mois-republicains (- (list-ref date 1) 1))
      " "
      (number->string (list-ref date 0)))))

; ex: (decompose "34 toto 78 zorro louarn 9") -> (9 "zorro louarn" 78 "toto" 34)
; ex: (decompose "10 Vendémiaire 1") -> (1 "Vendémiaire" 10)
(define (decompose texte)
  (let ((texte (normalise-texte texte)))
    (let boucle ((index 0)(resultat '()))
      (if (>= index (string-length texte))
        resultat
        (let ((caractere (string-ref texte index))
              (index     (+ index 1)))
          (cond
            ((char-whitespace? caractere)
              (boucle index resultat))
            ((char-numeric? caractere)
              (let lit-nombre ((index index)(valeur (digit-value caractere)))
                (let ((caractere (if (>= index (string-length texte))
                                   #\space
                                  (string-ref texte index))))
                  (if (char-numeric? caractere)
                    (lit-nombre (+ index 1) (+ (* 10 valeur) (digit-value caractere)))
                    (boucle index (cons valeur resultat))))))
            (else
              (let lit-texte ((index index)(valeur (list caractere)))
                (let ((caractere (if (>= index (string-length texte))
                                   #\0
                                  (string-ref texte index))))
                  (if (char-numeric? caractere)
                    (let retire-espace ((valeur valeur))
                      (if (char-whitespace? (car valeur))
                        (retire-espace (cdr valeur))
                        (boucle index (cons (list->string (reverse valeur)) resultat))))
                    (lit-texte (+ index 1) (cons caractere valeur))))))))))))

; ex: (index-texte '("a" "b" "c") "b") -> 2
; ex: (index-texte '("a" "b" "c") "x") -> #f
(define (index-texte liste texte)
  (let ((tete (member texte liste)))
    (and tete (+ 1 (- (length liste) (length tete))))))

; ex: (decode-date "22 September 1792") -> (gregorien 1792 9 22)
; ex: (decode-date "Fête de la Révolution 11") -> (republicain 11 13 6)
(define (decode-date texte)
  (let ((decomposition (decompose texte)))
    (case (length decomposition)
      ((2)
        (let* ((annee (list-ref decomposition 0))
               (fete  (list-ref decomposition 1))
               (jour  (index-texte sansculottides-normal fete)))
          (and jour (number? annee) (list 'republicain annee 13 jour))))
      ((3)
        (let* ((annee (list-ref decomposition 0))
               (mois  (list-ref decomposition 1))
               (jour  (list-ref decomposition 2))
               (mois-gregorien (index-texte mois-gregoriens-normal mois))
               (mois-republicain (index-texte mois-republicains-normal mois)))
          (and (number? annee) (number? jour)
               (or (and mois-gregorien (list 'gregorien annee mois-gregorien jour))
                   (and mois-republicain (list 'republicain annee mois-republicain jour))))))
      (else
        #f))))

; ex: (decode-date "22 September 1792") -> "1 Vendémiaire 1"
; ex: (decode-date "Fête de la Révolution 11") -> "23 September 1803"
(define (converti-date texte)
  (let ((decodage (decode-date texte)))
    (and decodage
         (case (car decodage)
           ((gregorien)
             (republicain->texte (jours->republicain (gregorien->jours (cdr decodage)))))
           ((republicain)
             (gregorien->texte (jours->gregorien (republicain->jours (cdr decodage)))))
           (else
             #f)))))

; validation
(for-each
  (lambda (texte)
    (display texte)
    (display " = ")
    (display (converti-date texte))
    (newline))
  '(
    "1 Vendémiaire 1"  "22 September 1792"
    "1 Prairial 3"     "20 May 1795"
    "27 Messidor 7"    "15 July 1799"
    "Fête de la Révolution 11"  "23 September 1803"
    "10 Nivôse 14"     "31 December 1805"
    "11 Frimaire 234"  "1 December 2025"
  ))
