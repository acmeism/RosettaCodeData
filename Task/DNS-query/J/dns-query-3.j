const dns = require("dns");

dns.lookup("www.kame.net", {
             all: true
          }, (err, addresses) => {
              if(err) return console.error(err);
              console.log(addresses);
          })
