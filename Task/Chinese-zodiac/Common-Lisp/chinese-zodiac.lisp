; Any CE Year that was the first of a 60-year cycle
(defconstant base-year 1984)

(defconstant celestial-stems
  '("甲" "乙" "丙" "丁" "戊" "己" "庚" "辛" "壬" "癸"))

(defconstant terrestrial-branches
  '("子" "丑" "寅" "卯" "辰" "巳" "午" "未" "申" "酉" "戌" "亥"))

(defconstant zodiac-animals
  '("Rat"   "Ox"   "Tiger"  "Rabbit"  "Dragon" "Snake"
    "Horse" "Goat" "Monkey" "Rooster" "Dog"    "Pig"))

(defconstant elements '("Wood" "Fire" "Earth" "Metal" "Water"))

(defconstant aspects '("yang" "yin"))

(defconstant pinyin
  (pairlis (append celestial-stems terrestrial-branches)
    '("jiă" "yĭ" "bĭng" "dīng" "wù" "jĭ" "gēng" "xīn" "rén" "gŭi"
      "zĭ" "chŏu" "yín" "măo" "chén" "sì" "wŭ" "wèi" "shēn" "yŏu" "xū" "hài")))

(defun this-year () (nth 5 (multiple-value-list (get-decoded-time))))

(defun pinyin-for (han) (cdr (assoc han pinyin :test #'string=)))

(defun chinese-zodiac (&rest years)
 (loop for ce-year in (if (null years) (list (this-year)) years) collecting
   (let* ((cycle-year (- ce-year base-year))
          (stem-number (mod cycle-year 10))
          (stem-han    (nth stem-number celestial-stems))
          (stem-pinyin (pinyin-for stem-han))

          (element-number (floor stem-number 2))
          (element        (nth element-number elements))

          (branch-number (mod cycle-year 12))
          (branch-han    (nth branch-number terrestrial-branches))
          (branch-pinyin (pinyin-for branch-han))
          (zodiac-animal (nth branch-number zodiac-animals))

          (aspect-number (mod cycle-year 2))
          (aspect        (nth aspect-number aspects)))
          (cons ce-year (list stem-han branch-han stem-pinyin branch-pinyin element zodiac-animal aspect)))))

(defun get-args ()
  (or
   #+CLISP *args*
   #+SBCL (cdr *posix-argv*)
   #+LISPWORKS system:*line-arguments-list*
   #+CMU extensions:*command-line-words*
   nil))

(loop for cz in (apply #'chinese-zodiac (mapcar #'read-from-string (get-args)))
 doing
  (format t "~{~a: ~a~a (~a-~a, ~a ~a; ~a)~%~}" cz))
