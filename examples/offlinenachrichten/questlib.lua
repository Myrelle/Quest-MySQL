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

function message_check_receiver_exists(receiver)
	rows = mysql_query_select("SELECT COUNT(*) FROM "..DATABASE..".player WHERE md5(name)=md5('"..receiver.."')")
	if tonumber(rows[1][1]) >= 1 then
		return true
	else
		return false
	end
end

function message_check_receiver_is_team(receiver)
	rows = mysql_query_select("SELECT '"..receiver.."' LIKE '%[%' OR '"..receiver.."' LIKE '%]%'")
	if tonumber(rows[1][1]) >= 1 then
		return true
	else
		return false
	end
end

function message_check_zeichen(message)
	rows = mysql_query_select("SELECT '"..message.."' LIKE '%^%' OR '"..message.."' LIKE '%:%'")
	if tonumber(rows[1][1]) >= 1 then
		return true
	else
		return false
	end
end

function message_check_nospam()
	rows = mysql_query_select("SELECT COUNT(id) FROM "..DATABASE..".offlinemessage WHERE sender_pid=(SELECT id FROM "..DATABASE..".player WHERE name='"..pc.get_name().."') AND msg_date > DATE_SUB(NOW(), INTERVAL 1 MINUTE);")
	if tonumber(rows[1][1]) >= 1 then
		return true
	else
		return false
	end
end

function message_sendmessage(receiver, subject, message)
	if message_check_zeichen(subject) == true then
		return "Betreff enthält ungültige[ENTER]Zeichen."
	elseif message_check_zeichen(message) == true then
		return "Nachricht enthält ungültige[ENTER]Zeichen."
	elseif message_check_nospam() == true then
		return "Du kannst pro Minute nur[ENTER]eine Nachricht schreiben."
	else
		mysql_query("INSERT INTO "..DATABASE..".offlinemessage (sender_pid, receiver_pid, subject, message, msg_date) VALUES ((SELECT id FROM "..DATABASE..".player WHERE name='"..pc.get_name().."'), (SELECT id FROM "..DATABASE..".player WHERE name='"..receiver.."'), '"..subject.."', '"..message.."', NOW())")
		return true
	end
end

function message_countmessagesin()
	rows = mysql_query_select("SELECT COUNT(id) FROM "..DATABASE..".offlinemessage WHERE receiver_pid=(SELECT id FROM "..DATABASE..".player WHERE name='"..pc.get_name().."')")
	return tonumber(rows[1][1])
end

function message_countmessagesout()
	rows = mysql_query_select("SELECT COUNT(id) FROM "..DATABASE..".offlinemessage WHERE sender_pid=(SELECT id FROM "..DATABASE..".player WHERE name='"..pc.get_name().."')")
	return tonumber(rows[1][1])
end

function message_getposteingang_1(seite)
	tmp1 = tonumber(seite) - 1
	tmp2 = tmp1 * 5
	tmp3 = message_countmessagesin()
	tmp4 = tmp3 - tmp2
	
	if tmp4 <= 0 then
		return false
	else
		ret = {}
		
		rows = mysql_query_select("SELECT id, subject FROM "..DATABASE..".offlinemessage WHERE receiver_pid=(SELECT id FROM "..DATABASE..".player WHERE name='"..pc.get_name().."') ORDER BY id DESC LIMIT "..tmp2..",5")
		for i = 1, table.getn(rows), 1 do
			ret[i] = rows[i][2].." ID:"..rows[i][1]
		end
		
		if (tmp4 - 5) > 0 then
			i2 = table.getn(ret) + 1
			ret[i2] = "Zu Seite:"..seite + 1
		end
		i2 = table.getn(ret) + 1
		ret[i2] = "Abbrechen"
		
		return ret
	end
end

function message_getpostausgang_1(seite)
	tmp1 = tonumber(seite) - 1
	tmp2 = tmp1 * 5
	tmp3 = message_countmessagesout()
	tmp4 = tmp3 - tmp2
	
	if tmp4 <= 0 then
		return false
	else
		ret = {}
		
		rows = mysql_query_select("SELECT id, subject FROM "..DATABASE..".offlinemessage WHERE sender_pid=(SELECT id FROM "..DATABASE..".player WHERE name='"..pc.get_name().."') ORDER BY id DESC LIMIT "..tmp2..",5")
		for i = 1, table.getn(rows), 1 do
			ret[i] = rows[i][2].." ID:"..rows[i][1]
		end
		
		if (tmp4 - 5) > 0 then
			i2 = table.getn(ret) + 1
			ret[i2] = "Zu Seite:"..seite + 1
		end
		i2 = table.getn(ret) + 1
		ret[i2] = "Abbrechen"
		
		return ret
	end
end

function message_getpostausgang()
	if message_countmessagesout() == 0 then
		return false
	else
		ret = {}
		
		rows = mysql_query_select("SELECT id, subject FROM "..DATABASE..".offlinemessage WHERE sender_pid=(SELECT id FROM "..DATABASE..".player WHERE name='"..pc.get_name().."') ORDER BY id DESC LIMIT 5")
		for i = 1, table.getn(rows), 1 do
			ret[i] = rows[i][2].." ID:"..rows[i][1]
		end
		
		i2 = table.getn(ret) + 1
		ret[i2] = "Abbrechen"
		
		return ret
	end
end

function message_show_posteingang(seite)
	local messagesin = message_getposteingang_1(seite)
	say_title("iPhone:")
	say("")
	if messagesin == false then
		say("Keine Nachrichten im Posteingang.")
		say("")
	else
		local msg = select_table(messagesin)
			
		ret = Split(messagesin[msg], ":")
	
		if ret[1] == "Zu Seite" then
			message_show_posteingang(ret[2])
		elseif messagesin[msg] == "Abbrechen" then
			say_title("iPhone:")
			say("")
			say("Keine Aktion ausgeführt.")
			say("")
		else
			message_read(messagesin[msg])
			local thismsg = message_getmessage(messagesin[msg])
						
			say_reward("Von: "..thismsg[1])
			say_reward("Datum: "..thismsg[4])
			say_title("Betreff: "..thismsg[2])
			say("")
			say_title("Nachricht:")
			say(thismsg[3])
			say("")
		end
	end
end

function message_show_postausgang(seite)
	local messagesin = message_getpostausgang_1(seite)
	say_title("iPhone:")
	say("")
	if messagesin == false then
		say("Keine Nachrichten im Posteingang.")
		say("")
	else
		local msg = select_table(messagesin)
			
		ret = Split(messagesin[msg], ":")
	
		if ret[1] == "Zu Seite" then
			message_show_postausgang(ret[2])
		elseif messagesin[msg] == "Abbrechen" then
			say_title("iPhone:")
			say("")
			say("Keine Aktion ausgeführt.")
			say("")
		else
			local thismsg = message_getmessageout(messagesin[msg])
						
			say_reward("An: "..thismsg[1])
			say_reward("Datum: "..thismsg[4])
			say_title("Betreff: "..thismsg[2])
			say("")
			say_title("Nachricht:")
			say(thismsg[3])
			say("")
		end
	end
end

function message_getmessage(msg)
	id = Split(msg, ":")
	rows = mysql_query_select("SELECT player.name, offlinemessage.subject, offlinemessage.message, offlinemessage.msg_date FROM "..DATABASE..".player INNER JOIN "..DATABASE..".offlinemessage ON player.id = offlinemessage.sender_pid WHERE offlinemessage.id = '"..id[2].."'")
	
	ret = {}
	
	ret[1] = rows[1][1]
	ret[2] = rows[1][2]
	ret[3] = rows[1][3]
	ret[4] = rows[1][4]
	
	return ret
end

function message_getmessageout(msg)
	id = Split(msg, ":")
	rows = mysql_query_select("SELECT player.name, offlinemessage.subject, offlinemessage.message, offlinemessage.msg_date FROM "..DATABASE..".player INNER JOIN "..DATABASE..".offlinemessage ON player.id = offlinemessage.receiver_pid WHERE offlinemessage.id = '"..id[2].."'")
	
	ret = {}
	
	ret[1] = rows[1][1]
	ret[2] = rows[1][2]
	ret[3] = rows[1][3]
	ret[4] = rows[1][4]
	
	return ret
end

function message_read(msg)
	id = Split(msg, ":")
	rows = mysql_query("UPDATE "..DATABASE..".offlinemessage SET was_read='1' WHERE id='"..id[2].."'")
	say("blub")
end

function message_count_unread()
	rows = mysql_query_select("SELECT COUNT(id) FROM "..DATABASE..".offlinemessage WHERE receiver_pid=(SELECT id FROM "..DATABASE..".player WHERE name='"..pc.get_name().."') AND was_read='0'")
	return tonumber(rows[1][1])
end