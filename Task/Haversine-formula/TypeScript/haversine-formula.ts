let radians = function (degree: number) {

    // degrees to radians
    let rad: number = degree * Math.PI / 180;

    return rad;
}

export const haversine = (lat1: number, lon1: number, lat2: number, lon2: number) => {

    // var dlat: number, dlon: number, a: number, c: number, R: number;
    let dlat, dlon, a, c, R: number;

    R = 6372.8; // km
    dlat = radians(lat2 - lat1);
    dlon = radians(lon2 - lon1);
    lat1 = radians(lat1);
    lat2 = radians(lat2);
    a = Math.sin(dlat / 2) * Math.sin(dlat / 2) + Math.sin(dlon / 2) * Math.sin(dlon / 2) * Math.cos(lat1) * Math.cos(lat2)
    c = 2 * Math.asin(Math.sqrt(a));
    return R * c;
}

console.log("Distance:" + haversine(36.12, -86.67, 33.94, -118.40));
