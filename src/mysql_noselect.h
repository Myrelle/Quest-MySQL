class mysql_noselect {
	public:
		mysql_noselect(MYSQL conn, std::string query);
		std::string execute();
	private:
		MYSQL conn;
		std::string query;
};
