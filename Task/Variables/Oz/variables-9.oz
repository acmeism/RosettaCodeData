declare
  A
  B = !!A %% B is a read-only view of A
in
  thread
     B = 43 %% this blocks until A is known; then it fails because 43 \= 42
  end
  A = 42
