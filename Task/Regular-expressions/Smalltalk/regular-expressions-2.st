|re s s1|
re := 'm[a-z]+ing' asRegex.
s := 'this is a matching string'.

(re search: s) ifTrue: [ 'matches!' ].

s1 := re copy: s replacingMatchesWith: 'modified'.
