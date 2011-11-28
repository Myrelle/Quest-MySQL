#include <string>
#include <mysql/mysql.h>
#include <vector>
#include "general.h"
#include "mysql_select.h"

using namespace std;

mysql_select::mysql_select(MYSQL conn, string query) {
	this->conn = conn;
	this->query = this->escape(query.c_str());
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
		result = mysql_store_result(&this->conn);
		fields = mysql_num_fields(result);
		rows = mysql_num_rows(result);
		
		if (rows == 0) {
			return "ERROR^Query-Result is empty";
		} else {
			nr = 0;
			while ((row = mysql_fetch_row(result))) {
				nr++;
				for (int i = 0; i < fields; i++) {
					if (i == (fields - 1)) {
						output += (string)row[i];
					} else {
						output += (string)row[i] + "^";
					}
				}
				if (nr != rows) {
					output += "\n";
				}
			}
			return output;
		}
	} else {
		return "ERROR^" + (string)mysql_error(&this->conn);
	}
}
