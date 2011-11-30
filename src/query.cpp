#include <string>
#include <mysql/mysql.h>
#include <vector>
#include <exception>
#include <stdio.h>
#include "general.h"
#include "query.h"

using namespace std;

query::query(MYSQL conn, string query, FILE * logfile, int loglevel) {
	this->conn = conn;
	this->query_str = query.c_str();
	this->log_file = logfile;
	this->log_level = loglevel;
}

string query::execute() {
	MYSQL_RES *result;
	MYSQL_ROW row;
	int rows;
	int fields;
	int calls;
	int nr;
	string output;
	
	calls = mysql_query(&this->conn, this->query_str.c_str());
	
	if (calls == 0) {
		try {
			result = mysql_store_result(&this->conn);
			if (result == NULL) {
				if (this->log_level >= 3)
					this->write_to_log("query.cpp", "Query was succesfully", this->log_file);
				return "return {\"SUCCESS\"}";
			} else {
				fields = mysql_num_fields(result);
				rows = mysql_num_rows(result);
				
				nr = 0;
				output = "return {";
				while ((row = mysql_fetch_row(result))) {
					nr++;
					output.append("{");
					for (int i = 0; i < fields; i++) {
						output.append("\"" + (string)row[i] + "\"");
						if ((i + 1) != fields)
							output.append(", ");
					}
					output.append("}");
					if (nr != rows)
						output.append(", ");
				}
				output.append("}");
				if (this->log_level >= 3)
					this->write_to_log("query.cpp", "Query returns: " + output, this->log_file);
				return output;
			}
		} catch (exception& e) {
			if (this->log_level >= 1)
				this->write_to_log("query.cpp", "Error: " + (string)e.what(), this->log_file);
			return "return {\"ERROR\", \"" + (string)e.what() + "\"}";
		}
	} else {
		if (this->log_level >= 1)
			this->write_to_log("query.cpp", "Error: " + (string)mysql_error(&this->conn), this->log_file);
		return "return {\"ERROR\", \"" + (string)mysql_error(&this->conn) + "\"}";
	}
}