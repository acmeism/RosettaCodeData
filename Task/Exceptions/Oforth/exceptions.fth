: iwillThrowAnException  "A new exception" Exception throw ;

: iwillCatch
| e |
   try: e [ iwillThrowAnException ] when: [ "Exception catched :" . e .cr ]
   try: e [ 1 2 over last ] when: [ "Exception catched :" . e .cr ]
   "Done" println ;
