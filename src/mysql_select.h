class mysql_select : private general {
	public:
		mysql_select(MYSQL conn, std::string query, FILE * logfile, int loglevel);
		std::string execute();
	private:
		MYSQL conn;
		std::string query;
		FILE * log_file;
		int log_level;
};
