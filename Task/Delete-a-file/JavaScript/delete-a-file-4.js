const fs = require('fs');
fs.unlink('myfile.txt', ()=>{
  console.log("Done!");
})
