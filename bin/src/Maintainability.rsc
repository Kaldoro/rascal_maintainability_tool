module Maintainability

import Analysability;
import Changeability;
import Testability;
import util::Math;

int maintainability(loc projectLoc, set[loc] projectFiles) {
	a = analysability(projectLoc, projectFiles);
	c = changeability(projectLoc, projectFiles);
	t = testability  (projectLoc, projectFiles);
	res = round((a+c+t) / toReal(3));
	return res;
}

int maintainability(int a, int c,  int t) {
	return round((a+c+t) / toReal(3));
}

int maintainability(real a, real c, real t) {
	return round((a+c+t) / toReal(3));
}