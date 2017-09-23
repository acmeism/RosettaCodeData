{
    let s = " \t String with spaces  \t  ";
    // a future version of ECMAScript will have trimStart().  Some current
    // implementations have trimLeft().
    console.log("original: '" + s + "'");
    console.log("trimmed left: '" + s.replace(/^\s+/,'') + "'");
    // a future version of ECMAScript will have trimEnd().  Some current
    // implementations have trimRight().
    console.log("trimmed right: '" + s.replace(/\s+$/,'') + "'");
    console.log("trimmed both: '" + s.trim() + "'");
 }
