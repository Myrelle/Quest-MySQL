MYSQL_BIN = "/home/game/share/quest_mysql"
MYSQL_CONFIG = "/home/game/share/quest_mysql.cnf"

function Split(str, delim, maxNb)
    if string.find(str, delim) == nil then
        return { str }
    end
    if maxNb == nil or maxNb < 1 then
        maxNb = 0
    end
    local result = {}
    local pat = "(.-)" .. delim .. "()"
    local nb = 0
    local lastPos
    for part, pos in string.gfind(str, pat) do
        nb = nb + 1
        result[nb] = part
        lastPos = pos
        if nb == maxNb then break end
    end
    if nb ~= maxNb then
        result[nb + 1] = string.sub(str, lastPos)
    end
    return result
end

function mysql_query_select(query)
	i = 1
	ret = {}
	
	math.randomseed(os.time())
	random = math.random()

	n = "/tmp/mysql_"..random..pc.get_vid()

	os.execute (MYSQL_BIN.." \""..MYSQL_CONFIG.."\" 1 \""..query.."\" > " .. n)

	for line in io.lines (n) do
		ret[i] = Split(line, "^")
		if ret[i][1] == "ERROR" then
			return ret[i]
		end
		i = i + 1
	end
	os.remove (n)
	
	return ret
end

function mysql_query(query)
	math.randomseed(os.time())
	random = math.random()

	n = "/tmp/mysql_"..random..pc.get_vid()

	os.execute (MYSQL_BIN.." \""..MYSQL_CONFIG.."\" 0 \""..query.."\" > " .. n)

	for line in io.lines (n) do
		if line == "SUCCESS" then
			return true
		else
			ret = Split(line, "^")
			return ret[2]
		end
	end
	os.remove (n)
end