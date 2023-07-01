alpha=: a.{~65+i.26
normalize=: {{ rplc&'JI'(toupper y)([-.-.)alpha }}
bifid=: {{ m{~_2 (t&#.)\,|:(t,t=.%:#m)#:m i.y([-.-.)m }}
difib=: {{ m{~t#.|:(|.@$$,)(t,t=.%:#m)#:m i.y([-.-.)m }}
