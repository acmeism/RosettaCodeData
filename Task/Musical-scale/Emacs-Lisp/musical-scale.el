(defun play-scale (freq-list dur)
  "Play a list of frequencies."
  (setq header (unibyte-string     ; AU header:
                  46 115 110 100   ;   ".snd" magic number
                  0 0 0 24         ;   start of data bytes
                  255 255 255 255  ;   file size is unknown
                  0 0 0 3          ;   16 bit PCM samples
                  0 0 172 68       ;   44,100 samples/s
                  0 0 0 1))        ;   mono
  (setq s nil)
  (dolist (freq freq-list)
    (setq v (mapcar (lambda (x)
                 (mod (round (* 32000 (sin (* 2 pi freq x (/ 44100.0))))) 65536))
                 (number-sequence 0 (* dur 44100))))
    (setq s (apply #'concat s (flatten-list (mapcar (lambda (x)
              (list (unibyte-string (ash x -8))
                    (unibyte-string (mod x 256))))
              v)))))
  (setq s (concat header s))
  (play-sound `(sound :data ,s)))

(play-scale '(261.63 293.66 329.63 349.23 392.00 440.00 493.88 523.25) .5)
