
"use strict";

console.log("VV");
console.log(["argsv", process.argv]);
console.log("^^");

var peg = require('../pegjs/packages/pegjs/lib/peg.js');

var passes = [];

var grammar = require('fs').readFileSync("/build/SpriteGrammar.pegjs").toString();
var ast = peg.parser.parse(grammar);
var session = new peg.compiler.Session({grammar, passes});
var parser = peg.compiler.compile(ast, session);
parser = peg.generate(grammar);

var fileToCompile = process.argv[2];

var parsed = parser.parse(require('fs').readFileSync("/workfolder/" + fileToCompile).toString());
var root = {
    "NodeType": "root",
    "Children": parsed
};

require('fs').writeFileSync('/workfolder/build/structure.js', JSON.stringify(root, null, 2));

