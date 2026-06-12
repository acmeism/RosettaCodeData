stocks=: |: ,: ;:'date trans symbol qty price'
insertStock=: 3 :'0#stocks=: stocks,.y'
insertStock@".;._2]0 :0
   '2006-01-05'; 'BUY';  'RHAT';   100; 35.14
   '2006-03-28'; 'BUY';  'IBM';   1000; 45.00
   '2006-04-05'; 'BUY';  'MSOFT'; 1000; 72.00
   '2006-04-06'; 'SELL'; 'IBM';    500; 53.00
)
