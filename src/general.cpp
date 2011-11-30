#include <string>
#include <vector>
#include <string>
#include <string.h>
#include <sstream>
#include <stdio.h>
#include "general.h"

using namespace std;

vector<string> general::split(string str, string delim) {
    vector<string> splitted;
    char* part = new char[100];
    
    part = strtok((char*)str.c_str(), delim.c_str());
    while(part != NULL) {
        splitted.push_back(part);
        part = strtok(NULL, delim.c_str());
    }
    
    return splitted;
}

string general::itoa(int num) {
    ostringstream num_tmp;
    
    if (num_tmp << num) {
    }
    
    return num_tmp.str();
}

string general::charlength(string str) {
    if (strlen(str.c_str()) == 1)
        str = "0" + str;
    
    return str;
}

string general::checkzeichenlaenge(string str) {
	if (strlen(str.c_str()) == 1)
		str = "0" + str;
	return str;
}

void general::write_to_log(string file, string logmsg, FILE * logfile) {
	time_t tstamp;
	tm *cur;
	tstamp = time(0);
	cur = localtime(&tstamp);
	string timestamp;
	
	timestamp = this->itoa(cur->tm_year + 1900) + "-" + this->checkzeichenlaenge(this->itoa(cur->tm_mon + 1)) + "-" + this->checkzeichenlaenge(this->itoa(cur->tm_mday)) +  " " + this->checkzeichenlaenge(this->itoa(cur->tm_hour)) + ":" + this->checkzeichenlaenge(this->itoa(cur->tm_min)) + ":" + this->checkzeichenlaenge(this->itoa(cur->tm_sec));
	fprintf(logfile, "[%s] %s: %s\n", timestamp.c_str(), file.c_str(), logmsg.c_str());
}
