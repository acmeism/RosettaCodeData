var matrix = [
	[2, -1,  5,  1],
	[3,  2,  2, -6],
	[1,  3,  3, -1],
	[5, -2, -3,  3]
];
var freeTerms = [-3, -32, -47, 49];

var result = cramersRule(matrix,freeTerms);
console.log(result);

/**
 * Compute Cramer's Rule
 * @param  {array} matrix    x,y,z, etc. terms
 * @param  {array} freeTerms
 * @return {array}           solution for x,y,z, etc.
 */
function cramersRule(matrix,freeTerms) {
	var det = detr(matrix),
		returnArray = [],
		i,
		tmpMatrix;

	for(i=0; i < matrix[0].length; i++) {
		var tmpMatrix = insertInTerms(matrix, freeTerms,i)
		returnArray.push(detr(tmpMatrix)/det)
	}
	return returnArray;
}

/**
 * Inserts single dimensional array into
 * @param  {array} matrix multidimensional array to have ins inserted into
 * @param  {array} ins single dimensional array to be inserted vertically into matrix
 * @param  {array} at  zero based offset for ins to be inserted into matrix
 * @return {array}     New multidimensional array with ins replacing the at column in matrix
 */
function insertInTerms(matrix, ins, at) {
	var tmpMatrix = clone(matrix),
		i;
	for(i=0; i < matrix.length; i++) {
		tmpMatrix[i][at] = ins[i];
	}
	return tmpMatrix;
}
/**
 * Compute the determinate of a matrix.  No protection, assumes square matrix
 * function borrowed, and adapted from MIT Licensed numericjs library (www.numericjs.com)
 * @param  {array} m Input Matrix (multidimensional array)
 * @return {number}   result rounded to 2 decimal
 */
function detr(m) {
	var ret = 1,
		k,
		A=clone(m),
		n=m[0].length,
		alpha;

	for(var j =0; j < n-1; j++) {
		k=j;
		for(i=j+1;i<n;i++) { if(Math.abs(A[i][j]) > Math.abs(A[k][j])) { k = i; } }
		if(k !== j) {
		    temp = A[k]; A[k] = A[j]; A[j] = temp;
		    ret *= -1;
		}
		Aj = A[j];
		for(i=j+1;i<n;i++) {
			Ai = A[i];
            alpha = Ai[j]/Aj[j];
            for(k=j+1;k<n-1;k+=2) {
                k1 = k+1;
                Ai[k] -= Aj[k]*alpha;
                Ai[k1] -= Aj[k1]*alpha;
            }
            if(k!==n) { Ai[k] -= Aj[k]*alpha; }
        }
        if(Aj[j] === 0) { return 0; }
        ret *= Aj[j];
	    }
    return Math.round(ret*A[j][j]*100)/100;
}

/**
 * Clone two dimensional Array using ECMAScript 5 map function and EcmaScript 3 slice
 * @param  {array} m Input matrix (multidimensional array) to clone
 * @return {array}   New matrix copy
 */
function clone(m) {
	return m.map(function(a){return a.slice();});
}
