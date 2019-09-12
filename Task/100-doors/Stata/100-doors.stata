clear
set obs 100
gen doors=0
gen index=_n
forvalues i=1/100 {
	quietly replace doors=!doors if mod(_n,`i')==0
}
list index if doors, noobs noheader

  +-------+
  |     1 |
  |     4 |
  |     9 |
  |    16 |
  |    25 |
  |-------|
  |    36 |
  |    49 |
  |    64 |
  |    81 |
  |   100 |
  +-------+
