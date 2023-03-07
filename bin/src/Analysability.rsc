module Analysability

import Volume;
import Duplication;
import Unitsize;
import util::Math;

int analysability(loc projectLoc, set[loc] projectFiles) {
	v = volume(projectLoc, projectFiles);
	d = duplication(projectLoc, projectFiles);
	u = unitSize(projectLoc, projectFiles);
	res = round((v+d+u) / toReal(3));
	return res;
}

int analysability(int v, int d, int u) {
	return round((v+d+u) / toReal(3));
}
real analysabilityReal(int v, int d, real u) {
	return (v+d+u) / toReal(3);
}