class mysql_noselect : private general {
	public:
		mysql_noselect(MYSQL conn, std::string query, FILE * logfile, int loglevel);
		std::string execute();
	private:
		MYSQL conn;
		std::string query;
		FILE * log_file;
		int log_level;
};
