module GatherTestFiles

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import String;

set[loc] gatherTestFiles(loc projectLocation) {
	M3 model = createM3FromEclipseProject(projectLocation);
	set[loc] projectFiles = {};
	for(tuple[loc fst, loc snd] item <- model.declarations) {
		str decType = item.fst.scheme; 
		if(decType == "java+compilationUnit") {
			str path = item.fst.path;
			list[str] splittedPath = split("/", path);
			if(splittedPath[2] == "test" && splittedPath[3] == "java") {
				projectFiles += item.fst;
			}
		}
	};
	return projectFiles;
}