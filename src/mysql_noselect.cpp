#include <string>
#include <mysql/mysql.h>
#include <vector>
#include "mysql_noselect.h"

using namespace std;

mysql_noselect::mysql_noselect(MYSQL conn, string query) {
	this->conn = conn;
	this->query = query;
}

string mysql_noselect::execute() {
	int calls;
	
	calls = mysql_query(&this->conn, this->query.c_str());
	
	if (calls == 0) {
		return "return {\"SUCCESS\"}";
	} else {
		return "return {\"ERROR\", \"" + (string)mysql_error(&this->conn) + "\"}";
	}
}
