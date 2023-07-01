~/src/opt/run $ awk 'BEGIN{printf "enter a string: "}{s=$0;i=$0+0;print "ok,"s"/"i}'
enter a string: hello world
ok,hello world/0
75000
ok,75000/75000
