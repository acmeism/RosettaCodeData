>> parse s: "apples, pears ; and bananas" [to [any space ";"] remove thru end]
== true
>> s
== "apples, pears"
