function F(X: Integer; Y: Integer := 0) return Integer; -- Y is optional
...
A : Integer := F(12);
B : Integer := F(12, 0); -- the same as A
C : Integer := F(12, 1); -- something different
