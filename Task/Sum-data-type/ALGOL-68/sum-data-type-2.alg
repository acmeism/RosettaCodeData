CASE t1
  IN (REF NODE n): print( ( "node",     newline ) )
   , (    LEAF l): print( ( "leaf ", l, newline ) )
   , (    VOID  ): print( ( "empty",    newline ) )
ESAC
