STRING final state = (
  INT condition;
  PROC do something = VOID: condition := 1 + ENTIER (3 * random);

  state1:
     do something;
     CASE condition IN
        state 1, state 2
     OUT
        state n
     ESAC
  EXIT

  state 2:
     "State Two"
  EXIT

  state n:
     "State N"
);
print(("Final state: ",final state, new line));
