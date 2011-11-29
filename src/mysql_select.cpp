#include <string>
#include <mysql/mysql.h>
#include <vector>
#include <exception>
#include "mysql_select.h"

using namespace std;

mysql_select::mysql_select(MYSQL conn, string query) {
	this->conn = conn;
	this->query = query.c_str();
}

string mysql_select::execute() {
	MYSQL_RES *result;
	MYSQL_ROW row;
	int rows;
	int fields;
	int calls;
	int nr;
	string output;
	
	calls = mysql_query(&this->conn, this->query.c_str());
	
	if (calls == 0) {
		try {
			result = mysql_store_result(&this->conn);
			fields = mysql_num_fields(result);
			rows = mysql_num_rows(result);
			
			if (rows == 0) {
				return "return {\"ERROR\", \"Query-Result is empty\"}";
			} else {
				nr = 0;
				output = "return {";
				while ((row = mysql_fetch_row(result))) {
					nr++;
					/*for (int i = 0; i < fields; i++) {
						output.append((string)row[i] + "^");
					}
					if (nr != rows) {
						output.append("\n");
					}*/
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
				return output;
			}
		} catch (exception& e) {
			return "return {\"ERROR\", \"" + (string)e.what() + "\"}";
		}
	} else {
		return "return {\"ERROR\", \"" + (string)mysql_error(&this->conn) + "\"}";
	}
}
