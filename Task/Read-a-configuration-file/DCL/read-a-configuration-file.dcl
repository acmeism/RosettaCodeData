$ open input config.ini
$ loop:
$  read /end_of_file = done input line
$  line = f$edit( line, "trim" )  ! removes leading and trailing spaces or tabs
$  if f$length( line ) .eq. 0 then $ goto loop
$  first_character = f$extract( 0, 1, line )
$  if first_character .eqs. "#" .or. first_character .eqs. ";" then $ goto loop
$  equal_sign_offset = f$locate( "=", line )
$  length_of_line = f$length( line )
$  if equal_sign_offset .ne. length_of_line then $ line = f$extract( 0, equal_sign_offset, line ) + " " + f$extract( equal_sign_offset + 1, length_of_line, line )
$  option_name = f$element( 0, " ", line )
$  parameter_data = line - option_name - " "
$  if parameter_data .eqs. "" then $ parameter_data = "true"
$  'option_name = parameter_data
$  show symbol 'option_name
$  goto loop
$ done:
$ close input
