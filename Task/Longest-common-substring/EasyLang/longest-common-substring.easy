func$ lcs a$ b$ .
   if a$ = "" or b$ = ""
      return ""
   .
   while b$ <> ""
      for j = len b$ downto 1
         l$ = substr b$ 1 j
         for k = 1 to len a$ - j + 1
            if substr a$ k j = l$
               if len l$ > len max$
                  max$ = l$
               .
               break 2
            .
         .
      .
      b$ = substr b$ 2 9999
   .
   return max$
.
print lcs "thisisatest" "testing123testing"
print lcs "thisisatest" "stesting123testing"
print lcs "thisisatestxestinoo" "xxtesting123testing"
