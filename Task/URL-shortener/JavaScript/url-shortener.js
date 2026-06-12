#!/usr/bin/env node

var mapping = new Map();

// assure num. above 36 ^ 9
var base = 101559956668416;
// 36 ^ (10 -> length of ID)
var ceil = 3656158440062976;
// these are calculated as:
//   l = desired length
//   198 > l > 1
//     -> above 198 ends up as Infinity
//     -> below 1 ends up as 0, as one would except (pun intended)
//   base = 36 ^ (l - 1)
//   ceil = 36 ^ l

require('http').createServer((req, res) => {
	if(req.url === '/') {
		// only accept POST requests as JSON to /
		if(req.method !== 'POST' || req.headers['content-type'] !== 'application/json') {
			// 400 Bad Request
			res.writeHead(400);
			return res.end();
		}

		var random = (Math.random() * (ceil - base) + base).toString(36);
		req.on('data', chunk => {
			// trusting input json to be valid, e.g., '{"long":"https://www.example.com/"}'
			var body = JSON.parse(chunk.toString());
			mapping.set(random.substring(0, 10), body.long); // substr gets the integer part
		});

		// 201 Created
		res.writeHead(201);
		return res.end('http://localhost:8080/' + random.substring(0, 10));
	}

	var url = mapping.get(req.url.substring(1));
	if(url) {
		// 302 Found
		res.writeHead(302, { 'Location': url });
		return res.end();
	}

	// 404 Not Found
	res.writeHead(404);
	res.end();
}).listen(8080);
