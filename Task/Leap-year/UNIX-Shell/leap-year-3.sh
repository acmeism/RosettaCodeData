is_leap() {
  local year=$(( 10#${1:?'Missing year'} ))
  (( year % 4 == 0 && ( year % 100 != 0 || year % 400 == 0 ) )) && return 0
  return 1
}
