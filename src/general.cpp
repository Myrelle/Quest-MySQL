#include <string>
#include <vector>
#include <string>
#include <string.h>
#include <sstream>
#include "general.h"

using namespace std;

vector<string> general::split(string str, string delim) {
    vector<string> splitted;
    char* part;
    
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
