var bottles = 99;
var songTemplate  = "{X} bottles of beer on the wall \n" +
                    "{X} bottles of beer \n"+
                    "Take one down, pass it around \n"+
                    "{X-1} bottles of beer on the wall \n";

function song(x, txt) {
  return txt.replace(/\{X\}/gi, x).replace(/\{X-1\}/gi, x-1) + (x > 1 ? song(x-1, txt) : "");
}

console.log(song(bottles, songTemplate));
