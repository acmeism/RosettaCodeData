∇ system s;handle
  ⍝⍝ NOTE: one MUST give the full absolute path to the program (eg. /bin/ls)
  ⍝⍝   Exercise: Can you improve this by parsing the value of
  ⍝⍝    ⎕ENV 'PATH' ?
  ⍝⍝
  handle ← ⎕fio['fork_daemon'] s
  ⎕fio['fclose'] handle
∇
      system '/bin/ls /var'
      backups  games     lib    lock  mail  run    tmp
cache    gemini  local  log   opt   spool
