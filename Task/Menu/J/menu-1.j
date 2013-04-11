require'misc'
showMenu =: i.@# smoutput@,&":&> ' '&,&.>
makeMsg  =: 'Choose a number 0..' , ': ',~ ":@<:@#
errorMsg =: [ smoutput bind 'Please choose a valid number!'

select=: ({::~ _&".@prompt@(makeMsg [ showMenu)) :: ($:@errorMsg)
