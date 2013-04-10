var mutate = function(victim) {
    victim[0] = null;
    victim = 42;
};
var foo = [1, 2, 3];
mutate(foo) // foo is now [null, 2, 3], not 42
