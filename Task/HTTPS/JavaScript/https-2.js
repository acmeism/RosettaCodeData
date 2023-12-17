fetch("https://sourceforge.net").then(function (response) {
    return response.text();
}).then(function (body) {
    return body;
});
