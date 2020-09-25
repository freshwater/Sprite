
"use strict";

var peg = require('./pegjs/peg.js');
var passes = [];

var grammar = require('fs').readFileSync("grammar.pegjs").toString();
var ast = peg.parser.parse(grammar);
var session = new peg.compiler.Session({grammar, passes});
var parser = peg.compiler.compile(ast, session);
parser = peg.generate(grammar);

var fileToCompile = process.argv[2];
// console.warn("compinht", fileToCompile);

var parsed = parser.parse(require('fs').readFileSync("/io/" + fileToCompile).toString());
require('fs').writeFileSync('/io/bin/structure.js', JSON.stringify(parsed, null, 2));

