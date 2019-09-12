fetch("https://sourceforge.net")
    .then(function(response) {
        return response.text();
     })
    .then(function(content) {
        console.log(content)
    })
    .catch(function (err){
         console.error(err)
    });
