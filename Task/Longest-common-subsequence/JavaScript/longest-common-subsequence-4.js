	var t=i;
	while(i>-1&&j>-1){
		switch(c[i][j]){
			default:i--,j--;
				continue;
			case (i&&c[i-1][j]):
				if(t!==i){lcs.unshift(x.substring(i+1,t+1));}
				t=--i;
				continue;
			case (j&&c[i][j-1]): j--;
				if(t!==i){lcs.unshift(x.substring(i+1,t+1));}
				t=i;
		}
	}
	if(t!==i){lcs.unshift(x.substring(i+1,t+1));}
