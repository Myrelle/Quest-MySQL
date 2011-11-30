#include <string>
#include <vector>
#include <stdio.h>
#include <mysql/mysql.h>
#include "src/general.h"
#include "src/config.h"
#include "src/query.h"
#include "src/help.h"

using namespace std;

int main(int argc, char** argv) {
	config *cnf;
	general *gen;
	query *myq;
	MYSQL conn;
	FILE *logfile;
	
	if (argc >= 2) {
		if ((string)argv[1] == "--version") {
			printf("Quest-MySQL by Hanashi\nVersion 1.1\n");
		} else if ((string)argv[1] == "--help") {
			help *h = new help();
			string he = h->out();
			printf("%s\n", he.c_str());
		} else {
			cnf = new config(argv[1]);
			cnf->readconfig();
			
			logfile = fopen(cnf->log_file.c_str(), "a");
			
			mysql_init(&conn);
			
			if (!mysql_real_connect(&conn, cnf->db_host.c_str(), cnf->db_user.c_str(), cnf->db_password.c_str(), NULL, cnf->db_port, NULL, 0)) {
				if (cnf->log_level >= 1)
					gen->write_to_log("main.cpp", "Konnte keine Verbindung zum Server aufbauen: " + (string)mysql_error(&conn), logfile);
				printf("return {\"ERROR\", \"Konnte keine Verbindung zum Server aufbauen: %s\"}\n", mysql_error(&conn));
			} else {
				if (argc >= 3) {
					if (cnf->log_level >= 2)
						gen->write_to_log("main.cpp", "Query: " + (string)argv[2], logfile);
					myq = new query(conn, (string)argv[2], logfile, cnf->log_level);
					string ret = myq->execute();
					printf("%s\n", ret.c_str());
				} else {
					if (cnf->log_level >= 2)
						gen->write_to_log("main.cpp", "False Query-Type", logfile);
					printf("return {\"ERROR\", \"False Query-Type\"}\n");
				}
				mysql_close(&conn);
			}
			
			delete cnf;
			fclose(logfile);
		}
	} else {
		printf("return {\"ERROR\", \"Fehlende Parameter.\"}\n");
	}
	return 0;
}
