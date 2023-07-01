 define(`sumstr', `eval(patsubst(`$1',` ',`+'))')

sumstr(1 2)
3
