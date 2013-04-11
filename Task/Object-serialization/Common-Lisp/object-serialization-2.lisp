CL-USER> (list (make-instance 'entity)
               (make-instance 'person))

(#<ENTITY {1004B13141}> #<PERSON {1004B142B1}>)
CL-USER> (mapc #'describe *)
#<ENTITY {1004B13141}>
  [standard-object]

Slots with :INSTANCE allocation:
  NAME  = "Some entity"
#<PERSON {1004B142B1}>
  [standard-object]

Slots with :INSTANCE allocation:
  NAME  = "The Nameless One"
(#<ENTITY {1004B13141}> #<PERSON {1004B142B1}>)
CL-USER> (with-serialization-to-file (stream "/tmp/objects.dat")
           (cl-serializer:serialize * :output stream)
           ;; SERIALIZE shows an octet-vector as its return value
           (values))
; No value
CL-USER> (mapc #'describe (with-open-file (stream "/tmp/objects.dat"
                                                  :element-type '(unsigned-byte 8))
                            (cl-serializer:deserialize stream)))
#<ENTITY {1003C12911}>
  [standard-object]

Slots with :INSTANCE allocation:
  NAME  = "Some entity"
#<PERSON {1003C12A81}>
  [standard-object]

Slots with :INSTANCE allocation:
  NAME  = "The Nameless One"
(#<ENTITY {1003C12911}> #<PERSON {1003C12A81}>)
