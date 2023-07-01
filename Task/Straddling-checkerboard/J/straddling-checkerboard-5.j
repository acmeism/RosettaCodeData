   3 7 setcode 'HOLMESRTABCDFGIJKNPQUVWXYZ./'
   preprocess=: (#~ alphabet e.~ ])@toupper
   ,":"0 encode message=: preprocess 'One night-it was on the twentieth of March, 1888-I was returning'
139539363509369743061399059745399365901344308320791798798798367430685972839363935
   decode encode message
ONENIGHTITWASONTHETWENTIETHOFMARCH1888IWASRETURNING
   ]s=. ((10|+) 0 4 5 2$~$)&.encode message NB. scramble by taking a modular sum with 0 4 5 2 while encoded
OWVKRNEOAMTMXROWOHTMTMTROTQ4SEMRRLRZLVSTTLLOROMHALSFOHECMRWESWEE
   ((10|-) 0 4 5 2$~$)&.encode s
ONENIGHTITWASONTHETWENTIETHOFMARCH1888IWASRETURNING
