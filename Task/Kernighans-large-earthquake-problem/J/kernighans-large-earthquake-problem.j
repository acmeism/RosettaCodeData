NB. this program is designed for systems where the line ending is either LF or CRLF


NB. filename select_magnitude minimum
NB. default file is /tmp/famous.quakers

select_magnitude=: '/tmp/famous.quakers'&$: : (4 :0)
 data =. 1!:1 boxopen x       NB. read the file
 data =. data -. CR           NB. remove nasty carriage returns
 data =. ,&LF^:(LF~:{:) data  NB. append new line if none found
 lines =. [;._2 data          NB. split the literal based on the final character
 magnitudes =. ". _1&{::@(<;._2)@(,&' ')@deb"1 lines
 (y <: magnitudes) # lines
)
