require'general/misc/prompt'

task=: {{
  list=. ''
  while. do.
    y=. (#~ >.=<.)_.".prompt'Enter rainfall int, 99999 to quit: '
    if. 99999 e. y do. (+/%#)list return. end.
    if. y-:y do. echo 'New average: ',":(+/%#)list=. list,y
    else. echo 'invalid input, reenter'
    end.
  end.
}}
