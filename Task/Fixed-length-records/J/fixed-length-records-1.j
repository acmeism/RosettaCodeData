   _80 ]\ fread 'flr-infile.dat'   NB. reads the file into a n by 80 array
   _80 |.\ fread 'flr-infile.dat'  NB. as above but reverses each 80 byte chunk
   'flr-outfile.dat' fwrite~ , _80 |.\ fread 'flr-infile.dat'  NB. as above but writes result to file (720 bytes)
   processFixLenFile=: fwrite~ [: , _80 |.\ fread              NB. represent operation as a verb/function
