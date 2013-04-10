(de userVariable ()
   (prin "Enter a variable name: ")
   (let Var (line T)                                  # Read transient symbol
      (prin "Enter a value: ")
      (set Var (read))                                # Set symbol's value
      (println 'Variable Var 'Value (val Var)) ) )    # Print them
