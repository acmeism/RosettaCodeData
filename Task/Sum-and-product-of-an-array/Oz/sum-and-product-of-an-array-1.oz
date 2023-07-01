declare
  Xs = [1 2 3 4 5]
  Sum = {FoldL Xs Number.'+' 0}
  Product = {FoldL Xs Number.'*' 1}
in
  {Show Sum}
  {Show Product}
