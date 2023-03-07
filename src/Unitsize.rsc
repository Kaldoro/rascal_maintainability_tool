module Unitsize

import IO;
import util::Math;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import Helper;
import List;


real unitSize (loc projectLoc, set[loc] projectFiles) {
	map[int severity, real perLOC] perSeverity = mapUS(projectLoc, projectFiles);
	
	// Severity (1,2,3,4,5) corresponds to (★ , ★★ , ★★★ , ★★★★, ★★★★★)
	if (perSeverity[1] > 54.0 || perSeverity[2] > 43.0 || perSeverity[3] > 24.2) return 1.0;
	if (perSeverity[1] > 35.4  || perSeverity[2] > 25.0   || perSeverity[3] > 14.0)  return 2.0;
	if (perSeverity[1] > 27.6 || perSeverity[2] > 16.1 || perSeverity[3] > 7.0)  return 3.0;
	if (perSeverity[1] > 12.3   || perSeverity[2] > 6.1  || perSeverity[3] > 0.8)   return 4.0; 
	return 5.0;
}

int severityUS(int linesOfCodeMethod) {
	// Severity (0,1,2,3) correspond to (none, moderate, high, very high)

	if (linesOfCodeMethod <= 24) return 0;
	if (linesOfCodeMethod <= 31) return 1;
	if (linesOfCodeMethod <= 48) return 2;
	return 3;
}

void tableUnitSize(loc projectLoc, set[loc] projectFiles) {
	map[int severity, real perLOC] perSeverity = mapUS(projectLoc, projectFiles);
	
	println("Risk table based on UnitSize (MethodSize)");
	printTable(perSeverity);
	
}

tuple[int, int] countLinesAndCodeLines(loc projectLoc, set[loc] projectFiles){
	strs = projectToListString(projectLoc, projectFiles);
	return <size(strs), countCodeLines(strs)>;
}

// Current limitations for code blocks: 
//  will assume that we are not in a code block if another code block is closed on the same line: "/* */ /* test ...".
//  will assume that /* and */ are not used in a string. (but using them inside a line comment is fine)
//  will assume that the code does not use "/*/" to initiate a comment block.
int countCodeLines(list[str] lines){
	int total = 0;
	bool inBlockComment = false;
	for (line <- lines){
		if (!inBlockComment){
			if(/^\s*$/ := line){ // whitespace
				continue;
			}
			else if(/^\/\/.*/ := line){ // <//> comments
				continue;
			}
			else if(/\/\*/ := line){ // start of /* comment
				if (/(\S+)(.*)(\/\*)|(\*\/)(.*)(\S+)/ := line){ // any non-whitespace before the /* or after the */ means this line counts as code
					total += 1;
				}
				inBlockComment = true;
			}
			else total += 1;
		}
		if(inBlockComment){ // This isnt <else if> because you might leave the blockComment on the same line as it started.
			if(/\*\// := line){
				inBlockComment = false;
			}
		}
	}
	return total;
}

map[int severity, real perLOC] mapUS(loc projectLoc, set[loc] projectFiles) {
	real totalLinesOfCode = toReal(countLinesAndCodeLines(projectLoc, projectFiles)[1]);

	map[int severity, int linesOfCode] absSeverity = (1 : 0, 2 : 0, 3 : 0);
	asts = getASTs(projectLoc, projectFiles);
	visit(asts){
		case a:\method(_,_,_, _, _):  {
			curMethod = readFileLines(a.src);
			amount = countCodeLines(curMethod);
			absSeverity[severityUS(amount)]?amount += amount;
		}
	}
	
	return (elem : absSeverity[elem] * 100 / totalLinesOfCode | elem <- absSeverity, elem > 0);
}