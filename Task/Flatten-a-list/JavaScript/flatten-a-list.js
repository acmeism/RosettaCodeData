function flatten(arr){
    return arr.reduce(function(acc, val){
        return acc.concat(val.constructor === Array ? flatten(val) : val);
    },[]);
}
