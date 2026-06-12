function arc_length(radius, angle1, angle2) {
    return (360 - Math.abs(angle2 - angle1)) * Math.PI / 180 * radius;
}

console.log(arc_length(10, 10, 120).toFixed(7));
