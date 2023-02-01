---------------------------------------
-- Export levels table (- level tablosunu gönderme -) --SERVER
---------------------------------------
function export_levels_table()
    local levels = player_table
    if not levels then return  debug("there is no levels table! ( - tablo alınamadı  - )", 1) end
    if type(levels) ~= "table" then return debug("there is no levels table! ( - tablo alınamadı  - ) ",1) end
    return fromJSON(levels)
end

---------------------------------------
-- Export levels data (- level datasını gönderme -) --SERVER
---------------------------------------
function export_level_data(player,data_name)
    local account_name = getAccountName(getPlayerAccount(player))
    local levels = player_table
    local temporary_element = true
    for k,v in ipairs(levels) do 
        if account_name == v[1] then 
            local exp_table = v[2]
            for l,s in ipairs(exp_table) do 
                if s[1] == data_name then 
                    temporary_element = false
                    return s[2]
                end
            end
        end
    end
    if temporary_element then 
        debug(" operation failed! (- işlem başarısız - )",1)
        return false
    end
end

-------------------------------------
-- Save exp in levels table ( -level tablosuna deneyimi kaydetme - ) --SERVER
-------------------------------------
local function get_level_name(exp)
    local l_name = "nil"
    local end_index = #levels_names
    for k,v in ipairs(levels_names) do
        if k + 1 <= end_index then 
            if exp >= v[2] and exp < levels_names[k+1][2]  then 
                l_name = v[1]
                break
            end
        else
            if exp >= v[2]  then 
                l_name = v[1]
                break
            end
        end
    end
    return l_name
end

function export_save_exp(player,exp)
    if type(tonumber(exp)) ~= "number" then return debug(" exp element is not a number ( - exp elementi bir sayı değildir! - ) "..string.gsub(getPlayerName(player), "#%x%x%x%x%x%x", "").." player's exp is not saved ( - adlı oyuncunun deneyimi kayıt edilmedi - )",1) end
    local temporary_element = true
    local account_name = getAccountName(getPlayerAccount(player))
    local levels = player_table
    for k,v in ipairs(levels) do 
        if account_name == v[1] then 
            local exp_table = v[2]
            for l,s in ipairs(exp_table) do 
                temporary_element = false
                for z,f in pairs(admins) do
                    triggerClientEvent("refresh_list",f)
                end
                s[2] = tonumber(s[2]) + tonumber(exp)
                s[1] = get_level_name(s[2])
                if tonumber(s[2]) > 1000 then 
                    s[2] = tonumber(s[2]) - tonumber(exp)
                end
            end
            save_levels_table(account_name,toJSON(exp_table))
        end
    end  
end

addEvent("export_save_exp_s",true)
addEventHandler("export_save_exp_s",root,export_save_exp)


