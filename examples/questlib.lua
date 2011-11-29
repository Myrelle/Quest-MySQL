MYSQL_BIN = "/home/game/share/quest_mysql"
MYSQL_CONFIG = "/home/game/share/quest_mysql.cnf"

function dofile (filename)
	local f = assert(loadfile(filename))
	return f()
end

function mysql_query_select(query)
	i = 1
	
	math.randomseed(os.time())
	random = math.random()

	n = "/tmp/mysql_"..random..pc.get_vid()

	os.execute (MYSQL_BIN.." \""..MYSQL_CONFIG.."\" 1 \""..query.."\" > " .. n)

	local ret = dofile(n)
	os.remove (n)
	
	return ret
end

function mysql_query(query)
	math.randomseed(os.time())
	random = math.random()

	n = "/tmp/mysql_"..random..pc.get_vid()

	os.execute (MYSQL_BIN.." \""..MYSQL_CONFIG.."\" 0 \""..query.."\" > " .. n)
	
	local ret = dofile(n)
	os.remove(n)
	if ret[1] == "SUCCESS" then
		return true
	else
		return ret[2]
	end
end