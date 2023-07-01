// this example adds an "s" to bottle until there is only 1 bottle left on the wall

local(s = 's')
with n in 99 to 1 by -1 do {^
    #n + ' bottle' + #s + ' of beer on the wall,<br>'
    #n + ' bottle' + #s + ' of beer,<br>'
    #n = #n - 1
    #s = (#n != 1 ? 's' | '')
    'Take one down, pass it around,<br>'
    #n + ' bottle' + #s + ' of beer on the wall.<br><br>'
^}
