function getImageData(url, callback) {
	var img = document.createElement('img');
	var canvas = document.createElement('canvas');

	img.onload = function () {
		canvas.width = img.width;
		canvas.height = img.height;
		var ctx = canvas.getContext('2d');
		ctx.drawImage(img, 0, 0);
		callback(ctx.getImageData(0, 0, img.width, img.height));
	};

	img.src = url;
}

function compare(firstImage, secondImage, callback) {
	getImageData(firstImage, function (img1) {
		getImageData(secondImage, function (img2) {
			if (img1.width !== img2.width || img1.height != img2.height) {
				callback(NaN);
				return;
			}

			var diff = 0;
			
			for (var i = 0; i < img1.data.length / 4; i++) {
				diff += Math.abs(img1.data[4 * i + 0] - img2.data[4 * i + 0]) / 255;
				diff += Math.abs(img1.data[4 * i + 1] - img2.data[4 * i + 1]) / 255;
				diff += Math.abs(img1.data[4 * i + 2] - img2.data[4 * i + 2]) / 255;
			}

			callback(100 * diff / (img1.width * img1.height * 3));
		});
	});
}

compare('Lenna50.jpg', 'Lenna100.jpg', function (result) {
	console.log(result);
});
