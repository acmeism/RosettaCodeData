(de metronome (Bpm)
   (if (fork)
      (let Pid @
         (for Pendulum '(" /" . ("^H^H\\ " "^H^H /" .))
            (tell Pid 'call "/usr/bin/beep" "-f" 440 "-l" 40)
            (prin Pendulum)
            (T (key (*/ 30000 Bpm)) (tell Pid 'bye)) )
         (prinl) )
      (wait) ) )
