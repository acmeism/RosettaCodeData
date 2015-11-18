(function (lists) {

    // [[a]] -> [[a]]
    function zip(lists) {
        var lng = lists.length,
            lstHead = lng ? [].concat.apply([], lists.map(function (lst) {
                return lst.length ? [lst[0]] : [];
            })) : [];

        return lstHead.length === lng ? [lstHead].concat(
            zip(lists.map(function (x) {
                return x.slice(1);
            }))
        ) : [];
    }

    // [a] -> s
    function concat(lst) {
        return ''.concat.apply('', lst);
    }

    return zip(lists).map(concat).join('\n')

})([["a", "b", "c"], ["A", "B", "C"], [1, 2, 3]]);
