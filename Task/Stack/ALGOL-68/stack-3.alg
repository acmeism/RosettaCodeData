# -*- coding: utf-8 -*- #
MODE DIETITEM = STRUCT(
  STRING food, annual quantity, units, REAL cost
);

# Stigler's 1939 Diet ... #
FORMAT diet item fmt = $g": "g" "g" = $"zd.dd$;
[]DIETITEM stigler diet = (
  ("Cabbage",           "111","lb.",  4.11),
  ("Dried Navy Beans",  "285","lb.", 16.80),
  ("Evaporated Milk",    "57","cans", 3.84),
  ("Spinach",            "23","lb.",  1.85),
  ("Wheat Flour",       "370","lb.", 13.33),
  ("Total Annual Cost",    "","",    39.93)
)
