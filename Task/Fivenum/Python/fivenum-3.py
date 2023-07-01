import pandas as pd
pd.DataFrame([1, 2, 3, 4, 5, 6]).quantile([.0, .25, .50, .75, 1.00], interpolation='nearest')
