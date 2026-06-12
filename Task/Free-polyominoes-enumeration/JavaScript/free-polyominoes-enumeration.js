const width = window.innerWidth;
const height = window.innerHeight;
const p = Math.floor(width/140);
const verticalScrollbarWidth = 15;
const elementSize = 1;

let maxHeight;
let cellSize, xSpacing, ySpacing, xOffset, yOffset;
let test_poly, starting_poly;
let stored_polys;
let maxPolyLength;
let jsonData;
let polysFound;
let typeSelected, orderSelected, modeSelected, orderValue;

let canvas = document.createElement('canvas');
canvas.id = "myCanvas";
canvas.width = width;
canvas.height = height;
let parentDiv = document.getElementById("div_polys");
parentDiv.appendChild(canvas);
canvas.style.backgroundColor = "lightblue";
let ctx = canvas.getContext("2d"); // Get the 2D rendering context

let buttonBack = document.createElement("button");
buttonBack.innerHTML = "<b>Back</b>";
buttonBack.id = "back_button_id";
buttonBack.classList.add("back_button_class");
buttonBack.style.fontSize = (7*p).toString() + "px";
buttonBack.style.position = "absolute";
buttonBack.style.top = (3*p).toString() + "px";
buttonBack.style.right = (5*p).toString() + "px";
buttonBack.style.display = "none";
buttonBack.addEventListener("click", function() {
  canvas.height = height;
  document.getElementById("div_polys").style.display = "none";
  document.getElementById("div_menu").style.display = "block";
  window.scrollTo(0,0);
  stored_polys = null;
  jsonData = null;
});
document.getElementById("div_polys").style.display = "block";
parentDiv.appendChild(buttonBack);

let buttonBack2 = buttonBack.cloneNode(true);
buttonBack2.addEventListener("click", function() {
  canvas.height = height;
  document.getElementById("div_polys").style.display = "none";
  document.getElementById("div_menu").style.display = "block";
  window.scrollTo(0,0);
  stored_polys = null;
  jsonData = null;
});
parentDiv.appendChild(buttonBack2);

//hide the info bubble when the user taps outside it on Safari browser
document.body.addEventListener("click", function(event) {
    const popUps = document.querySelectorAll(".pop-up");
    popUps.forEach(popUp => {
      if (popUp.style.display === "block") {
        popUp.style.display = "none";
      }
    });
});

function iOS() {
  return [
    'iPad Simulator',
    'iPhone Simulator',
    'iPod Simulator',
    'iPad',
    'iPhone',
    'iPod'
  ].includes(navigator.platform)
  // iPad on iOS 13 detection
  || (navigator.userAgent.includes("Mac") && "ontouchend" in document)
}

function showPolyDiv() {
  document.getElementById("div_menu").style.display = "none";
  document.getElementById("div_polys").style.display = "block";
  window.scrollTo(0,0);
  buttonBack.style.display = "none";
  buttonBack2.style.display = "none";
  ctx.clearRect(0, 0, canvas.width, canvas.height);
  typeSelected = document.querySelector('input[name="type"]:checked').value;
  orderSelected = document.querySelector('input[name="order"]:checked').value;
  orderValue = parseInt(orderSelected);
  modeSelected = document.querySelector('input[name="mode"]:checked').value;

  if (iOS()) {
    maxHeight = 16383;
  } else {
    maxHeight = 65535;
  }

  fetchPolys();
}

function fetchPolys() {
  if (orderValue === 1) modeSelected = "1"; // So that it doesn't create the order-one polyomino because it cannot start from the previous order.
  if (modeSelected === "2") {
    orderSelected--;
  }
  cellSize = (14/(orderValue*0.35))*p; // size of each cell of a polyomino when displayed on screen
  xSpacing = cellSize; ySpacing = cellSize; // horizontal and vertical spacing between polyominoes when they are displayed on screen
  xOffset = xSpacing; yOffset = 20*p; // spaces between the polys displayed
  canvas.width = width;
  canvas.height = maxHeight; // max height
  maxPolyLength = 0;
  stored_polys = new Set(); // because it is set to null after returning to the menu screen

  fetch(typeSelected + orderSelected + ".json")
    .then(response => response.json())
    .then(json => {
      jsonData = json;
      if (modeSelected === "1") displayPolys();
      else if (modeSelected === "2") createPolys();
      else console.log("no mode selected");
    })
    .catch(error => console.log(error));
}

function createJson(order, type, multitude, polys) {
  let content =
  {
    order:  order,
    type: type,
    multitude: multitude,
    polys:  polys
  };

  // ********** Save a JSON file with the FileSaver library (large files, more options) ************
  let jsonString = JSON.stringify(content);
  let blob = new Blob([jsonString], { type: "application/json;charset=utf-8" });
  saveAs(blob, type + order.toString()+".json");
}

function createPolys() {
  polysFound = 0;
  for (let i = 0; i < jsonData.polys.length; i++) {
    starting_poly = jsonData.polys[i];
    nextOrderPolys(starting_poly);
  }
  if (yOffset + 3*ySpacing > maxHeight) { // max height
    //canvas.height = maxHeight;
  } else {
    let imageData = ctx.getImageData(0, 0, canvas.width, yOffset + maxPolyLength*cellSize + ySpacing);
    canvas.height = yOffset + maxPolyLength*cellSize + ySpacing;
    ctx.putImageData(imageData, 0, 0);
  }
  ctx.fillStyle = "black";
  ctx.font = (5*p).toString() + "px Verdana";
  ctx.fillText(jsonData.type + " polyominoes of order " + orderValue + ": ", 6*p, 10*p);
  ctx.fillText(polysFound, 6*p, 17*p);
  console.log(jsonData.type + " polyominoes of order " + orderValue + " found: " + polysFound + ". Max canvas height: " + maxHeight);
  let stored_polys_array = new Uint8Array(elementSize);
  stored_polys_array = parseArray(stored_polys);
  buttonBack2.style.top = (canvas.height - 15*p).toString() + "px";
  buttonBack.style.display = "block";
  if (canvas.height > height) {
    buttonBack2.style.display = "block";
  }
  createJson(jsonData.order + 1, jsonData.type, polysFound, stored_polys_array);
}

function displayPolys() {
  for (let i = 0; i < jsonData.polys.length; i++) {
    starting_poly = jsonData.polys[i];
    showPoly(starting_poly);
  }
  if (yOffset + 3*ySpacing > maxHeight) { // max height
    //canvas.height = maxHeight;
  } else {
    let imageData = ctx.getImageData(0, 0, canvas.width, yOffset + maxPolyLength*cellSize + ySpacing);
    canvas.height = yOffset + maxPolyLength*cellSize + ySpacing;
    ctx.putImageData(imageData, 0, 0);
  }
  ctx.fillStyle = "black";
  ctx.font = (5*p).toString() + "px Verdana";
  ctx.fillText(jsonData.type + " polyominoes of order " + jsonData.order + ": ", 6*p, 10*p);
  ctx.fillText(jsonData.polys.length, 6*p, 17*p);
  console.log(jsonData.type + " polyominoes of order " + jsonData.order + ": " + jsonData.polys.length + ". Max canvas height: " + maxHeight);
  buttonBack2.style.top = (canvas.height - 15*p).toString() + "px";
  buttonBack.style.display = "block";
  if (canvas.height > height) {
    buttonBack2.style.display = "block";
  }
}

function parseArray(stored) {
  // gets a Set object of strings and returns an Array object of arrays
  let arrayOfArrays = new Uint8Array(elementSize);
  arrayOfArrays = [];
  let arrayOfStrings = Array.from(stored);
  for (let i = 0; i < arrayOfStrings.length; i++) {
    arrayOfArrays.push(JSON.parse(arrayOfStrings[i]));
  }
  return arrayOfArrays;
}

function nextOrderPolys(poly) {
  let poly1, poly2 = new Uint8Array(elementSize);
  poly1 = addBlanksAroundPoly(poly);

  for (let y = 0; y < poly1.length; y++) {
    for (let x = 0; x < poly1[y].length; x++) {
      if (poly1[y][x] === 0) {
        try {
          if (poly1[y+1][x] === 1) {
            checkPoly(poly1, y, x);
          }
        } catch (error) { }
        try {
          if (poly1[y][x-1] === 1) {
            checkPoly(poly1, y, x);
          }
        } catch (error) { }
        try {
          if (poly1[y-1][x] === 1) {
            checkPoly(poly1, y, x);
          }
        } catch (error) { }
        try {
          if (poly1[y][x+1] === 1) {
            checkPoly(poly1, y, x);
          }
        } catch (error) { }
      }
    }
  }

}

function checkPoly(poly, i, j) {
  let poly2, trunc_poly, rot_poly = new Uint8Array(elementSize);
  let r;
  poly2 = poly.map(subArray => subArray.slice()); //copies 2D array poly 1 to poly2
  poly2[i][j] = 1; //2D array poly1 is not affected by this operation
  trunc_poly = truncatePoly(poly2);

  if (jsonData.type === "fixed") {
    if (stored_polys.has(JSON.stringify(trunc_poly))) { // there is an identical poly in the Set
      return;
    }
  } else if (jsonData.type === "one-sided") {
    if (stored_polys.has(JSON.stringify(trunc_poly))) { // there is an identical poly in the Set
      return;
    }
    rot_poly = trunc_poly;
    for (r = 0; r < 3; r++) { // rotate the candidate poly 3 times and check if there is an identical poly in the Set
      rot_poly = rotateLeftPoly(rot_poly);
      if (stored_polys.has(JSON.stringify(rot_poly))) { // there is an identical poly in the Set
        return;
      }
    }
  } else if (jsonData.type === "free") {
    if (stored_polys.has(JSON.stringify(trunc_poly))) { // there is an identical poly in the Set
      return;
    }
    rot_poly = trunc_poly;
    for (r = 0; r < 3; r++) { // rotate the candidate poly 3 times and check if there is an identical poly in the Set
      rot_poly = rotateLeftPoly(rot_poly);
      if (stored_polys.has(JSON.stringify(rot_poly))) { // there is an identical poly in the Set
        return;
      }
    }
    rot_poly = mirrorXPoly(rot_poly); // mirror candidate poly and check again
    if (stored_polys.has(JSON.stringify(rot_poly))) { // there is an identical poly in the Set
      return;
    }
    for (r = 0; r < 3; r++) { // rotate the candidate poly 3 times and check if there is an identical poly in the Set
      rot_poly = rotateLeftPoly(rot_poly);
      if (stored_polys.has(JSON.stringify(rot_poly))) { // there is an identical poly in the Set
        return;
      }
    }
  }

  stored_polys.add(JSON.stringify(trunc_poly)); // The candidate poly is new. Store it in the Set
  polysFound++;
  showPoly(trunc_poly);
}

function showPoly(poly) {
  ctx.lineWidth = 0.5*p;

  //Check if the rightmost end of the new poly will be displayed outside the screen width and if yes, display the new poly in the next row
  if (xOffset + poly[0].length*cellSize + verticalScrollbarWidth + ySpacing > width) {
    xOffset = xSpacing;
    yOffset += maxPolyLength*cellSize + ySpacing;
    maxPolyLength = 0;
  }

  //display the new poly
  let randomColor = "rgb("+(Math.random()*215+40)+","+(Math.random()*215+40)+","+(Math.random()*215+40)+")";
  for (let y = 0; y < poly.length; y++) {
    for (let x = 0; x < poly[y].length; x++) {
      ctx.beginPath();
      if (poly[y][x] === 1) {
        ctx.fillStyle = randomColor;
        ctx.strokeStyle = "black";
      } else {
        //ctx.fillStyle = "white";
        ctx.fillStyle = "transparent";
        ctx.strokeStyle = "transparent";
      }
      ctx.rect(xOffset + x*cellSize, yOffset + y*cellSize, cellSize, cellSize);
      ctx.fill();
      ctx.stroke();
    }
  }

  xOffset += poly[0].length*cellSize + xSpacing; // set the left margin of the new poly to be displayed
  //sets the next row for the new poly to be displayed as the maximum height from the previous row
  if (poly.length > maxPolyLength) {
    maxPolyLength = poly.length;
  }
}

function truncatePoly(poly) {
  let x, y;
  let new_poly, transposedArray = new Uint8Array(elementSize);
  //truncate rows
  new_poly = [];
  for (y = 0; y < poly.length; y++) {
    for (x = 0; x < poly[y].length; x++) {
      if (poly[y][x] === 1) {
        new_poly.push(poly[y]); //copy this row to a new array
        break;
      }
    }
  }
  //reverse rows and columns of the trancated array
  transposedArray = new_poly[0].map((col, i) => new_poly.map(row => row[i]));
  //truncate rows of the new array, so that we have trancated both rows and columns
  new_poly = [];
  for (y = 0; y < transposedArray.length; y++) {
    for (x = 0; x < transposedArray[y].length; x++) {
      if (transposedArray[y][x] === 1) {
        new_poly.push(transposedArray[y]); //copy this row to a new array
        break;
      }
    }
  }
  //reverse rows and columns of the trancated array again, so that the new array has the same orientation with the original
  transposedArray = new_poly[0].map((col, i) => new_poly.map(row => row[i]));
  return transposedArray;
}

function rotateLeftPoly(poly) {
  let transposedArray = new Uint8Array(elementSize);
  //reverse rows and columns of the original array
  transposedArray = poly[0].map((col, i) => poly.map(row => row[i]));
  //mirrors the transposed array
  return transposedArray.slice().reverse();
}

function mirrorXPoly(poly) {
  let mirr_poly = new Uint8Array(elementSize);
  mirr_poly = poly.slice().reverse();
  return mirr_poly;
}

function mirrorYPoly(poly) {
  let mirr_poly = new Uint8Array(elementSize);
  mirr_poly = poly.map(subArr => subArr.slice().reverse());
  return mirr_poly;
}

function addBlanksAroundPoly(poly) {
  //creates a loop of blank cells around a poly, so that new filled cells can be placed in the next poly order
  let newLengthX = poly[0].length + 2;
  let newLengthY = poly.length + 2;
  let new_poly = new Uint8Array(elementSize);
  new_poly = Array.from({length: newLengthY}, () => Array(newLengthX).fill(0)); //creates a 2D array filled with zeros
  for (let y = 0; y < poly.length; y++) {
    for (let x = 0; x < poly[y].length; x++) {
      new_poly[y+1][x+1] = poly[y][x];
    }
  }
  return new_poly;
}
