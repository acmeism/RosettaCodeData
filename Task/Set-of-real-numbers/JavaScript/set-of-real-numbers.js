function realSet(set1, set2, op, values) {
    const makeSet=(set0)=>{
        let res = []
        if(set0.rangeType===0){
            for(let i=set0.low;i<=set0.high;i++)
                res.push(i);
        } else if (set0.rangeType===1) {
            for(let i=set0.low+1;i<set0.high;i++)
                res.push(i);
        } else if(set0.rangeType===2){
            for(let i=set0.low+1;i<=set0.high;i++)
                res.push(i);
        } else {
            for(let i=set0.low;i<set0.high;i++)
                res.push(i);
        }
        return res;
    }
    let res = [],finalSet=[];
    set1 = makeSet(set1);
    set2 = makeSet(set2);
    if(op==="union")
        finalSet = [...new Set([...set1,...set2])];
    else if(op==="intersect") {
        for(let i=0;i<set1.length;i++)
            if(set1.indexOf(set2[i])!==-1)
                finalSet.push(set2[i]);
    } else {
        for(let i=0;i<set2.length;i++)
            if(set1.indexOf(set2[i])===-1)
                finalSet.push(set2[i]);

        for(let i=0;i<set1.length;i++)
            if(set2.indexOf(set1[i])===-1)
                finalSet.push(set1[i]);
    }
    for(let i=0;i<values.length;i++){
        if(finalSet.indexOf(values[i])!==-1)
            res.push(true);
        else
            res.push(false);
    }
    return res;
}
