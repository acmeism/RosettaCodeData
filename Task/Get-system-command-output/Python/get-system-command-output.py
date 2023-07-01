>>> import subprocess
>>> returned_text = subprocess.check_output("dir", shell=True, universal_newlines=True)
>>> type(returned_text)
<class 'str'>
>>> print(returned_text)
 Volume in drive C is Windows
 Volume Serial Number is 44X7-73CE

 Directory of C:\Python33

04/07/2013  06:40    <DIR>          .
04/07/2013  06:40    <DIR>          ..
27/05/2013  07:10    <DIR>          DLLs
27/05/2013  07:10    <DIR>          Doc
27/05/2013  07:10    <DIR>          include
27/05/2013  07:10    <DIR>          Lib
27/05/2013  07:10    <DIR>          libs
16/05/2013  00:15            33,326 LICENSE.txt
15/05/2013  22:49           214,554 NEWS.txt
16/05/2013  00:03            26,624 python.exe
16/05/2013  00:03            27,136 pythonw.exe
15/05/2013  22:49             6,701 README.txt
27/05/2013  07:10    <DIR>          tcl
27/05/2013  07:10    <DIR>          Tools
16/05/2013  00:02            43,008 w9xpopen.exe
               6 File(s)        351,349 bytes
               9 Dir(s)  46,326,947,840 bytes free

>>> # Ref: https://docs.python.org/3/library/subprocess.html
