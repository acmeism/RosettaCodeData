const rod = (function rod() {
    const chars = "|/-\\";
    let i=0;
    return function() {
        i= (i+1) % 4;
        // We need to use process.stdout.write since console.log automatically adds a \n to the end of lines
        process.stdout.write(` ${chars[i]}\r`);
    }
})();
setInterval(rod, 250);
