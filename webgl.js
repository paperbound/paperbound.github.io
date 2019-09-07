var cubeRotation = 0.0;

main();

function main() {
	const canvas = document.querySelector('#glcanvas');
	resize(canvas);

	const gl = canvas.getContext('webgl') || canvas.getContext('experimental-webgl');

	// WebGL Support
	if (!gl) {
		alert('Unable to initialize WebGL. Your browser or machine may not support it.');
		return;
	}

	// Vertex Shader

	const vsSource = `
	attribute vec4 aVertexPosition;
	attribute vec4 aVertexColor;

	uniform mat4 uModelViewMatrix;
	uniform mat4 uProjectionMatrix;

	varying lowp vec4 vColor;

	void main(void) {
		gl_Position = uProjectionMatrix * uModelViewMatrix * aVertexPosition;
		vColor = aVertexColor;
	}
	`;

	// Fragment Shader

	const fsSource = `
	 varying lowp vec4 vColor;

	 void main(void) {
		gl_FragColor = vColor;
	 }
  `;

	const shaderProgram = createShaderProgram(gl, vsSource, fsSource);

	const programInfo = {
		program: shaderProgram,
		attribLocations: {
			vertexPosition: gl.getAttribLocation(shaderProgram, 'aVertexPosition'),
			vertexColor: gl.getAttribLocation(shaderProgram, 'aVertexColor'),
		},
		uniformLocations: {
			projectionMatrix: gl.getUniformLocation(shaderProgram, 'uProjectionMatrix'),
			modelViewMatrix: gl.getUniformLocation(shaderProgram, 'uModelViewMatrix'),
		},
	};

	const buffers = initCubeBuffers(gl);

	var then = 0;

	// Animation
	function render(now) {
		now *= 0.001;	// converting ms to s
		const deltaTime = now - then;
		then = now;

		drawScene(gl, programInfo, buffers, deltaTime);

		requestAnimationFrame(render);
	}
	requestAnimationFrame(render);
}

/*
* Cube Buffer Object
*/
function initCubeBuffers(gl) {
	// Vertices of the Cube
	const positions = [
		// Front face
		-1.0, -1.0, 1.0,
		1.0, -1.0, 1.0,
		1.0, 1.0, 1.0,
		-1.0, 1.0, 1.0,

		// Back face
		-1.0, -1.0, -1.0,
		-1.0, 1.0, -1.0,
		1.0, 1.0, -1.0,
		1.0, -1.0, -1.0,

		// Top face
		-1.0, 1.0, -1.0,
		-1.0, 1.0, 1.0,
		1.0, 1.0, 1.0,
		1.0, 1.0, -1.0,

		// Bottom face
		-1.0, -1.0, -1.0,
		1.0, -1.0, -1.0,
		1.0, -1.0, 1.0,
		-1.0, -1.0, 1.0,

		// Right face
		1.0, -1.0, -1.0,
		1.0, 1.0, -1.0,
		1.0, 1.0, 1.0,
		1.0, -1.0, 1.0,

		// Left face
		-1.0, -1.0, -1.0,
		-1.0, -1.0, 1.0,
		-1.0, 1.0, 1.0,
		-1.0, 1.0, -1.0,
	];

	const positionBuffer = gl.createBuffer();
	gl.bindBuffer(gl.ARRAY_BUFFER, positionBuffer);
	gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(positions), gl.STATIC_DRAW);

	// Colors for the Vertices
	const faceColors = [
		[1.0, 1.0, 1.0, 1.0],	 // Front face: white
		[1.0, 0.0, 0.0, 1.0],	 // Back face: red
		[0.0, 1.0, 0.0, 1.0],	 // Top face: green
		[0.0, 0.0, 1.0, 1.0],	 // Bottom face: blue
		[1.0, 1.0, 0.0, 1.0],	 // Right face: yellow
		[1.0, 0.0, 1.0, 1.0],	 // Left face: purple
	];

	var colors = [];
	for (var j = 0; j < faceColors.length; ++j) {
		const c = faceColors[j];
		// Repeat each color four times for the four vertices of the face
		colors = colors.concat(c, c, c, c);
	}

	const colorBuffer = gl.createBuffer();
	gl.bindBuffer(gl.ARRAY_BUFFER, colorBuffer);
	gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(colors), gl.STATIC_DRAW);

	// Each face as 2 triangles -> Element Array
	const indices = [
		0, 1, 2, 0, 2, 3,		// front
		4, 5, 6, 4, 6, 7,		// back
		8, 9, 10, 8, 10, 11,	// top
		12, 13, 14, 12, 14, 15,	// bottom
		16, 17, 18, 16, 18, 19,	// right
		20, 21, 22, 20, 22, 23,	// left
	];

	const indexBuffer = gl.createBuffer();
	gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, indexBuffer);

	gl.bufferData(gl.ELEMENT_ARRAY_BUFFER,
		new Uint16Array(indices), gl.STATIC_DRAW);

	return {
		position: positionBuffer,
		color: colorBuffer,
		indices: indexBuffer,
	};
}

/*
* Draw the Scene
*/
function drawScene(gl, programInfo, buffers, deltaTime) {
	resize(gl.canvas);

	gl.clearColor(0.0, 0.0, 0.0, 1.0);	// Clear to black, fully opaque
	gl.clearDepth(1.0);					// Clear everything
	gl.enable(gl.DEPTH_TEST);			// Enable depth testing (read more)
	gl.depthFunc(gl.LEQUAL);			// Near things obscure far things (read more)

	// Clear the canvas before we start drawing on it.

	gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);

	// Prespective Matrix
	// 45° Field of View
	// b/w 0.1 and 100

	const fieldOfView = Math.PI / 4;
	const aspect = gl.canvas.clientWidth / gl.canvas.clientHeight;
	const zNear = 0.1;
	const zFar = 100.0;
	const projectionMatrix = mat4.create();

	// gl-matrix
	mat4.perspective(projectionMatrix,
		fieldOfView,
		aspect,
		zNear,
		zFar);

	// Setting to "Identity Point" (read more)
	const modelViewMatrix = mat4.create();

	mat4.translate(
		modelViewMatrix,
		modelViewMatrix,
		[0.0, 0.0, -6.0]
	);
	mat4.rotate(
		modelViewMatrix,
		modelViewMatrix,
		cubeRotation,
		[0, 0, 1]
	);
	mat4.rotate(modelViewMatrix,
		modelViewMatrix,
		cubeRotation * .7,
		[0, 1, 0]
	);

	// Tell WebGL how to pull out the positions from the position
	// buffer into the vertexPosition attribute
	{
		const numComponents = 3;
		const type = gl.FLOAT;
		const normalize = false;
		const stride = 0;
		const offset = 0;
		gl.bindBuffer(gl.ARRAY_BUFFER, buffers.position);
		gl.vertexAttribPointer(
			programInfo.attribLocations.vertexPosition,
			numComponents,
			type,
			normalize,
			stride,
			offset);
		gl.enableVertexAttribArray(
			programInfo.attribLocations.vertexPosition);
	}

	// Tell WebGL how to pull out the colors from the color buffer
	// into the vertexColor attribute.
	{
		const numComponents = 4;
		const type = gl.FLOAT;
		const normalize = false;
		const stride = 0;
		const offset = 0;
		gl.bindBuffer(gl.ARRAY_BUFFER, buffers.color);
		gl.vertexAttribPointer(
			programInfo.attribLocations.vertexColor,
			numComponents,
			type,
			normalize,
			stride,
			offset);
		gl.enableVertexAttribArray(
			programInfo.attribLocations.vertexColor);
	}

	gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, buffers.indices);

	gl.useProgram(programInfo.program);

	gl.uniformMatrix4fv(
		programInfo.uniformLocations.projectionMatrix,
		false,
		projectionMatrix);
	gl.uniformMatrix4fv(
		programInfo.uniformLocations.modelViewMatrix,
		false,
		modelViewMatrix);

	{
		const vertexCount = 36;
		const type = gl.UNSIGNED_SHORT;
		const offset = 0;
		gl.drawElements(gl.TRIANGLES, vertexCount, type, offset);
	}

	// Update the rotation for the next draw

	cubeRotation += deltaTime;
}

/*
* Create Shader Program
*/
function createShaderProgram(gl, vsSource, fsSource) {
	const vertexShader = loadShader(gl, gl.VERTEX_SHADER, vsSource);
	const fragmentShader = loadShader(gl, gl.FRAGMENT_SHADER, fsSource);

	const shaderProgram = gl.createProgram();
	gl.attachShader(shaderProgram, vertexShader);
	gl.attachShader(shaderProgram, fragmentShader);
	gl.linkProgram(shaderProgram);

	if (!gl.getProgramParameter(shaderProgram, gl.LINK_STATUS)) {
		alert('Unable to initialize the shader program: ' + gl.getProgramInfoLog(shaderProgram));
		return null;
	}

	return shaderProgram;
}

/*
* Create and Compile Shader
*/
function loadShader(gl, type, source) {
	const shader = gl.createShader(type);
	gl.shaderSource(shader, source);
	gl.compileShader(shader);

	if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) {
		alert('An error occurred compiling the shaders: ' + gl.getShaderInfoLog(shader));
		gl.deleteShader(shader);
		return null;
	}

	return shader;
}

function resize(canvas) {
	// Lookup the size the browser is displaying the canvas.
	var displayWidth = canvas.clientWidth;
	var displayHeight = canvas.clientHeight;

	// Check if the canvas is not the same size.
	if (canvas.width != displayWidth ||
		canvas.height != displayHeight) {

		// Make the canvas the same size
		canvas.width = displayWidth;
		canvas.height = displayHeight;
	}
}