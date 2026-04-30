EVALUATE EXPRESSION-1 ALSO EXPRESSION-2
   WHEN TRUE ALSO TRUE
      DISPLAY 'Both are true.'
   WHEN TRUE ALSO FALSE
      DISPLAY 'Expression 1 is true.'
   WHEN FALSE ALSO TRUE
      DISPLAY 'Expression 2 is true.'
   WHEN OTHER
      DISPLAY 'Neither is true.'
END-EVALUATE
