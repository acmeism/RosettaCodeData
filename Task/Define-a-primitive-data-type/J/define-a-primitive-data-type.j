NB. z locale by default on path.
type_z_=: 3!:0
nameClass_z_=: 4!:0
signalError_z_=: 13!:8

NB. create a restricted object from an appropriate integer
create_restrict_ =: monad define
 'Domain error: expected integer' assert 1 4 e.~ type y  NB. or Boolean
 'Domain error: not on [1,10]' assert (0 -.@:e. [: , (0&<*.<&11)) y
 value=: y
)

add_restrict_=: monad define
 if. 0 = nameClass<'value__y' do.
  (value + value__y) conew 0{::coname''
 else.
  'value unavailable'signalError 21
 end.
)
