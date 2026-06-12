(defun play-sine16 (freq dur)
  "Play a sine wave for dur seconds."
  (setq header (unibyte-string     ; AU header:
                  46 115 110 100   ;   ".snd" magic number
                  0 0 0 24         ;   start of data bytes
                  255 255 255 255  ;   file size is unknown
                  0 0 0 3          ;   16 bit PCM samples
                  0 0 172 68       ;   44,100 samples/s
                  0 0 0 1))        ;   mono
  (setq v (mapcar (lambda (x)
               (mod (round (* 32000 (sin (* 2 pi freq x (/ 44100.0))))) 65536))
               (number-sequence 0 (* dur 44100))))
  (setq s (apply #'concat header (flatten-list (mapcar (lambda (x)
            (list (unibyte-string (ash x -8))
                  (unibyte-string (mod x 256))))
            v))))
  (play-sound `(sound :data ,s)))

(play-sine16 440 5)
