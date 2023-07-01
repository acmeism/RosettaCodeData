s: "apples, pears ; and bananas"
dlms: charset "#;"

trim head clear find s dlms
== "apples, pears"

s: "apples, pears # and bananas"

trim head clear find s dlms
== "apples, pears"
