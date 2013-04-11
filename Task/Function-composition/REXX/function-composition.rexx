compose: procedure;  parse arg f,g,x;  interpret 'return' f"(" g'(' x "))"
exit      /*control never gets here, but this was added just in case.*/
