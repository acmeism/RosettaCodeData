reqthreads=: {{ 0&T.@''^:(0>.y-1 T.'')0 }}
dispatchwith=: (t.'')every
newmutex=: 10&T.
lock=: 11&T.
unlock=: 13&T.
synced=: {{
 lock n
 r=. u y
 unlock n
 r
}}
register=: {{ out=: out, y }} synced (newmutex 0)
task=: {{
 reqthreads 3   NB. at least 3 worker threads
 out=: EMPTY
 #@> register dispatchwith ;:'Enjoy Rosetta Code'
 out
}}
