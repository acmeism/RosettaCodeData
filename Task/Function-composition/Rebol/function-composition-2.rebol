foo: func [x] [reform ["foo:" x]]
bar: func [x] [reform ["bar:" x]]

foo-bar: compose-functions :foo :bar
print ["Composition of foo and bar:"  mold foo-bar "test"]

sin-asin: compose-functions :sine :arcsine
print [crlf "Composition of sine and arcsine:" sin-asin 0.5]
