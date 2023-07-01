(if problem
   (-> Runtime (. getRuntime) (. halt integerErrorCode)))
   ; conventionally, error code 0 is the code for "OK",
   ; while anything else is an actual problem
