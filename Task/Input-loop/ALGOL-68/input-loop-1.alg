main:(
  PROC raise logical file end = (REF FILE f) BOOL: ( except logical file end );
  on logical file end(stand in, raise logical file end);
  DO
    print(read string);
    read(new line);
    print(new line)
  OD;
  except logical file end:
    SKIP
)
