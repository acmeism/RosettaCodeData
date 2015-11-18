Array.prototype.quick_sort = function () {
    if (this.length < 2) { return this; }

    var pivot = this[Math.round(this.length / 2)];

    return this.filter(x => x <  pivot)
               .quick_sort()
               .concat(this.filter(x => x == pivot))
               .concat(this.filter(x => x >  pivot).quick_sort());
};
