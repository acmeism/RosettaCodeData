require 'web/gethttp'

getAllTaskSolnCounts=: monad define
  tasks=.  getCategoryMembers 'Programming_Tasks'
  counts=. getTaskSolnCounts &> tasks
  tasks;counts
)

getTaskSolnCounts=: monad define
  makeuri=. 'http://www.rosettacode.org/w/index.php?title=' , ,&'&action=raw'
  wikidata=. gethttp makeuri urlencode y
  ([: +/ '{{header|'&E.) wikidata
)

formatSolnCounts=: monad define
  'tasks counts'=. y
  tasks=. tasks , &.>':'
  res=. ;:^:_1 tasks ,. (8!:0 counts) ,. <'examples.'
  res , 'Total examples: ' , ": +/counts
)
