main:(
  PROC raise logical file end = (REF FILE f) BOOL: ( except logical file end );
  on logical file end(stand in, raise logical file end);
  DO
    PROC raise page end = (REF FILE f) BOOL: ( except page end );
    on page end(stand in, raise page end);
    DO
      print(read string);
      read(new line);
      print(new line)
    OD;
    except page end:
      read(new page);
      print(new page)
  OD;
  except logical file end:
    SKIP
)
