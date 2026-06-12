max=: 3 3 2 2,1 2 3 4,:1 3 5 0
alloc=: 1 2 2 1,1 0 3 3,:1 2 1 0
total=:6 5 7 6

NB. simulate running process
NB. left arg: newly available resources, right: previously available
NB. result: resources freed
run=: +
