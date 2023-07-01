[:repeat |
    expr := Stdin
              request:'Enter boolean expression (name variables a,b,c...):'
              defaultAnswer:'a|b'.
    ast := Parser parseExpression:expr inNameSpace:nil onError:repeat.
    "
     ensure that only boolean logic operations are inside (sandbox)
    "
    (ast messageSelectors asSet
        conform:[:each | #( '|' '&' 'not' 'xor:' '==>' ) includes:each])
          ifFalse:repeat.
] valueWithRestart.

"
 extract variables from the AST as a collection
 (i.e. if user entered 'a & (b | x)', we get #('a' 'b' 'x')
"
varNames := StringCollection streamContents:[:s | ast variableNodesDo:[:each | s nextPut:each name]].

"
 generate code for a block (aka lambda) to evaluate it; this makes a string like:
   [:a :b :x | a & (b | x) ]
"
code := '[' , ((varNames collect:[:nm | ':',nm]) asString), ' | ' , expr , ']'.

"
 eval the code, to get the block
"
func := Parser evaluate:code.

'Truth table for %s:\n' printf:{expr} on:Stdout.
'===================\n' printf:{} on:Stdout.
(varNames,{' result'}) do:[:each | '|%6s' printf:{each} on:Stdout].
Stdout cr.
Stdout next:(varNames size + 1)*7 put:$-.
Stdout cr.

"
 now print with all combinations
"
allCombinationsDo :=
    [:remainingVars :valuesIn :func |
        remainingVars isEmpty ifTrue:[
            valuesIn do:[:each | '|%6s' printf:{each}on:Stdout].
            '|%6s\n' printf:{ func valueWithArguments:valuesIn} on:Stdout.
        ] ifFalse:[
            #(false true) do:[:each |
                allCombinationsDo value:(remainingVars from:2)
                                  value:(valuesIn copyWith:each)
                                  value:func.
            ].
        ].
    ].

allCombinationsDo value:varNames value:#() value:func
