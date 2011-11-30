class general {
public:
    std::vector<std::string> split(std::string str, std::string delim);
    std::string itoa(int num);
    std::string charlength(std::string str);
	void write_to_log(std::string file, std::string logmsg, FILE * logfile);
private:
	std::string checkzeichenlaenge(std::string str);
};
