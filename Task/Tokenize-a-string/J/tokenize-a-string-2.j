   require 'strings'
   ',' splitstring s
+-----+---+---+---+-----+
|Hello|How|Are|You|Today|
+-----+---+---+---+-----+

   '.' joinstring ',' splitstring s
Hello.How.Are.You.Today
