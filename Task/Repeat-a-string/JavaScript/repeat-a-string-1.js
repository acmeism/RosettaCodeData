String.prototype.repeat = function(n) {
    return new Array(1 + (n || 0)).join(this);
}

console.log("ha".repeat(5));  // hahahahaha
