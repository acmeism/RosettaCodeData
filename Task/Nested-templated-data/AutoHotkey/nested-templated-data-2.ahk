T := [[[1,2] , [3,4,1] , 5]]
; Autohotkey uses 1-based objects/arrays
P := ["Payload#1", "Payload#2", "Payload#3", "Payload#4", "Payload#5", "Payload#6", "Payload#7"]
Results := Nested_templated_data(objcopy(t), P)
output := Results.1
Undefined_indices := Results[2]
Unused_Payloads := Results[3]
