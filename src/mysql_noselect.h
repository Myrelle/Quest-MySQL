class mysql_noselect : private general {
	public:
		mysql_noselect(MYSQL conn, std::string query);
		std::string execute();
	private:
		MYSQL conn;
		std::string query;
};
