<!DOCTYPE html>
<html lang="en" >
 <head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>variable declaration reset</title>
 </head>
 <body>
  <script>
"use strict";
let s = [1, 2, 2, 3, 4, 4, 5];
for (let i=0; i<7; i+=1) {
    let curr = s[i], prev;
    if (i>0 && (curr===prev)) {
        console.log(i);
    }
    prev = curr;
}
  </script>
 </body>
</html>
