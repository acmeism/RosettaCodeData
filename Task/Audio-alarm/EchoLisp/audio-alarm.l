(lib 'timer)
(lib 'audio)

(define (AudioAlarm)
	(display "Time to wake-up" "color:red")
	(audio-show) ;; show audio control
	(audio-play) ;; play it
	)
	
(define (task)
  (define audio-file
    (read-string "ring0" "audio-file name? ring0/ring1/ring2/dalida"))
  (define seconds (read-number 3600 "countdown (seconds) ?"))
  (audio-src (string-append "./sounds/" audio-file))
  (at seconds 'seconds AudioAlarm))

;; out
(task)

11/2/2016 23:43:42 : AudioAlarm
Time to wake-up ;; + ... 🎼 🎶🎵🎶🎵

