> int x=10;
Result: 10
> x * 5;
Result: 50
> dump wrapper
Last compiled wrapper:
001: mapping(string:mixed) ___hilfe = ___Hilfe->variables;
002: # 1
003: mixed ___HilfeWrapper() { return (([mapping(string:int)](mixed)___hilfe)->x) * 5; ; }
004:
>
