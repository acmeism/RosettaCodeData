(load "@lib/math.l")

(de pendulum (X Y Len)
   (let (Angle pi/2  V 0)
      (call 'clear)
      (call 'tput "cup" Y X)
      (prin '+)
      (call 'tput "cup" 1 (+ X Len))
      (until (key 25)                        # 25 ms
         (let A (*/ (sin Angle) -9.81 1.0)
            (inc 'V (*/ A 40))               # DT = 25 ms = 1/40 sec
            (inc 'Angle (*/ V 40)) )
         (call 'tput "cup"
            (+ Y (*/ Len (cos Angle) 2.2))   # Compensate for aspect ratio
            (+ X (*/ Len (sin Angle) 1.0)) ) ) ) )
