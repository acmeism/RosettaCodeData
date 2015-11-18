(function streamTillInitialTen() {
    var nFirst = Math.floor(Math.random() * 20);

    console.log(nFirst);

    if (nFirst === 10) return true;

    console.log(
        Math.floor(Math.random() * 20)
    );

    return streamTillInitialTen();
})();
