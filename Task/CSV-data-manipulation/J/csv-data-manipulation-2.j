   require 'tables/csv'
   data=: makenum readcsv 'rc_csv.csv'  NB. read data and convert cells to numeric where possible
   data=:  (<'spam') (2 3;3 0)} data    NB. amend 2 cells
   data writecsv 'rc_outcsv.csv'        NB. write out amended data. Strings are double-quoted
