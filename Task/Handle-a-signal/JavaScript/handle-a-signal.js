(function(){
    var count=0
        secs=0

    var i= setInterval( function (){
        count++
        secs+=0.5
        console.log(count)
    }, 500);

    process.on('SIGINT', function() {
        clearInterval(i)
        console.log(secs+' seconds elapsed');
        process.exit()
    });
})();
