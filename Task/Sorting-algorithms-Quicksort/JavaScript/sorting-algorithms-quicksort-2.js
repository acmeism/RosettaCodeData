Array.prototype.quick_sort = function ()
{
    if (this.length <= 1)
        return this;

    var pivot = this[Math.round(this.length / 2)];

    return this.filter(function (x) { return x <  pivot }).quick_sort().concat(
           this.filter(function (x) { return x == pivot })).concat(
           this.filter(function (x) { return x >  pivot }).quick_sort());
}
