function acceptedBinFormat(bin) {
    if (bin == 1 || bin === 0 || bin === '0')
        return true;
    else
        return bin;
}

function arePseudoBin() {
    var args = [].slice.call(arguments), len = args.length;
    while(len--)
        if (acceptedBinFormat(args[len]) !== true)
            throw new Error('argument must be 0, \'0\', 1, or \'1\', argument ' + len + ' was ' + args[len]);
    return true;
}
