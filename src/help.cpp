#include <string>
#include "help.h"

using namespace std;

help::help() {
}

string help::out() {
	string output;
	output = "Syntax:\n";
	output += "program path_to_config.cnf type \"Query\"\n\n";
	output += "The program is the file named \"quest_mysql\".\n";
	output += "The config file is in the directory \"conf\".\n\n";
	output += "It exists two type:\n";
	output += "Type 0:\tThis type is for a query without a result.\n";
	output += "Type 1:\tThis type is for a query with a result (SELECT).\n\n";
	output += "Example:\n";
	output += "./quest_mysql quest_mysql.cnf 1 \"SELECT * FROM test.test\"";
	return output;
}
