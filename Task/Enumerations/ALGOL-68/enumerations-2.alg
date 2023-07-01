BEGIN # example 2 #
  MODE ENUM = [0]CHAR; # something with minimal size #
  MODE APPLE = STRUCT(ENUM apple), BANANA = STRUCT(ENUM banana), CHERRY = STRUCT(ENUM cherry);
  MODE FRUIT = UNION(APPLE, BANANA, CHERRY);

  OP REPR = (FRUIT f)STRING:
    CASE f IN
      (APPLE):"Apple",
      (BANANA):"Banana",
      (CHERRY):"Cherry"
    OUT
      "?" # uninitalised #
    ESAC;

  FRUIT x := LOC CHERRY;

  CASE x IN
    (APPLE):print(("It is an ",REPR x, new line)),
    (BANANA):print(("It is a ",REPR x, new line)),
    (CHERRY):print(("It is a ",REPR x, new line))
  OUT
    SKIP # uninitialised FRUIT #
  ESAC
END
