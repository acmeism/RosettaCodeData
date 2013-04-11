> mapping(string:int) A = ([ "John":1, "Serena":1, "Bob":1, "Mary":1 ]);
> mapping(string:int) B = ([ "Jim":1, "Mary":1, "John":1, "Bob":1 ]);

> A^B;
Result: ([ "Jim": 1, "Serena": 1 ])
