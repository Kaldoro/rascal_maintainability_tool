module Duplication

import Helper;
import List;
import util::Math;
import Set;
import String;

int duplication(loc projectLocation, set[loc] projectFiles){
	real duplicationPercent = duplicationPercentage(projectLocation, projectFiles);
	return duplicationRatingFromPercentage(duplicationPercent);
}

int duplicationRatingFromPercentage (real dupPer) {
	// Severity (1,2,3,4,5) corresponds to  (★ , ★★ , ★★★ , ★★★★, ★★★★★)
	if (dupPer < 5.5)  return 5;
    if (dupPer < 10.3)  return 4;
	if (dupPer < 16.4) return 3;
	if (dupPer < 21.6) return 2;
	return 1;
}

list[str] trimAndRemoveEmptyLinesAndComments(list[str] lines){
	list[str] out = [];
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
					out += trim(line);
				}
				inBlockComment = true;
			}
			else out += trim(line);
		}
		if(inBlockComment){ // This isnt <else if> because you might leave the blockComment on the same line as it started.
			if(/\*\// := line){
				inBlockComment = false;
			}
		}
	}
	return out;
}

real duplicationPercentage(loc projectLoc, set[loc] projectFiles) {
	list[str] prj = projectToListString(projectLoc, projectFiles);
	
	prj = trimAndRemoveEmptyLinesAndComments(prj);
	
	int len = size(prj);
	
	//Set containing line numbers of the duplicates
	set[int] dupped = {};
	
	map[list[str] codeLines , rel [int,int] codeSections] tracker = ();
	
	for(int n <- [0..len]) {
		int checkLength = 6;
		if(n + checkLength < len) {
			list[str] toCheck = getXElementsFrom(n,checkLength,prj);
			
			if(toCheck in tracker) {
				 //The lines of the original location shoud also be added as duplicated now
				 rel[int,int] tempList = tracker[toCheck];
				 for(<x,y> <- tempList) {
				 	for(int i <- [x..y]) {
				 		dupped += i;
				 	}
				 }
				 
				 //The lines of the found duplication should be added to the set
				 for(int i <- [n..n+checkLength]) {
				 	dupped += i;
				 }
			}
			
			tracker[toCheck]?{<n, n+checkLength>} += <n,n+checkLength>;
		}
	};
	
	amountOfTruth = size(dupped);
	//return toReal(size(dupped));
	return (amountOfTruth * 100 / toReal(len));
}

list[str] getXElementsFrom(int index, int size, list[str] l) {
	list[str] res = [];
	for(n <- [0..size]) {
		res += l[index+n];
	};
	return res;
}