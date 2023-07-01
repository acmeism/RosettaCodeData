USING: ascii math.order sorting.human ;

IN: scratchpad "foo" "bar" = . ! compare for equality
f
IN: scratchpad "foo" "bar" = not . ! compare for inequality
t
IN: scratchpad "foo" "bar" before? . ! lexically ordered before?
f
IN: scratchpad "foo" "bar" after? . ! lexically ordered after?
t
IN: scratchpad "Foo" "foo" <=> . ! case-sensitive comparison
+lt+
IN: scratchpad "Foo" "foo" [ >lower ] bi@ <=> . ! case-insensitive comparison
+eq+
IN: scratchpad "a1" "a03" <=> . ! comparing numeric strings
+gt+
IN: scratchpad "a1" "a03" human<=> . ! comparing numeric strings like a human
+lt+
