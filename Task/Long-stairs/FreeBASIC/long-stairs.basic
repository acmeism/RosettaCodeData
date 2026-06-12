randomize timer
dim as uinteger steps_behind = 0, stairs_length = 100, seconds, j
dim as uinteger seconds_tot, steps_tot
print "Seconds", "steps behind", "steps ahead"
for trial as uinteger = 1 to 10000        'We'll have the runner try this 10000 times
    steps_behind = 0                      'runner starts at the bottom
    seconds = 0                           'reset time taken
    stairs_length = 100                   'Staircase has 100 steps
    while steps_behind < stairs_length    'if the runner hasn't reached the top
        steps_behind += 1                 'go up one step
        for j = 1 to 5                    'The evil wizard conjures another five steps
            if int(rnd*stairs_length) < steps_behind then steps_behind += 1
                                          'there's a chance that a new step will be behind you
            stairs_length += 1            'but either way the staircase is one step longer
        next j
        seconds += 1                      'that all took one second
        if trial = 1  and seconds >599 and seconds < 610  then print seconds, steps_behind, stairs_length - steps_behind
                                          'for the first attempt, see how the runner is doing after ten minutes
    wend
    seconds_tot += seconds                'if the runner escaped, track the time taken and the length of the stairs
    steps_tot += stairs_length
next trial

print "Average time taken: ";seconds_tot/10000; " seconds."
print "Average final staircase length: ";steps_tot/10000; " steps."
'if you noticed that last number is about 100*exp(5), that's no coincidence
