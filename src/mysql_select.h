class mysql_select : private general {
	public:
		mysql_select(MYSQL conn, std::string query);
		std::string execute();
	private:
		MYSQL conn;
		std::string query;
};
