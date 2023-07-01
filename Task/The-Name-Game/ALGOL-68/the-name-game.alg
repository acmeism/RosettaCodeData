main:(
  PROC print lyrics = (STRING name) VOID:
    BEGIN
      PROC change name = (STRING name, CHAR initial) STRING:
        BEGIN
          CHAR lower first = to lower(name[1]);
          IF char in string(lower first, NIL, "aeiou") THEN
            lower first + name[2:]
          ELIF lower first = initial THEN
            name[2:]
          ELSE
            initial + name[2:]
          FI
        END;

    print((name, ", ", name, ", bo-", change name(name, "b"), new line,
           "Banana-fana fo-", change name(name, "f"), new line,
           "Fee-fi-mo-", change name(name, "m"), new line,
           name, "!", new line))
  END;

  []STRING names = ("Gary", "Earl", "Billy", "Felix", "Mary");

  FOR i FROM LWB names TO UPB names DO
    print lyrics(names[i]);
    print(new line)
  OD
)
