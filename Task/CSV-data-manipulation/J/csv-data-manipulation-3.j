   require 'tables/csv'
   'hdr data'=: split readcsv 'rc_csv.csv'   NB. read data, split the header & data
   hdr=: hdr , <'SUM'                        NB. add title for extra column to header
   data=: <"0 (,. +/"1) makenum data         NB. convert to numeric, sum rows & append column
   (hdr,data) writecsv 'rc_out.csv'
