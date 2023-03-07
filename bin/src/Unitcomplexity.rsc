module Unitcomplexity

import IO;
import util::Math;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import Helper;
import Volume;

void tableUnitComplexity(loc projectLoc, set[loc] projectFiles) {
	map[int severity, real perLOC] perSeverity = mapUC(projectLoc, projectFiles);
	
	println("Risk table based on Complexity per Unit (CPU)");
	printTable(perSeverity);
}

map[int severity, real perLOC] mapUC(loc projectLoc, set[loc] projectFiles) {
	project = getASTs(projectLoc, projectFiles);
	map[int severity, int linesOfCode] absSeverity = (1 : 0, 2 : 0, 3 : 0);
	visit(project){
		case a:\method(_,_,_, _, Statement impl):  {
			curMethodLines = readFileLines(a.src);
			amount = countCodeLines(curMethodLines);
			absSeverity[severityCC(impl)]?amount += amount;
		}
	}
	
	real totalLinesOfCode = toReal(countLinesAndCodeLines(projectLoc, projectFiles)[1]);
	
	return (elem : absSeverity[elem] * 100 / totalLinesOfCode | elem <- absSeverity, elem > 0);
}

int unitComplexity(loc projectLoc, set[loc] projectFiles) {
	map[int severity, real perLOC] perSeverity = mapUC(projectLoc, projectFiles);
	
	// Severity (1,2,3,4,5) corresponds to  (★ , ★★ , ★★★ , ★★★★, ★★★★★)
	if (perSeverity[1] > 62.3 || perSeverity[2] > 38.4 || perSeverity[3] > 22.4) return 1;
	if (perSeverity[1] > 39.7 || perSeverity[2] > 22.3 || perSeverity[3] > 9.9) return 2;
	if (perSeverity[1] > 21.6 || perSeverity[2] > 8.1  || perSeverity[3] > 2.5) return 3;
	if (perSeverity[1] > 11.2 || perSeverity[2] > 1.3  || perSeverity[3] > 0.3) return 4;
	return 5;
}

int severityCC(Statement impl) {
	// Severity (0,1,2,3) correspond to (none, moderate, high, very high)
	int res = calcCC(impl);
	
	if (res <= 3) return 0;
	if (res <= 4) return 1;
	if (res <= 6) return 2;
	return 3;
}

// Copied from the paper:  Empirical analysis of the relationship between CC and SLOC in a large corpus of Java methods
int calcCC(Statement impl) {
	int result = 1;
	visit (impl) {
		case \if(_,_) : result += 1;
		case \if(_,_,_) : result += 1;
		case \case(_) : result += 1;
		case \do(_,_) : result += 1;
		case \while(_,_) : result += 1;
		case \for(_,_,_) : result += 1;
		case \for(_,_,_,_) : result += 1;
		case \foreach(_,_,_) : result += 1;
		case \catch(_,_): result += 1;
		case \conditional(_,_,_): result += 1;
		case infix(_,"&&",_) : result += 1;
		case infix(_,"||",_) : result += 1;
	}
	return result;
}