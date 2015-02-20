var gen = new SoEIncClass();
for (var i = 1; i < 1000000; i++, gen.next());
var prime = gen.next();

if (typeof print == "undefined")
    print = (typeof WScript != "undefined") ? WScript.Echo : alert;
print(prime);
