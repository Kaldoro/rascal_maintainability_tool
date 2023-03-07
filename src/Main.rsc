module Main

import MaintainabilityReport;
import IO;

void main() {
	loc project = |project://core|;
	println("Report:");
	maintainabilityReport(project, true);
}