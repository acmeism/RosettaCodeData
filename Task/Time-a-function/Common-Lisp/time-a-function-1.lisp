CL-USER> (time (reduce #'+ (make-list 100000 :initial-element 1)))
Evaluation took:
  0.151 seconds of real time
  0.019035 seconds of user run time
  0.01807 seconds of system run time
  0 calls to %EVAL
  0 page faults and
  2,400,256 bytes consed.
