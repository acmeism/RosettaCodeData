main:(
# as a STRING #
  STRING extra = "little";
  printf(($"Mary had a "g" lamb."l$, extra));

# as a FORMAT #
  FORMAT extraf = $"little"$;
  printf($"Mary had a "f(extraf)" lamb."l$);

# or: use simply use STRING concatenation #
  print(("Mary had a "+extra+" lamb.", new line))
)
