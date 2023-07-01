"use strict";

// Doors can be open or closed.
const open = "O";
const closed = "C";

// There are 100 doors in a row that are all initially closed.
const doorsCount = 100;
const doors = [];
for (let i = 0; i < doorsCount; doors[i] = closed, i++);

// You make 100 passes by the doors, visiting every door and toggle the door (if
// the door is closed, open it; if it is open, close it), according to the rules
// of the task.
for (let pass = 1; pass <= doorsCount; pass++)
    for (let i = pass - 1; i < doorsCount; i += pass)
        doors[i] = doors[i] == open ? closed : open;

// Answer the question: what state are the doors in after the last pass?
doors.forEach((v, i) =>
    console.log(`Doors ${i + 1} are ${v == open ? 'opened' : 'closed'}.`));

// Which are open, which are closed?
let openKeyList = [];
let closedKeyList = [];
for (let door of doors.entries())
    if (door[1] == open)
        openKeyList.push(door[0] + 1);
    else
        closedKeyList.push(door[0] + 1);
console.log("These are open doors: " + openKeyList.join(", ") + ".");
console.log("These are closed doors: " + closedKeyList.join(", ") + ".");

// Assert:
const expected = [];
for (let i = 1; i * i <= doorsCount; expected.push(i * i), i++);
if (openKeyList.every((v, i) => v === expected[i]))
    console.log("The task is solved.")
else
    throw "These aren't the doors you're looking for.";
