f = { |x| x + 1 };
g = { |x| x * 2 };
h = g <> f;
h.(8); // returns 18
