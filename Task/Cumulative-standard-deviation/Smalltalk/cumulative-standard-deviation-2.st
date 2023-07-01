|sdacc sd|
sdacc := SDAccum new.

#( 2 4 4 4 5 5 7 9 ) do: [ :v | sd := sdacc value: v ].
('std dev = %1' % { sd }) displayNl.
