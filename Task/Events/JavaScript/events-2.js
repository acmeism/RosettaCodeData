YUI().use('node-event-simulate', function(Y) {
    // add a click event handler to a DOM node with id "button":
    Y.one("#button").on("click", function (e) {
        alert("Button clicked");
    });
    // simulate the click after one second:
    setTimeout(function () {
        Y.one("#button").simulate("click");
    }, 1000);
});
