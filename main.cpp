#include <string>
#include <vector>
#include <stdio.h>
#include <mysql/mysql.h>
#include "src/general.h"
#include "src/config.h"
#include "src/mysql_noselect.h"
#include "src/mysql_select.h"
#include "src/help.h"

using namespace std;

int main(int argc, char** argv) {
	config *cnf;
	mysql_noselect *myns;
	mysql_select *mys;
	MYSQL conn;
	
	if (argc >= 2) {
		if ((string)argv[1] == "--version") {
			printf("Quest-MySQL by Hanashi\nVersion 1.0 Beta 2\n");
		} else if ((string)argv[1] == "--help") {
			help *h = new help();
			string he = h->out();
			printf("%s\n", he.c_str());
		} else {
			cnf = new config(argv[1]);
			cnf->readconfig();
			
			mysql_init(&conn);
			
			if (!mysql_real_connect(&conn, cnf->db_host.c_str(), cnf->db_user.c_str(), cnf->db_password.c_str(), NULL, cnf->db_port, NULL, 0)) {
				printf("return {\"ERROR\", \"Konnte keine Verbindung zum Server aufbauen: %s\"}\n", mysql_error(&conn));
			} else {
				if (argc >= 3) {
					if (argc >= 4) {
						if ((string)argv[2] == (string)"1") {
							mys = new mysql_select(conn, (string)argv[3]);
							string ret = mys->execute();
							printf("%s\n", ret.c_str());						
						} else if ((string)argv[2] == (string)"0") {
							myns = new mysql_noselect(conn, (string)argv[3]);
							string ret = myns->execute();
							printf("%s\n", ret.c_str());
						} else {
							printf("return {\"ERROR\", \"False Query-Type\"}\n");
						}
					} else {
						printf("return {\"ERROR\", \"Query is undefined\"}\n");
					}
				} else {
					printf("return {\"ERROR\", \"False Query-Type\"}\n");
				}
			}
			
			mysql_close(&conn);
			delete cnf;
		}
	} else {
		printf("return {\"ERROR\", \"Fehlende Parameter.\"}\n");
	}
	return 0;
}
