function init = cellularAutomaton(rule, init, n)
  init(n + 1, :) = 0;
  for k = 1 : n
    init(k + 1, :) = bitget(rule, 1 + filter2([4 2 1], init(k, :)));
  end
