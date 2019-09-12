main()

function main() {
	// Canvas
	var canvas = document.querySelector("#canvas2d");
	var TwoDctx = canvas.getContext("2d");

	// Captain Roger
	var img = new Image();
	img.src = "player.png";
	var playerHeight = 110;
	var playerWidth = 92;
	var playerX = (canvas.width - playerWidth) / 2;
	var playerY = (canvas.height - playerHeight) / 2;

	// Mobile Touch
	document.addEventListener("touchstart", touchHandler);
	document.addEventListener("touchmove", touchHandler);
	function touchHandler(e) {
		if (e.touches) {
			playerX = e.touches[0].pageX - canvas.offsetLeft - playerWidth / 2;
			playerY = e.touches[0].pageY - canvas.offsetTop - playerHeight / 2;
			e.preventDefault();
		}
	}

	// Keyboard
	var KeyboardHelper = {
		left: 'ArrowLeft',
		up: 'ArrowUp',
		right: 'ArrowRight',
		down: 'ArrowDown'
	}
	var leftPressed = false;
	var upPressed = false;
	var rightPressed = false;
	var downPressed = false;
	document.addEventListener("keydown", keyDownHandler);
	document.addEventListener("keyup", keyUpHandler);
	function keyDownHandler(e) {
		switch (e.key) {
			case KeyboardHelper.left:
				leftPressed = true;
				break;
			case KeyboardHelper.up:
				upPressed = true;
				break;
			case KeyboardHelper.right:
				rightPressed = true;
				break;
			case KeyboardHelper.down:
				downPressed = true;
				break;
		}
	}
	function keyUpHandler(e) {
		switch (e.key) {
			case KeyboardHelper.left:
				leftPressed = false;
				break;
			case KeyboardHelper.up:
				upPressed = false;
				break;
			case KeyboardHelper.right:
				rightPressed = false;
				break;
			case KeyboardHelper.down:
				downPressed = false;
				break;
		}
	}

	function draw() {
		resizeCanvas()
		TwoDctx.clearRect(0, 0, canvas.width, canvas.height);
		//Keyboard
		if (leftPressed) {
			playerX -= 3
		}
		if (rightPressed) {
			playerX += 3
		}
		if (upPressed) {
			playerY -= 3
		}
		if (downPressed) {
			playerY += 3
		}
		TwoDctx.drawImage(img, playerX, playerY);
		requestAnimationFrame(draw);
	}
	draw();

	function resizeCanvas() {
		height = canvas.clientHeight
		width = canvas.clientWidth
		if (width !== canvas.width || height !== canvas.height) {
			canvas.width = width
			canvas.height = height
		}
	}
}