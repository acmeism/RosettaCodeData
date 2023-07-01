; Load the file and create a fish-class instance:

> (slurp '"object.lfe")
#(ok object)
> (set mommy-fish (fish-class '"Carp"))
#Fun<lfe_eval.10.91765564>

; Execute some of the basic methods:

> (get-species mommy-fish)
"Carp"
> (move mommy-fish 17)
The Carp swam 17 feet!
ok
> (get-id mommy-fish)
"47eebe91a648f042fc3fb278df663de5"

; Now let's look at "modifying" state data (e.g., children counts):

> (get-children mommy-fish)
()
> (get-children-count mommy-fish)
0
> (set (mommy-fish baby-fish-1) (reproduce mommy-fish))
(#Fun<lfe_eval.10.91765564> #Fun<lfe_eval.10.91765564>)
> (get-id mommy-fish)
"47eebe91a648f042fc3fb278df663de5"
> (get-id baby-fish-1)
"fdcf35983bb496650e558a82e34c9935"
> (get-children-count mommy-fish)
1
> (set (mommy-fish baby-fish-2) (reproduce mommy-fish))
(#Fun<lfe_eval.10.91765564> #Fun<lfe_eval.10.91765564>)
> (get-id mommy-fish)
"47eebe91a648f042fc3fb278df663de5"
> (get-id baby-fish-2)
"3e64e5c20fb742dd88dac1032749c2fd"
> (get-children-count mommy-fish)
2
> (get-info mommy-fish)
id: "47eebe91a648f042fc3fb278df663de5"
species: "Carp"
children: ["fdcf35983bb496650e558a82e34c9935",
           "3e64e5c20fb742dd88dac1032749c2fd"]
ok
