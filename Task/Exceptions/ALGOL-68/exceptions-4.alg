PROC raise foo event(REF OBJECTFOO foo)BOOL:
  IF mend foo(foo) THEN
    TRUE # continue #
  ELSE
    except foo event
    FALSE # OR fall back to default event routine #
  FI
