let itemsf = [
  "map",                     9.0,  150.0;
  "compass",                13.0,   35.0;
  "water",                 153.0,  200.0;
  "sandwich",               50.0,  160.0;
  "glucose",                15.0,   60.0;
  "tin",                    68.0,   45.0;
  "banana",                 27.0,   60.0;
  "apple",                  39.0,   40.0;
  "cheese",                 23.0,   30.0;
  "beer",                   52.0,   10.0;
  "suntan cream",           11.0,   70.0;
  "camera",                 32.0,   30.0;
  "t-shirt",                24.0,   15.0;
  "trousers",               48.0,   10.0;
  "umbrella",               73.0,   40.0;
  "waterproof trousers",    42.0,   70.0;
  "waterproof overclothes", 43.0,   75.0;
  "note-case",              22.0,   80.0;
  "sunglasses",              7.0,   20.0;
  "towel",                  18.0,   12.0;
  "socks",                   4.0,   50.0;
  "book",                   30.0,   10.0;]|> List.sortBy(fun(_,n,g)->n/g)
