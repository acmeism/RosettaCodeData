package Simple_Parse is
   -- a very simplistic parser, useful to split a string into words

   function Next_Word(S: String; Point: in out Positive)
		     return String;
   -- a "word" is a sequence of non-space characters
   -- if S(Point .. S'Last) holds at least one word W
   -- then  Next_Word increments Point by len(W) and returns W.
   -- else  Next_Word sets Point to S'Last+1 and returns ""

end Simple_Parse;
