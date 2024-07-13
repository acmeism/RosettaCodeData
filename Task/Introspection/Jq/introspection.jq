def checkVersion:
  $version
  | capture("^[^- ]*(?<jq>[- ])(?<major>[0-9]*)[.](?<minor>[0-9]*)") // {jq: 0}
  | if .jq == 0 then "unrecognized version identification: \($version)" | error
    elif .jq == "-"  # jq
         and (.major < "1" or (.major == "1" and .minor < "5"))
    then "version \($version) is too old" | error
    elif .jq == " "  # gojq
         and (.major == "0" and  (.minor | tonumber) < 12)
    then "version \($version) is too old" | error
    else .
    end;

  checkVersion

  # Check that abs/0 is defined
  | (builtins | index("abs/0")) as $ix
  | if $ix == null then "abs/0 not available" | error else . end

  # Is bloop a global variable?
  | if ($ARGS.named | has("bloop")) then $ARGS.named["bloop"] | abs
    else "There is no globally defined variable name $bloop." | error
    end
