var
 n = 100,
 doors = [n],
 step,
 idx;
// now, start opening and closing
for (step = 1; step <= n; step += 1)
 for (idx = step; idx <= n; idx += step)
 // toggle state of door
 doors[idx] = !doors[idx];

// find out which doors are open
var open = doors.reduce(function(open, val, idx) {
    if (val) {
        open.push(idx);
    }
    return open;
}, []);
document.write("These doors are open: " + open.join(', '));
