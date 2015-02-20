var _ = require('underscore');
function findIndex(input){
	var len = input.length;
	var maxSeqEndingHere = _.range(len).map(function(){return 1;});
	for(var i=0; i<len; i++)
		for(var j=i-1;j>=0;j--)
			if(input[i] > input[j] && maxSeqEndingHere[j] >= maxSeqEndingHere[i])
				maxSeqEndingHere[i] = maxSeqEndingHere[j]+1;
	return maxSeqEndingHere;
}

function findSequence(input, result){
	var maxValue = Math.max.apply(null, result);
	var maxIndex = result.indexOf(Math.max.apply(Math, result));
	var output = [];
	output.push(input[maxIndex]);
	for(var i = maxIndex ; i >= 0; i--){
		if(maxValue==0)break;
		if(input[maxIndex] > input[i]  && result[i] == maxValue-1){
			output.push(input[i]);
			maxValue--;
		}
	}
	output.reverse();
	return output;
}


var x = [0, 7, 8, 4, 12, 2, 10, 6, 14, 1, 9, 5, 13, 3, 11, 7, 15];
var y = [3, 2, 6, 4, 5, 1];

var result = findIndex(x);
var final = findSequence(x, result);
console.log(final);

var result1 = findIndex(y);
var final1 = findSequence(y, result1);
console.log(final1);
