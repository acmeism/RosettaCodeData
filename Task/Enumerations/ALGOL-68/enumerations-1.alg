BEGIN # example 1 #
  MODE FRUIT = INT;
  FRUIT apple = 1, banana = 2, cherry = 4;
  FRUIT x := cherry;
  CASE x IN
    print(("It is an apple #",x, new line)),
    print(("It is a banana #",x, new line)),
    SKIP, # 3 not defined #
    print(("It is a cherry #",x, new line))
  OUT
    SKIP # other values #
  ESAC
END;
