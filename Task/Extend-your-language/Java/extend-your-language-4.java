// prints "both true"
if2(true, true)
    .then(() -> print("both true"))
    .elseIfFirst(() -> print("first true"))
    .elseIfSecond(() -> print("second true"))
    .elseNone(() -> print("none true"));

// if we only care about both true and none true...
// prints "none true"
if2(false, false)
    .then(() -> print("both true"))
    .elseNone(() -> { // a lambda can have a block body
        print("none true");
    });
