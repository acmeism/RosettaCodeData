function Integrator(sampleIntervalMS) {
    var inputF = function () { return 0.0 };
    var sum = 0.0;

    var t1 = new Date().getTime();
    var input1 = inputF(t1 / 1000);

    function update() {
        var t2 = new Date().getTime();
        var input2 = inputF(t2 / 1000);
        var dt = (t2 - t1) / 1000;

        sum += (input1 + input2) * dt / 2;

        t1 = t2;
        input1 = input2;
    }

    var updater = setInterval(update, sampleIntervalMS);

    return ({
        input: function (newF) { inputF = newF },
        output: function () { return sum },
        shutdown: function () { clearInterval(updater) },
    });
}
