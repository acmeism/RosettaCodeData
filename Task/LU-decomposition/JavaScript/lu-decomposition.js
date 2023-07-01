const mult=(a, b)=>{
  let res = new Array(a.length);
  for (let r = 0; r < a.length; ++r) {
    res[r] = new Array(b[0].length);
    for (let c = 0; c < b[0].length; ++c) {
      res[r][c] = 0;
      for (let i = 0; i < a[0].length; ++i)
        res[r][c] += a[r][i] * b[i][c];
    }
  }
  return res;
}

const lu = (mat) => {
    let lower = [],upper = [],n=mat.length;;
    for(let i=0;i<n;i++){
        lower.push([]);
        upper.push([]);
        for(let j=0;j<n;j++){
            lower[i].push(0);
            upper[i].push(0);
        }
    }
    for (let i = 0; i < n; i++) {
        for (let k = i; k < n; k++){
            let sum = 0;
            for (let j = 0; j < i; j++)
                sum += (lower[i][j] * upper[j][k]);
            upper[i][k] = mat[i][k] - sum;
        }
        for (let k = i; k < n; k++) {
            if (i == k)
                lower[i][i] = 1;
            else{
                let sum = 0;
                for (let j = 0; j < i; j++)
                    sum += (lower[k][j] * upper[j][i]);
                lower[k][i] = (mat[k][i] - sum) / upper[i][i];
            }
        }
    }
    return [lower,upper];
}

const pivot = (m) =>{
    let n = m.length;
    let id = [];
    for(let i=0;i<n;i++){
        id.push([]);
        for(let j=0;j<n;j++){
            if(i===j)
                id[i].push(1);
            else
                id[i].push(0);
        }
    }
    for (let i = 0; i < n; i++) {
        let maxm = m[i][i];
        let row = i;
        for (let j = i; j < n; j++)
            if (m[j][i] > maxm) {
                maxm = m[j][i];
                row = j;
            }
        if (i != row) {
            let tmp = id[i];
            id[i] = id[row];
            id[row] = tmp;
        }
    }
    return id;
}

const luDecomposition=(A)=>{
    const P = pivot(A);
    A = mult(P,A);
    return [...lu(A),P];
}
