: strip-block-comments ( string -- string )
  R/ /\*.*?\*\// "" re-replace ;
