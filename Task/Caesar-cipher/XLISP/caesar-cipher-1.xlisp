(defun caesar-encode (text key)
    (defun encode (ascii-code)
        (defun rotate (character alphabet)
            (define code (+ character key))
            (cond
                ((> code (+ alphabet 25)) (- code 26))
                ((< code alphabet) (+ code 26))
                (t code)))
        (cond
            ((and (>= ascii-code 65) (<= ascii-code 90)) (rotate ascii-code 65))
            ((and (>= ascii-code 97) (<= ascii-code 122)) (rotate ascii-code 97))
            (t ascii-code)))
        (list->string (mapcar integer->char (mapcar encode (mapcar char->integer (string->list text))))))

(defun caesar-decode (text key)
    (caesar-encode text (- 26 key)))
