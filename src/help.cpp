#include <string>
#include "help.h"

using namespace std;

help::help() {
}

string help::out() {
	string output;
	output = "Syntax:\n";
	output.append("program path_to_config.cnf type \"Query\"\n\n");
	output.append("The program is the file named \"quest_mysql\".\n");
	output.append("The config file is in the directory \"conf\".\n\n");
	output.append("It exists two type:\n");
	output.append("Type 0:\tThis type is for a query without a result.\n");
	output.append("Type 1:\tThis type is for a query with a result (SELECT).\n\n");
	output.append("Example:\n");
	output.append("./quest_mysql quest_mysql.cnf 1 \"SELECT * FROM test.test\"");
	return output;
}
