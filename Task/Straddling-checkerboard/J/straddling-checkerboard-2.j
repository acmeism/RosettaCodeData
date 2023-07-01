   preprocess=: (#~ Charset e.~ ])@toupper                 NB. verb to compress out non-alphanumerics
   chkbrdRC=: chkbrd (3 7;'HOLMESRTABCDFGIJKNPQUVWXYZ./')  NB. define adverb by applying Rosetta Code key to chkbrd conjunction
   0 chkbrdRC preprocess 'One night-it was on the twentieth of March, 1888-I was returning'
139539363509369743061399059745399365901344308320791798798798367430685972839363935
   1 chkbrdRC 0 chkbrdRC preprocess 'One night-it was on the twentieth of March, 1888-I was returning'
ONENIGHTITWASONTHETWENTIETHOFMARCH1888IWASRETURNING
