/*rexx*/
door. = 0
do inc = 1 to 100
  do d = inc to 100 by inc
    door.d = \door.d
  end
end
say "The open doors after 100 passes:"
do i = 1 to 100
  if door.i = 1 then say i
end
