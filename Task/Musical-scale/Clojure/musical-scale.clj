(use 'overtone.live)

; Define your desired instrument
; Using saw-wave from: https://github.com/overtone/overtone/wiki/Chords-and-scales
(definst saw-wave [freq 440 attack 0.01 sustain 0.4 release 0.1 vol 0.4]
  (* (env-gen (env-lin attack sustain release) 1 1 0 1 FREE)
     (saw freq)
     vol))

(defn play [note ms]
  (saw-wave (midi->hz note))
  (Thread/sleep ms))

(doseq [note (scale :c4 :major)] (play note 500))
