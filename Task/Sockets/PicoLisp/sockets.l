(when (connect "localhost" 256)
   (out @ (prinl "hello socket world"))
   (close @) )
