  // Node 5.4.1 tested implementation (ES6)
"use strict";

let arr = [4, 9, 0, 3, 1, 5];
let isSorted = true;
while (isSorted){
    for (let i = 0; i< arr.length - 1;i++){
            if (arr[i] > arr[i + 1])
             {
                let temp = arr[i];
                arr[i] = arr[i + 1];
                arr[i+1] = temp;
                isSorted = true;
             }
    }

    if (!isSorted)
        break;

    isSorted = false;

    for (let j = arr.length - 1; j > 0; j--){
            if (arr[j-1] > arr[j])
             {
                let temp = arr[j];
                arr[j] = arr[j - 1];
                arr[j - 1] = temp;
                isSorted = true;
             }
    }
}
console.log(arr);

}
