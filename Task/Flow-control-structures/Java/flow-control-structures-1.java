switch (xx) {
  case 1:
  case 2:
    /* 1 & 2 both come here... */
    ...
    break;
  case 4:
    /* 4 comes here... */
    ...
    break;
  case 5:
    /* 5 comes here... */
    ...
    break;
  default:
    /* everything else */
    break;
}

for (int i = 0; i < 10; ++i) {
  ...
  if (some_condition) { break; }
  ...
}

_Time_: do {
  for (int i = 0; i < 10; ++i) {
    ...
    if (some_condition) { break _Time_; /* terminate the do-while loop */}
    ...
    }
  ...
} while (thisCondition);
