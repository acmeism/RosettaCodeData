declare
  X = {Value.failed dontTouchMe}
in
  {Wait X}  %% throws dontTouchMe
