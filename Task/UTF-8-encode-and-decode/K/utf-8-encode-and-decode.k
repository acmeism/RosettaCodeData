dec:{64/(0;64 128;32 128 128;16 128 128 128)[-1+#x]+x}
enc:{`c$(0;-64 -128;-32 -128 -128;-16 -128 -128 -128)[b]+(128,(b:1+128 2048 65536'x)#64)\x}
v:(,"A";"ö";"Ж";"€";"𝄞")
`0:" -> "/'(::;$:;::)@'/:+(v; dec'v; enc'dec'v)
