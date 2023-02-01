-----------------------------------------------
-- Global Tables
-----------------------------------------------
global_exp_table = {}
-----------------------------------------------
-- DB Connect function
-----------------------------------------------

function debug(msg,type,r,g,b)
    outputDebugString(getResourceName(getThisResource()).." : - "..msg,type,r,g,b)
end

db = dbConnect( "sqlite", "data/levels.db")
if db then 
    debug("Levels.db connected ( - levels.db database bağlantısı başarılı - ).",3)
else
    debug("Levels.db is not connected ( - levels.db database bağlantısı yok! - ).",1)
end
local function start_source()
    if db then 
        global_exp_table = dbPoll(dbQuery(db, "SELECT * FROM levels"),-1)
    else
        debug("Levels.db is not connected ( - levels.db database bağlantısı yok! - ).",1)
    end
end

addEventHandler("onResourceStart",resourceRoot,start_source)

-------------------------------------------------
--Pull the level chart (Seviye tablosunu çekme)
-------------------------------------------------
function get_levels_table()
    return global_exp_table
end



---------------------------------------------------
-- save player experience in levels table ( - levels tablosuna oyuncu deneyimini kaydet - )
---------------------------------------------------
function save_levels_table(account_name,level_table)
    local temporary_element = true
    for k,v in ipairs(global_exp_table) do 
        if v.account_name == account_name then 
            temporary_element = false
            level_table = fromJSON(level_table)
            local end_index = #levels_names
            for k,v in ipairs(levels_names) do
                if k + 1 <= end_index then 
                    if level_table[1][2] >= v[2] and level_table[1][2] < levels_names[k+1][2]  then 
                        --level_table[1][1] = v[1]
                        break
                    end
                else
                    if level_table[1][2] >= v[2]  then 
                        --level_table[1][1] = v[1]
                        break
                    end
                end
            end
            level_table =toJSON(level_table)
            local result = dbExec(db,"UPDATE levels SET levels_data = ? WHERE account_name=? ",level_table,account_name)
            v.levels_data = level_table
            if not result then 
                debug(" experience not saved in levels.db ( - deneyim levels.db'ye kaydedilmedi! - ) ",1)
            end
        end
    end
    if temporary_element then 
        level_table = fromJSON(level_table)
        local end_index = #levels_names
        for k,v in ipairs(levels_names) do
            if k + 1 <= end_index then 
                if level_table[1][2] >= v[2] and level_table[1][2] < levels_names[k+1][2]  then 
                    level_table[1][1] = v[1]
                    break
                end
            else
                if level_table[1][2] >= v[2]  then 
                    level_table[1][1] = v[1]
                    break
                end
            end
        end
        level_table =toJSON(level_table)
        local result = dbExec(db,"INSERT INTO levels (account_name,levels_data) VALUES(?,?)",account_name,level_table)
        table.insert(global_exp_table,{account_name = account_name,levels_data = level_table})
        if not result then 
            debug(" experience not saved in levels.db ( - deneyim levels.db'ye kaydedilmedi! - ) ",1)
        end
    end
end