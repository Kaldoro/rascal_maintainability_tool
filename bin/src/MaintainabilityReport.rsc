module MaintainabilityReport

import IO;
import Helper;
import Unitsize;
import Unitcomplexity;
import Duplication;
import Volume;
import Analysability;
import Testability;
import Changeability;
import Maintainability;
import util::Math;
import Set;
import GatherTestFiles;

void maintainabilityReport(loc projectLocation, bool detailed) {
	set[loc] testFiles = gatherTestFiles(projectLocation);
	
	tuple[int totalLines, int linesOfCode] linesResult = countLinesAndCodeLines(projectLocation, testFiles);
	int vol = volumeRating(linesResult.linesOfCode);
	real unitS = unitSize(projectLocation, testFiles);
	int unitC = unitComplexity(projectLocation, testFiles);
	real duplicationPercent = duplicationPercentage(projectLocation, testFiles);
	int dup = duplicationRatingFromPercentage(duplicationPercent);
	
	real analyseA = analysabilityReal(vol, dup, unitS);
	real testA = testabilityReal(unitC, unitS);
	real changeA = changeabilityReal(unitC, dup);
	
	int maintainA = maintainability(analyseA, testA, changeA);
	
	println ("Maintainability: <convertRating(maintainA)> ");
	println ("");
	println ("Analysability: <convertRating(round(analyseA))> ");
	println ("Changeability: <convertRating(round(changeA))> ");
	println ("Testability: <convertRating(round(testA))> ");
	println ("");
	println ("Volume: <convertRating(vol)>");
	println ("Complexity per Unit: <convertRating(unitC)> ");
	println ("Duplication: <convertRating(dup)> ");
	println ("Unit Size: <unitS> ");
	println ("");
	
	if(detailed) {
		println ("Duplication in project: <duplicationPercent>%");
		println ("Lines in project: <linesResult.totalLines>");
		println ("Lines of code: <linesResult.linesOfCode>"); 
		println ("File count: <size(testFiles)>");
		println ("");
		
		tableUnitComplexity(projectLocation, testFiles);
		println ("");
		
		tableUnitSize(projectLocation, testFiles);
		println ("");
	}
}