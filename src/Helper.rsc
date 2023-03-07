module Helper

import IO;
import Set;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import lang::java::m3::Core;
import lang::java::m3::AST;
import util::Math;
import Exception;
import String;

list[Declaration] getASTs(loc projectLoc, set[loc] projectFiles){
	m3x = createM3FromEclipseProject(projectLoc);
	list[Declaration] asts = [];
	for(file <- projectFiles) {
		projectFile = sourceFile(file,m3x);
		asts += createAstFromFile(projectFile, true);
	}
	return asts;	
}


list[str] projectToListString (loc projectLoc, set[loc] projectFiles) {
	list[str] output = [];
	m3x = createM3FromEclipseProject(projectLoc);
	for(file <- projectFiles) {
		projectFile = sourceFile(file,m3x);
		output += readFileLines(projectFile);
	}
	return output;
}

loc sourceFile(loc logical, M3 model) {
  if (loc f <- model.declarations[logical]) {
    return f;
  }
  throw NoSuchElement(logical);
}


str convertRating(int rating) {
	if(rating == 1) return "☆";
	if(rating == 2) return "☆☆";
	if(rating == 3) return "☆☆☆";
	if(rating == 4) return "☆☆☆☆";
	if(rating == 5) return "☆☆☆☆☆";
	return "ERROR";
}

void printTable(map[int severity, real _] severity) {
	println("-----------------------------------");
	println("| Moderate |   High   | Very High |");
	println("-----------------------------------");
	buildNiceLine(severity);
	println("-----------------------------------");
}

void buildNiceLine(map[int severity, real _] severity) {
	list[int] spaces = [4,4,4];
	
	if(severity[1] >= 10) spaces[0] -= 1;
	if(severity[2] >= 10) spaces[1] -= 1;
	if(severity[3] >= 10) spaces[2] -= 1;
	
	for(int n <- [1..4]) {
		int valueX = round(severity[n]);
		print("|    <valueX>%");
		for(int _ <- [0..spaces[n-1]]) print(" ");
	}
	print(" |");
	println ("");

}