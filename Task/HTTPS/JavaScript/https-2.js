require("https").get("https://sourceforge.net", function (resp) {
    let body = "";
    resp.on("data", function (chunk) {
        body += chunk;
    });
    resp.on("end", function () {
        console.log(body);
    });
}).on("error", function (err) {
    console.error("Error: " + err.message);
});
