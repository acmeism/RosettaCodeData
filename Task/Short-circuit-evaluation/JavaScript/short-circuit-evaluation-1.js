function a(bool) {
    console.log('a -->', bool);

    return bool;
}

function b(bool) {
    console.log('b -->', bool);

    return bool;
}

var x = a(false) && b(true),
    y = a(true) || b(false);
