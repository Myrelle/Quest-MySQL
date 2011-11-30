class query : private general {
	public:
		query(MYSQL conn, std::string query, FILE * logfile, int loglevel);
		std::string execute();
	private:
		MYSQL conn;
		std::string query_str;
		FILE * log_file;
		int log_level;
};
