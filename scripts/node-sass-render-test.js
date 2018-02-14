#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const sass = require('node-sass');

const file = path.resolve(__dirname, '..', 'src', 'main.scss');
const outFile = path.resolve(__dirname, 'test.css');

sass.render({ file }, (err, result) => {
	fs.open(outFile, 'w', (err, fd) => {
		fs.write(fd, result.css, (err, res) => {});
	});
});
