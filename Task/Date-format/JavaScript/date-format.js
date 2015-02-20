var now = new Date(),
    weekdays = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
    months   = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
    fmt1 = now.getFullYear() + '-' + (1 + now.getMonth()) + '-' + now.getDate(),
    fmt2 = weekdays[now.getDay()] + ', ' + months[now.getMonth()] + ' ' + now.getDate() + ', ' + now.getFullYear();
console.log(fmt1);
console.log(fmt2);
