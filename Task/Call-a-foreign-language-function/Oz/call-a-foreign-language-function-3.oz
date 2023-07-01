declare
  [Strdup] = {Module.link ['strdup.so{native}']}
in
  {System.showInfo {Strdup.strdup "hello"}}
