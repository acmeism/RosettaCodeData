interface XYCoords  {
    x : number;
    y : number;
}

const inside = ( cp1 : XYCoords, cp2 : XYCoords, p : XYCoords) : boolean => {
    return (cp2.x-cp1.x)*(p.y-cp1.y) > (cp2.y-cp1.y)*(p.x-cp1.x);
};

const intersection = ( cp1 : XYCoords ,cp2 : XYCoords ,s : XYCoords, e : XYCoords ) : XYCoords => {
    const dc = {
	x:  cp1.x - cp2.x,
	y : cp1.y - cp2.y
	 },
    dp = { x: s.x - e.x,
	   y : s.y - e.y
	 },
    n1 = cp1.x * cp2.y - cp1.y * cp2.x,
    n2 = s.x * e.y - s.y * e.x,
    n3 = 1.0 / (dc.x * dp.y - dc.y * dp.x);
    return { x : (n1*dp.x - n2*dc.x) * n3,
	     y : (n1*dp.y - n2*dc.y) * n3
	   };
};

export const sutherland_hodgman = ( subjectPolygon : Array<XYCoords>,
				   clipPolygon : Array<XYCoords> ) : Array<XYCoords> => {

    let cp1 : XYCoords = clipPolygon[clipPolygon.length-1];
    let cp2 : XYCoords;
    let s : XYCoords;
    let e : XYCoords;

    let outputList : Array<XYCoords> = subjectPolygon;

    for( var j in clipPolygon ) {
        cp2 = clipPolygon[j];
        var inputList = outputList;
        outputList = [];
        s = inputList[inputList.length - 1]; // last on the input list
        for (var i in inputList) {
	    e = inputList[i];
	    if (inside(cp1,cp2,e)) {
                if (!inside(cp1,cp2,s)) {
		    outputList.push(intersection(cp1,cp2,s,e));
                }
                outputList.push(e);
	    }
	    else if (inside(cp1,cp2,s)) {
                outputList.push(intersection(cp1,cp2,s,e));
	    }
	    s = e;
        }
        cp1 = cp2;
    }
    return outputList
}
