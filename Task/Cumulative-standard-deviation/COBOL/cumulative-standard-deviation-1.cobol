IDENTIFICATION DIVISION.
PROGRAM-ID. run-stddev.
environment division.
input-output section.
file-control.
  select input-file assign to "input.txt"
    organization is line sequential.
data division.
file section.
fd input-file.
  01  inp-record.
    03  inp-fld  pic 9(03).
working-storage section.
01  filler pic 9(01)   value 0.
  88 no-more-input     value 1.
01  ws-tb-data.
  03  ws-tb-size         pic 9(03).
  03  ws-tb-table.
    05  ws-tb-fld     pic s9(05)v9999 comp-3 occurs 0 to 100 times
        depending on ws-tb-size.
01 ws-stddev       pic s9(05)v9999 comp-3.
PROCEDURE DIVISION.
  move 0 to ws-tb-size
  open  input input-file
    read input-file
    at end
      set no-more-input to true
    end-read
    perform
      test after
    until no-more-input
      add 1 to ws-tb-size
      move inp-fld to ws-tb-fld (ws-tb-size)
      call 'stddev' using  by reference ws-tb-data
         ws-stddev
      display  'inp=' inp-fld ' stddev=' ws-stddev
      read input-file at end set no-more-input to true end-read
    end-perform
  close input-file
  stop run.
end program run-stddev.
IDENTIFICATION DIVISION.
PROGRAM-ID. stddev.
data division.
working-storage section.
01 ws-tbx             pic s9(03) comp.
01 ws-tb-work.
  03  ws-sum          pic s9(05)v9999 comp-3 value +0.
  03  ws-sumsq        pic s9(05)v9999 comp-3 value +0.
  03  ws-avg          pic s9(05)v9999 comp-3 value +0.
linkage section.
01  ws-tb-data.
  03  ws-tb-size         pic 9(03).
  03  ws-tb-table.
    05  ws-tb-fld     pic s9(05)v9999 comp-3 occurs 0 to 100 times
        depending on ws-tb-size.
01  ws-stddev       pic s9(05)v9999 comp-3.
PROCEDURE DIVISION using  ws-tb-data  ws-stddev.
    compute ws-sum = 0
    perform test before varying ws-tbx from 1 by +1 until ws-tbx > ws-tb-size
        compute ws-sum = ws-sum + ws-tb-fld (ws-tbx)
    end-perform
    compute ws-avg rounded = ws-sum / ws-tb-size
    compute ws-sumsq = 0
    perform test before varying ws-tbx from 1 by +1 until ws-tbx > ws-tb-size
        compute ws-sumsq = ws-sumsq
        + (ws-tb-fld (ws-tbx) - ws-avg) ** 2.0
    end-perform
    compute ws-stddev = ( ws-sumsq / ws-tb-size) ** 0.5
    goback.
end program stddev.
