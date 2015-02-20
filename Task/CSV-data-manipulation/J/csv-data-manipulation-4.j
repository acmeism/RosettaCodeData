   sumCSVrows=: writecsv~ (((<'SUM') ,~ {.) , [: (<"0)@(,. +/"1) makenum@}.)@readcsv
   'rc_out.csv' sumCSVrows 'rc.csv'
