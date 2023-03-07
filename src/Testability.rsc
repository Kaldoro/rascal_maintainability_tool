module Testability

import Unitsize;
import Unitcomplexity;
import util::Math;

int testability(loc projectLoc, set[loc] projectFiles) {
	c = unitComplexity(projectLoc, projectFiles);
	u = unitSize(projectLoc, projectFiles);
	res =  round((c+u) / toReal(2));
	return res;
}

int testability(int c, int u) {
	return round((c+u) / toReal(2));
}
real testabilityReal(int c, real u) {
	return (c+u) / toReal(2);
}