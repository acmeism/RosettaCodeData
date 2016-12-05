variable prod = a[0];

% Skipping the loop variable causes the val to be placed on the stack.
% Also note that the double-brackets ARE required. The inner one creates
% a "range array" based on the length of a.
foreach (a[[1:]])
  % () pops it off.
  prod *= ();

print(prod);
