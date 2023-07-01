      h ← ⎕fio['fopen'] 'input.txt'
      h
7
      ⎕fio['fstat'] h
66311 803134 33188 1 1000 1000 0 11634 4096 24 1642047105 1642047105 1642047105
      ⎕fio['fclose'] h
0
      h ← ⎕fio['fopen'] 'docs/'
      h
7
      ⎕fio['fstat'] h
66311 3296858 16877 2 1000 1000 0 4096 4096 8 1642047108 1642047108 1642047108
      ⎕fio['fclose'] h
0
      h ← ⎕fio['fopen'] 'does_not_exist.txt'
      h
¯1
