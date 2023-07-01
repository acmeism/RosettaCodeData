function selfReferential(n) {
    n = n.toString();
    let res = [n];
    const makeNext = (n) => {
        let matchs = {
            '9':0,'8':0,'7':0,'6':0,'5':0,'4':0,'3':0,'2':0,'1':0,'0':0}, res = [];
        for(let index=0;index<n.length;index++)
            matchs[n[index].toString()]++;
        for(let index=9;index>=0;index--)
            if(matchs[index]>0)
                res.push(matchs[index],index);
        return res.join("").toString();
    }
    for(let i=0;i<10;i++)
        res.push(makeNext(res[res.length-1]));
    return [...new Set(res)];
}
