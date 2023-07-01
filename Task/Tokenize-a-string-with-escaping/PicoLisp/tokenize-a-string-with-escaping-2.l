(for (I . S) (tokenize "one\^|uno||three\^\^\^\^|four\^\^\^|\^cuatro|" "|" "\^")
   (prinl I ": " S) )
