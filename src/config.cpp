#include <string>
#include <vector>
#include <stdio.h>
#include <fstream>
#include <stdlib.h>
#include <exception>
#include "general.h"
#include "config.h"

using namespace std;

config::config(string filename) {
	this->filename = filename;
}

int config::readconfig() {
	vector<string> splitted;
	char* line = new char[100];
	
	ifstream cnf(this->filename.c_str(), ios::in);
    
	if (!cnf) {
		fprintf(stderr, "return {\"ERROR\", \"The file %s does not exist.\"}\n", this->filename.c_str());
		exit(1);
	} else {
		while (cnf.getline(line, 100)) {
			try {
				splitted = this->split(line, "=");
				if(splitted.size() < 2) {
				} else {
					if (splitted[0] == "DB_HOST") {
						this->db_host = splitted[1];
					} else if (splitted[0] == "DB_USER") {
						this->db_user = splitted[1];
					} else if (splitted[0] == "DB_PASSWORD") {
						this->db_password = splitted[1];
					} else if (splitted[0] == "DB_PORT") {
						this->db_port = atoi(splitted[1].c_str());
					} else if (splitted[0] == "LOGGING_LEVEL") {
						this->log_level = atoi(splitted[1].c_str());
					} else if (splitted[0] == "LOG_FILE") {
						this->log_file = splitted[1];
					}
				}
			} catch (exception& e) {
				fprintf(stderr, "return {\"ERROR\", \"%s\"}\n", (char*)e.what());
			}
		}
    }
	
	free(line);
	
	return 0;
}
