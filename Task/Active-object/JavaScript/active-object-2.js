<p><span id="a">Test running...</span> <code id="b">-</code></p>

<script type="text/javascript">
    var f = 0.5;

    var i = new Integrator(1);
    var displayer = setInterval(function () { document.getElementById("b").firstChild.data = i.output() }, 100)

    setTimeout(function () {
        i.input(function (t) { return Math.sin(2*Math.PI*f*t) }); // test step 1
        setTimeout(function () { // test step 2
            i.input(function (t) { return 0 }); // test step 3
            setTimeout(function () { // test step 3
                i.shutdown();
                clearInterval(displayer);
                document.getElementById("a").firstChild.data = "Done, should be about 0: "
            }, 500);
        }, 2000);
    }, 1)
</script>
