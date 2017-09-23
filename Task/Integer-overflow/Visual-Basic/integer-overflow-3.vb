    i=0
    On Error GoTo overflow
    i = 2147483647 + 1
    ...
overflow:
    Debug.Print "Error: " & Err.Description      '-> Error: Overflow
