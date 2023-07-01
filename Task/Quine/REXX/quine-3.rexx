/* Rexx */

Q = "'"
Queue '/* Rexx */'
Queue ''
Queue 'Q = "$"'
Queue '&QQQ'
Queue ''
Queue 'X = 0'
Queue 'Do while Queued() \= 0'
Queue '  Parse pull code'
Queue '  X = X + 1; codel.0 = X; codel.X = code'
Queue '  End'
Queue ''
Queue 'Do x_ = 1 for codel.0'
Queue '  line = codel.x_'
Queue '  If abbrev(line, "Q = ") then Do'
Queue '    line = translate(line, Q, "$")'
Queue '    End'
Queue '  If line = "&QQQ" then Do'
Queue '    Do y_ = 1 to codel.0'
Queue '      qline = codel.y_'
Queue '      Say "Queue" Q || qline || Q'
Queue '      End y_'
Queue '    End'
Queue '  else Do'
Queue '    Say line'
Queue '    End'
Queue '  End x_'
Queue ''

X = 0
Do while Queued() \= 0
  Parse pull code
  X = X + 1; codel.0 = X; codel.X = code
  End

Do x_ = 1 for codel.0
  line = codel.x_
  If abbrev(line, "Q = ") then Do
    line = translate(line, Q, "$")
    End
  If line = "&QQQ" then Do
    Do y_ = 1 to codel.0
      qline = codel.y_
      Say "Queue" Q || qline || Q
      End y_
    End
  else Do
    Say line
    End
  End x_
