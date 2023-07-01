case i of
  1,4,9: { executed if i is 1, 4 or 9 }
    DoSomething;
  11, 13 .. 17: { executed if i is 11, 13, 14, 15, 16 or 17 }
    DoSomethingElse;
  42: { executed only if i is 42 }
    DoSomeOtherThing;
  else
    DoYetAnotherThing;
end;
