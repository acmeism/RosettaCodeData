window.onload = function(){	
    var list = [];
    var j = 0;	
    for(var c = 1; c <= 200; c++)
        for(var b = 1; b <= c; b++)
            for(var a = 1; a <= b; a++)
	        if(gcd(gcd(a, b), c) == 1 && isHeron(heronArea(a, b, c)))							
		    list[j++] = new Array(a, b, c, a + b + c, heronArea(a, b, c));
    sort(list);	
    document.write("<h2>Primitive Heronian triangles with sides up to 200: " + list.length + "</h2><h3>First ten when ordered by increasing area, then perimeter:</h3><table><tr><th>Sides</th><th>Perimeter</th><th>Area</th><tr>");
    for(var i = 0; i < 10; i++)
	document.write("<tr><td>" + list[i][0] + " x " + list[i][1] + " x " + list[i][2] + "</td><td>" + list[i][3] + "</td><td>" + list[i][4] + "</td></tr>");
    document.write("</table><h3>Area = 210</h3><table><tr><th>Sides</th><th>Perimeter</th><th>Area</th><tr>");
    for(var i = 0; i < list.length; i++)
	if(list[i][4] == 210)
	    document.write("<tr><td>" + list[i][0] + " x " + list[i][1] + " x " + list[i][2] + "</td><td>" + list[i][3] + "</td><td>" + list[i][4] + "</td></tr>");    		
    function heronArea(a, b, c){
	var s = (a + b + c)/ 2;
	return Math.sqrt(s *(s -a)*(s - b)*(s - c));		
    }	
    function isHeron(h){
        return h % 1 == 0 && h > 0;
    }	
    function gcd(a, b){
	var leftover = 1, dividend = a > b ? a : b, divisor = a > b ? b : a;		
	while(leftover != 0){
	    leftover = dividend % divisor;
	    if(leftover > 0){
		dividend = divisor;
		divisor = leftover;
	    }
	}		
	return divisor;
    }	
    function sort(list){
	var swapped = true;
	var temp = [];
	while(swapped){
	    swapped = false;
	    for(var i = 1; i < list.length; i++){
		if(list[i][4] < list[i - 1][4] || list[i][4] == list[i - 1][4] && list[i][3] < list[i - 1][3]){
		    temp = list[i];
		    list[i] = list[i - 1];
		    list[i - 1] = temp;
		    swapped = true;
		}				
	    }			
	}
    }
}
