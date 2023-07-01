int[] arg = { 1, 2, 3, 4, 5 };
int sum = arg.Sum();
int prod = arg.Aggregate((runningProduct, nextFactor) => runningProduct * nextFactor);
