function mysql_escape_string(str)
	str = string.gsub(str, "\\", "")
	str = string.gsub(str, "\"", "\\\"")
	str = string.gsub(str, "'", "\\'")
	str = string.gsub(str, "\r", "")
	str = string.gsub(str, "\n", "")
	str = string.gsub(str, "\0", "")
	return str
end