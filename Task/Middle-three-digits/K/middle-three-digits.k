/ Rosetta code - Middle three digits
/ mid3.k
mid3: {qs:$x;:[qs[0]="-";qs: 1 _ qs];:[(#qs)<3;:"small";(1+#qs)!2;:"even"];p:(-3+#qs)%2;:(|p _|p _ qs)}
