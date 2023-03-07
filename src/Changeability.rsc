module Changeability

import Duplication;
import Unitcomplexity;
import util::Math;

int changeability(loc projectLoc, set[loc] projectFiles) {
	c = unitComplexity(projectLoc, projectFiles);
	real duplicationPercent = duplicationPercentage(projectLoc, projectFiles);
	int d = duplicationRatingFromPercentage(duplicationPercent);
	res = round((d+c) / toReal(2));
	return res;
}

int changeability(int c, int d) {
	return  round((d+c) / toReal(2));
}

real changeabilityReal(int c, int d) {
	return  (d+c) / toReal(2);
}