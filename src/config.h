class config : private general {
	public:
		config(std::string filename);
		int readconfig();
		std::string db_host;
		std::string db_user;
		std::string db_password;
		int db_port;
		std::string log_level;
		std::string log_file;
	private:
		std::string filename;
		std::string db_name;
};
