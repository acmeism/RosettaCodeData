YUI().use('event-custom', function(Y) {
    // add a custom event:
    Y.on('my:event', function () {
        alert("Event fired");
    });
    // fire the event after one second:
    setTimeout(function () {
        Y.fire('my:event');
    }, 1000);
});
