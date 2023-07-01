#lang racket

(require racket/date)

; Any CE Year that was the first of a 60-year cycle
(define base-year 1984)

(define celestial-stems '("甲" "乙" "丙" "丁" "戊" "己" "庚" "辛" "壬" "癸"))

(define terrestrial-branches '("子" "丑" "寅" "卯" "辰" "巳" "午" "未" "申" "酉" "戌" "亥"))

(define zodiac-animals
  '("Rat" "Ox" "Tiger" "Rabbit" "Dragon" "Snake" "Horse" "Goat" "Monkey" "Rooster" "Dog" "Pig"))

(define elements '("Wood" "Fire" "Earth" "Metal" "Water"))

(define aspects '("yang" "yin"))

(define pinyin
  (map cons
       (append celestial-stems terrestrial-branches)
       (list "jiă" "yĭ" "bĭng" "dīng" "wù" "jĭ" "gēng" "xīn" "rén" "gŭi"
             "zĭ" "chŏu" "yín" "măo" "chén" "sì" "wŭ" "wèi" "shēn" "yŏu" "xū" "hài")))

(define (this-year) (date-year (current-date)))

(define (pinyin-for han) (cdr (assoc han pinyin)))

(define (han/pinyin-nth n hans) (let ((han (list-ref hans n))) (values han (pinyin-for han))))

(define (chinese-zodiac ce-year)
  (let* ((cycle-year (- ce-year base-year))
         (stem-number    (modulo cycle-year (length celestial-stems)))
         (element-number (quotient stem-number 2))
         (aspect-number  (modulo cycle-year (length aspects)))
         (branch-number  (modulo cycle-year (length terrestrial-branches)))
         (element        (list-ref elements element-number))
         (zodiac-animal  (list-ref zodiac-animals branch-number))
         (aspect         (list-ref aspects aspect-number)))
    (let-values (([stem-han stem-pinyin]     (han/pinyin-nth stem-number celestial-stems))
                 ([branch-han branch-pinyin] (han/pinyin-nth branch-number terrestrial-branches)))
      (list ce-year stem-han branch-han stem-pinyin branch-pinyin element zodiac-animal aspect))))

(module+ test
  (for ((ce-year (in-list '(1935 1938 1941 1947 1968 1972 1976))))
  (apply printf "~a: ~a~a (~a-~a, ~a ~a; ~a)~%" (chinese-zodiac ce-year))))
