Note'rudimentary 4 second clock'
 advances an arrow at roughly 1 second intervals,
 accurate to the nearest half second.
 Please replace draw with a verb demonstrating one of
 j's fantastic graphical capabilities.
 x draw y
 x are session seconds
 y is the initial value, session seconds at tic start in the example
   tic^:8 seconds''
)

delay=:6!:3    NB. "sleep"
seconds=:6!:1  NB. session time in seconds
Pass_y =: (]`[`)(`:6)  NB. adverb that evaluates the verb and returns y

round =: [: <. 0.5&+   NB. round to nearest integer
PICTURES=: u:16b2190+i.4 NB. whoot arrows
draw=: [: smoutput PICTURES ((|~ #)~ { [) [: round -

tic=: (>. draw Pass_y <.) ([: seconds 0 $ delay@1:)
