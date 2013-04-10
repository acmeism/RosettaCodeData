As ColdFusion's grammar is based around HTML syntax, commenting is similar to HTML.  Note that in the examples below, you will need to remove the space between the < and the !.
< !--- This is a comment.  Nothing in this tag can be seen by the end user.
       Note the three-or-greater dashes to open and close the tag. --->
< !--  This is an HTML comment.  Any HTML between the opening and closing of the tag will be ignored, but any ColdFusion code will still run.
       Note that in the popular FuseBox framework for ColdFusion, the circuit.xml files require that you use this style of comment. -->
