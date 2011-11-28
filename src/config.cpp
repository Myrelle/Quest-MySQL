#include <string>
#include <vector>
#include <stdio.h>
#include <fstream>
#include <stdlib.h>
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
		printf("ERROR: This file does not exist.\n");
		exit(1);
	} else {
		while (cnf.getline(line, 100)) {
			splitted = this->split(line, "=");
			if(splitted.size() < 2) {
			}
			if (splitted[0] == "DB_HOST") {
				this->db_host = splitted[1];
			} else if (splitted[0] == "DB_USER") {
				this->db_user = splitted[1];
			} else if (splitted[0] == "DB_PASSWORD") {
				this->db_password = splitted[1];
			} else if (splitted[0] == "DB_PORT") {
				this->db_port = atoi(splitted[1].c_str());
			}
		}
    }
	
	free(line);
	
	return 0;
}
