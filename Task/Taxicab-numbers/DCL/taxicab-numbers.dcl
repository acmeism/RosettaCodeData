$ close /nolog sums_of_cubes
$ on control_y then $ goto clean
$ open /write sums_of_cubes sums_of_cubes.txt
$ i = 1
$ loop1:
$  write sys$output i
$  j = 1
$  loop2:
$   sum = i * i * i + j * j * j
$   if sum .lt. 0
$   then
$    write sys$output "overflow at ", j
$    goto next_i
$   endif
$   write sums_of_cubes f$fao( "!10SL,!10SL,!10SL", sum, i, j )
$   j = j + 1
$   if j .le. i then $ goto loop2
$ next_i:
$  i = i + 1
$  if i .le. 1289 then $ goto loop1  ! cube_root of 2^31-1
$ close sums_of_cubes
$ sort sums_of_cubes.txt sorted_sums_of_cubes.txt
$ close /nolog sorted_sums_of_cubes
$ open sorted_sums_of_cubes sorted_sums_of_cubes.txt
$ count = 0
$ read sorted_sums_of_cubes prev_prev_line  ! need to detect when there are more than just 2 different sums, e.g. 456
$ prev_prev_sum = f$element( 0, ",", f$edit( prev_prev_line, "collapse" ))
$ read sorted_sums_of_cubes prev_line
$ prev_sum = f$element( 0,",", f$edit( prev_line, "collapse" ))
$ loop3:
$  read /end_of_file = done sorted_sums_of_cubes line
$  sum = f$element( 0, ",", f$edit( line, "collapse" ))
$  if sum .eqs. prev_sum
$  then
$   if sum .nes. prev_prev_sum then $ count = count + 1
$   int_sum = f$integer( sum )
$   i1 = f$integer( f$element( 1, ",", prev_line ))
$   j1 = f$integer( f$element( 2, ",", prev_line ))
$   i2 = f$integer( f$element( 1, ",", line ))
$   j2 = f$integer( f$element( 2, ",", line ))
$   if count .le. 25 .or. ( count .ge. 2000 .and. count .le. 2006 ) then -
$    write sys$output f$fao( "!4SL:!11SL =!5SL^3 +!5SL^3 =!5SL^3 +!5SL^3", count, int_sum, i1, j1, i2, j2 )
$  endif
$  prev_prev_line = prev_line
$  prev_prev_sum = prev_sum
$  prev_line = line
$  prev_sum = sum
$  goto loop3
$ done:
$ close sorted_sums_of_cubes
$ exit
$
$ clean:
$ close /nolog sorted_sums_of_cubes
$ close /nolog sums_of_cubes
