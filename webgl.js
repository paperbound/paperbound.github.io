main();

function main() {
	const canvas = document.querySelector("#glCanvas");
	const gl = canvas.getContext("webgl");

	if (!gl) {
		alert("no machine or browser support, sorry");
		return
	}

	gl.clearColor(0.0, 0.0, 0.0, 1.0);
	gl.clear(gl.COLOR_BUFFER_BIT);
}