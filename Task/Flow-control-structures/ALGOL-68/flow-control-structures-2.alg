STRING medal = (
  []PROC VOID award = (gold,silver,bronze);

  award[ 1 + ENTIER (random*3)];

  gold: "Gold" EXIT
  silver: "Silver" EXIT
  bronze: "Bronze"

);

print(("Medal awarded: ",medal, new line));
