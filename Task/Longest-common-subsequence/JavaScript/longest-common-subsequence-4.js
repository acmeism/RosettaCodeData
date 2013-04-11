function lcs_greedy(x,y){
	var symbols = {},
		r=0,p=0,p1,L=0,idx,
		m=x.length,n=y.length,
		S = new Buffer(m<n?n:m);
	p1 = popsym(0);
	for(i=0;i < m;i++){
		p = (r===p)?p1:popsym(i);
		p1 = popsym(i+1);
		idx=(p > p1)?(i++,p1):p;
		if(idx===n){p=popsym(i);}
		else{
			r=idx;
			S[L++]=x.charCodeAt(i);
		}
	}
	return S.toString('utf8',0,L);
	
	function popsym(index){
		var s = x[index],
			pos = symbols[s]+1;
		pos = y.indexOf(s,pos>r?pos:r);
		if(pos===-1){pos=n;}
		symbols[s]=pos;
		return pos;
	}
}
