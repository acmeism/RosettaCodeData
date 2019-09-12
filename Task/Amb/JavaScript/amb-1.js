function ambRun(func) {
    var choices = [];
    var index;

    function amb(values) {
        if (values.length == 0) {
            fail();
        }
        if (index == choices.length) {
            choices.push({i: 0,
                          count: values.length});
        }
        var choice = choices[index++];
        return values[choice.i];
    }

    function fail() { throw fail; }

    while (true) {
        try {
            index = 0;
            return func(amb, fail);
        } catch (e) {
            if (e != fail) {
                throw e;
            }
            var choice;
            while ((choice = choices.pop()) && ++choice.i == choice.count) {}
            if (choice == undefined) {
                return undefined;
            }
            choices.push(choice);
        }
    }
}

ambRun(function(amb, fail) {
    function linked(s1, s2) {
        return s1.slice(-1) == s2.slice(0, 1);
    }

    var w1 = amb(["the", "that", "a"]);
    var w2 = amb(["frog", "elephant", "thing"]);
    if (!linked(w1, w2)) fail();

    var w3 = amb(["walked", "treaded", "grows"]);
    if (!linked(w2, w3)) fail();

    var w4 = amb(["slowly", "quickly"]);
    if (!linked(w3, w4)) fail();

    return [w1, w2, w3, w4].join(' ');
});  // "that thing grows slowly"
