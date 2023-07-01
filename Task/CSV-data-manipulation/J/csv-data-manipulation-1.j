   data=: (','&splitstring);.2 freads 'rc_csv.csv'       NB. read and parse data
   data=: (<'"spam"') (<2 3)} data                       NB. amend cell in 3rd row, 4th column (0-indexing)
   'rc_outcsv.csv' fwrites~ ;<@(','&joinstring"1) data   NB. format and write out amended data
