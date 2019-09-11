main()

function main() {
	var canvas = document.querySelector("#canvas2d");
	var TwoDctx = canvas.getContext("2d");
	var playerHeight = 110;
	var playerWidth = 92;
	var playerX = (canvas.width - playerWidth) / 2;
	var playerY = (canvas.height - playerHeight) / 2;
	var img = new Image();
	img.src = "player.png";

	document.addEventListener("touchstart", touchHandler);
	document.addEventListener("touchmove", touchHandler);
	function touchHandler(e) {
		if (e.touches) {
			playerX = e.touches[0].pageX - canvas.offsetLeft - playerWidth / 2;
			playerY = e.touches[0].pageY - canvas.offsetTop - playerHeight / 2;
			output.innerHTML = "Touch:  <br />" + " x: " + playerX + ", y: " + playerY;
			e.preventDefault();
		}
	}

	function draw() {
		TwoDctx.clearRect(0, 0, canvas.width, canvas.height);

		TwoDctx.drawImage(img, playerX, playerY);
		requestAnimationFrame(draw);
	}
	draw();
}