#include <string>
#include <mysql/mysql.h>
#include <vector>
#include "general.h"
#include "mysql_noselect.h"

using namespace std;

mysql_noselect::mysql_noselect(MYSQL conn, string query, FILE * logfile, int loglevel) {
	this->conn = conn;
	this->query = query;
	this->log_file = logfile;
	this->log_level = loglevel;
}

string mysql_noselect::execute() {
	int calls;
	
	calls = mysql_query(&this->conn, this->query.c_str());
	
	if (calls == 0) {
		if (this->log_level >= 3)
			this->write_to_log("mysql_noselect.cpp", "Query was succesfully", this->log_file);
		return "return {\"SUCCESS\"}";
	} else {
		if (this->log_level >= 1)
			this->write_to_log("mysql_noselect.cpp", "Error: " + (string)mysql_error(&this->conn), this->log_file);
		return "return {\"ERROR\", \"" + (string)mysql_error(&this->conn) + "\"}";
	}
}
