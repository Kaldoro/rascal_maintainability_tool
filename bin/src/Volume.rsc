module Volume

import Helper;
import List;

int volume(loc projectLocation, set[loc] projectFiles){
	tuple[int totalLines, int linesOfCode] linesResult = countLinesAndCodeLines(projectLocation, projectFiles);
	return volumeRating(linesResult.linesOfCode);
}

int volumeRating(int totalCodeLines){
	kcodeLines = totalCodeLines / 1000;
	// Severity (1,2,3,4,5) corresponds to  (★ , ★★ , ★★★ , ★★★★, ★★★★★)
	if (kcodeLines < 66) return 5;
	else if (kcodeLines < 246) return 4;
	else if (kcodeLines < 665) return 3;
	else if (kcodeLines < 1310) return 2;
	else return 1;
}

tuple[int, int] countLinesAndCodeLines(loc projectLocation, set[loc] projectFiles){
	strs = projectToListString(projectLocation, projectFiles);
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