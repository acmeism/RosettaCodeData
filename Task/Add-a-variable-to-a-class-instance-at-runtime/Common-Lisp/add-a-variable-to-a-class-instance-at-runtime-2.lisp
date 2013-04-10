CL-USER> (let* ((instance (make-instance 'foo :bar 42 :baz 69))
                (new-slots '((:name xenu :initargs (:xenu)))))
           (augment-instance-with-slots instance new-slots)
           (reinitialize-instance instance :xenu 666)
           (describe instance))
#<#<STANDARD-CLASS NIL {1003AEE2C1}> {1003AEE271}>
  [standard-object]

Slots with :INSTANCE allocation:
  BAR   = 42
  BAZ   = 69
  XENU  = 666
