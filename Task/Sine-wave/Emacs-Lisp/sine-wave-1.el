(defun play-sine (freq dur)
  "Play a sine wave for dur seconds."
  (setq header (unibyte-string     ; AU header:
                  46 115 110 100   ;   ".snd" magic number
                  0 0 0 24         ;   start of data bytes
                  255 255 255 255  ;   file size is unknown
                  0 0 0 3          ;   16 bit PCM samples
                  0 0 172 68       ;   44,100 samples/s
                  0 0 0 1))        ;   mono
  (setq s (apply #'concat header (mapcar (lambda (x) (unibyte-string
               (mod (round (* 127 (sin (* 2 pi freq x (/ 44100.0))))) 256) 0))
               (number-sequence 0 (* dur 44100)))))
  (play-sound `(sound :data ,s)))

(play-sine 440 5)
