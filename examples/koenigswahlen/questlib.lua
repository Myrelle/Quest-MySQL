DATABASE = "player_test"
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

function koenigswahl_startwahl_global()	
	koenigswahl_startwahl(1)
	koenigswahl_startwahl(2)
	koenigswahl_startwahl(3)
end
function koenigswahl_startwahl(reich)
	mysql_query("DELETE FROM "..DATABASE..".koenigswahl_kandidaten WHERE empire='"..reich.."'")
	mysql_query("DELETE FROM "..DATABASE..".koenigswahl_votes WHERE empire='"..reich.."'")
	
	game.set_event_flag("koenigswahl_"..reich, 1)
end
function koenigswahl_cancelwahl_global()	
	koenigswahl_cancelwahl(1)
	koenigswahl_cancelwahl(2)
	koenigswahl_cancelwahl(3)
end
function koenigswahl_cancelwahl(reich)
	mysql_query("DELETE FROM "..DATABASE..".koenigswahl_kandidaten WHERE empire='"..reich.."'")
	mysql_query("DELETE FROM "..DATABASE..".koenigswahl_votes WHERE empire='"..reich.."'")
	
	game.set_event_flag("koenigswahl_"..reich, 0)
end
function koenigswahl_add_candidate()
	--pc.get_vid()
	mysql_query("INSERT INTO "..DATABASE..".koenigswahl_kandidaten (pid, empire, candidate_date) VALUES ((SELECT id FROM "..DATABASE..".player WHERE name='"..pc.get_name().."'), '"..pc.get_empire().."', NOW())")
end
function koenigswahl_count_candidates()
	rows = mysql_query_select("SELECT COUNT(*) FROM "..DATABASE..".koenigswahl_kandidaten WHERE empire='"..pc.get_empire().."'")
	
	return tonumber(rows[1][1])
end
function koenigswahl_has_candidated()	
	--pc.get_vid()
	rows = mysql_query_select("SELECT COUNT(*) FROM "..DATABASE..".koenigswahl_kandidaten WHERE pid=(SELECT id FROM "..DATABASE..".player WHERE name='"..pc.get_name().."')")
	if tonumber(rows[1][1]) >= 1 then
		return true
	else
		return false
	end
end
function koenigswahl_get_candidates()
	ret = {}
	
	rows = mysql_query_select("SELECT player.name FROM "..DATABASE..".player INNER JOIN "..DATABASE..".koenigswahl_kandidaten ON koenigswahl_kandidaten.pid = player.id WHERE koenigswahl_kandidaten.empire = '"..pc.get_empire().."' ORDER BY koenigswahl_kandidaten.candidate_id ASC")
	for i = 1, table.getn(rows), 1 do
		ret[i] = rows[i][1]
	end
	
	return ret
end
function koenigswahl_exists_candidate(can)
	rows = mysql_query_select("SELECT COUNT(*) FROM "..DATABASE..".koenigswahl_kandidaten WHERE pid=(SELECT id FROM "..DATABASE..".player WHERE name='"..can.."')")
	if tonumber(rows[1][1]) == 1 then
		return true
	else
		return false
	end
end
function koenigswahl_vote_for_player(name)	
	mysql_query("UPDATE "..DATABASE..".koenigswahl_kandidaten SET votes=votes+1 WHERE pid=(SELECT id FROM "..DATABASE..".player WHERE name='"..name.."')")
	mysql_query("INSERT INTO "..DATABASE..".koenigswahl_votes (pid, vote_for_pid, vote_date, empire) VALUES ((SELECT id FROM "..DATABASE..".player WHERE name='"..pc.get_name().."'), (SELECT id FROM "..DATABASE..".player WHERE name='"..name.."'), NOW(), '"..pc.get_empire().."')")
end
function koenigswahl_check_voted(name)
	rows = mysql_query_select("SELECT COUNT(*) FROM "..DATABASE..".koenigswahl_votes WHERE pid=(SELECT id FROM "..DATABASE..".player WHERE name='"..pc.get_name().."')")
	if tonumber(rows[1][1]) >= 1 then
		return true
	else
		return false
	end
end
function koenigswahl_stop_global()
	koenigswahl_stop(1)
	koenigswahl_stop(2)
	koenigswahl_stop(3)
end
function koenigswahl_stop(reich)
	rows = mysql_query_select("SELECT COUNT(*) FROM "..DATABASE..".koenig_derzeitig WHERE empire='"..reich.."'")
	
	if tonumber(rows[1][1]) == 1 then
		mysql_query("UPDATE "..DATABASE..".koenig_derzeitig SET pid=(SELECT pid FROM "..DATABASE..".koenigswahl_kandidaten WHERE empire='"..reich.."' ORDER BY votes DESC LIMIT 1), empire='"..reich.."', vote_date=NOW(), votes=(SELECT votes FROM "..DATABASE..".koenigswahl_kandidaten WHERE empire='"..reich.."' ORDER BY votes DESC LIMIT 1) WHERE empire='"..reich.."'")
	else
		mysql_query("INSERT INTO "..DATABASE..".koenig_derzeitig (pid, empire, vote_date, votes) VALUES ((SELECT pid FROM "..DATABASE..".koenigswahl_kandidaten WHERE empire='"..reich.."' ORDER BY votes DESC LIMIT 1), '"..reich.."', NOW(), (SELECT votes FROM "..DATABASE..".koenigswahl_kandidaten WHERE empire='"..reich.."' ORDER BY votes DESC LIMIT 1))");
	end
	
	rows1 = mysql_query_select("SELECT player.job, player.owner_id FROM "..DATABASE..".koenig_derzeitig INNER JOIN "..DATABASE..".player ON koenig_derzeitig.pid = player.id WHERE koenig_derzeitig.empire = '"..reich.."'")
	if tonumber(rows1[1][1]) == 0 or tonumber(rows1[1][1]) == 4 then
		--krieger
		mysql_query("INSERT INTO "..DATABASE..".item (owner_id, window, count, vnum) VALUES ('"..rows1[1][2].."', 'MALL', '1', '11971')");
	elseif tonumber(rows1[1][1]) == 1 or tonumber(rows1[1][1]) == 5 then
		--ninja
		mysql_query("INSERT INTO "..DATABASE..".item (owner_id, window, count, vnum) VALUES ('"..rows1[1][2].."', 'MALL', '1', '11972')");
	elseif tonumber(rows1[1][1]) == 2 or tonumber(rows1[1][1]) == 6 then
		--sura
		mysql_query("INSERT INTO "..DATABASE..".item (owner_id, window, count, vnum) VALUES ('"..rows1[1][2].."', 'MALL', '1', '11973')");
	elseif tonumber(rows1[1][1]) == 3 or tonumber(rows1[1][1]) == 7 then
		--schamane
		mysql_query("INSERT INTO "..DATABASE..".item (owner_id, window, count, vnum) VALUES ('"..rows1[1][2].."', 'MALL', '1', '11974')");
	end
	mysql_query("INSERT INTO "..DATABASE..".item (owner_id, window, pos, count, vnum) VALUES ('"..rows1[1][2].."', 'MALL', '1' '1', '2')");
	
	mysql_query("DELETE FROM "..DATABASE..".koenigswahl_kandidaten WHERE empire='"..reich.."'")
	mysql_query("DELETE FROM "..DATABASE..".koenigswahl_votes WHERE empire='"..reich.."'")
	
	game.set_event_flag("koenigswahl_"..reich, 0)
end
function is_king()
	rows = mysql_query_select("SELECT COUNT(*) FROM "..DATABASE..".koenig_derzeitig WHERE pid=(SELECT id FROM "..DATABASE..".player WHERE name='"..pc.get_name().."')")
	if tonumber(rows[1][1]) >= 1 then
		return true
	else
		return false
	end
end
function is_wahl()
	if game.get_event_flag("koenigswahl_"..pc.get_empire()) == 1 then
		return true
	else
		return false
	end
end
function who_is_king(reich)
	rows = mysql_query_select("SELECT player.name FROM "..DATABASE..".player INNER JOIN "..DATABASE..".koenig_derzeitig ON koenig_derzeitig.pid = player.id WHERE koenig_derzeitig.empire = '"..reich.."'")
	
	if table.getn(rows) >= 1 then
		return rows[1][1]
	else
		return "Kein König"
	end
end
function koenig_zuruecktreten()
	mysql_query_select("DELETE FROM "..DATABASE..".koenig_derzeitig WHERE empire='"..pc.get_empire().."'")
end