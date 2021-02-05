
// dependencies
#include <iostream>
#include <fstream>
#include <map>
#include <string>
using namespace std;

// Global instructions mapping
map <string, string> mapping = {
	{"adci","69"},{"adca","6d"},{"adcz","65"}
};

int main( int argc, char** argv){

	fstream inputFile; 			// input file ptr
	fstream outputFile; 		// output file ptr

	inputFile.open("program.txt", ios::in); 		// open input & output
	outputFile.open("program.v", ios::out); 	// files...

	// Useful replacement strings
	const string pre1 = "`include \"board.v\"\nmodule program;\n";
	const string pre2 = "wire sync, rw;\nreg clr;\nboard dut(clr,sync,rw);\n";

	// Check if input file exists
	if(!inputFile){
		cout << "error: No input file found";
		return -1;
	}

	// write required headers to output file
	string ch1, ch2;
	outputFile << pre1 + pre2 << "\ninitial\nbegin\n";
	outputFile << "\t#1 clr<=1;\n\t#4 clr<=0;\n";

	// read the source and write to output file
	inputFile >> ch1;
	while( !inputFile.eof() ){

		cout << ch1 << ' ';
		outputFile << "\tdut.rm.store[16'h" << ch1 << "] <= ";

		inputFile >> ch2;
		cout << ch2 << endl;

		if(ch2[0]<= '9' && ch2[0] >= '0')
			outputFile << "8'h" << ch2 << ";\n";
		else if(ch2[0] <= 'z' && ch2[0] >= 'a')
			outputFile << "8'h" << mapping[ch2] << ";\n";

		inputFile >> ch1;
	}

	// required ending
	outputFile << "\n\t#100 $finish;\n";
	outputFile << "end\nendmodule";

	// close the files
	inputFile.close();
	outputFile.close();

	return 0;
}
