// Line breaks are in HTML

var i, ages = [];

for (i = 0; i < 100; i++) {
    ages.push(Math.floor(Math.random() * (141)));
}

countSort(ages, 0, 140);

for (i = 0; i < 100; i++) {
    document.write(ages[i] + "<br />");
}
