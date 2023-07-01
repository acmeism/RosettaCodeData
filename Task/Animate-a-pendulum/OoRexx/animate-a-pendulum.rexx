pendulum = .pendulum~new(10, 30)

before = .datetime~new
do 100         -- somewhat arbitrary loop count
  call syssleep .2
  now = .datetime~new
  pendulum~update(now - before)
  before = now
  say " X:" pendulum~x " Y:" pendulum~y
end

::class pendulum
::method init
  expose length theta x y velocity
  use arg length, theta
  x = rxcalcsin(theta) * length
  y = rxcalccos(theta) * length
  velocity = 0

::attribute x GET
::attribute y GET

::constant g -9.81   -- acceleration due to gravity

::method update
  expose length theta x y velocity
  use arg duration
  acceleration = self~g / length * rxcalcsin(theta)
  durationSeconds = duration~microseconds / 1000000
  x = rxcalcsin(theta, length)
  y = rxcalccos(theta, length)
  velocity = velocity + acceleration * durationSeconds
  theta = theta + velocity * durationSeconds

::requires rxmath library
