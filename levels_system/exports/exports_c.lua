--[[
--------------------------------------
-- get server side levels_table 
--------------------------------------
local levels = false
local account_name = ""
function get_server_side_levels_table(table,a_name)
    print( table)
    print(a_name)
    levels = table
    account_name= account_name
end

addEvent("return_levels_table_client",true)
addEventHandler("return_levels_table_client",localPlayer,get_server_side_levels_table)

---------------------------------------
-- Export levels table (- level tablosunu gönderme -) --CLİENT
---------------------------------------
function export_levels_table()
    local temporary_element = triggerServerEvent("get_levels_table_client_event",localPlayer)
    if temporary_element then 
        return gonder()
    else
        debug("there is no levels table! ( - tablo alınamadı  - ) ",1)
    end
end


function gonder()
    if not levels then return  debug("there is no levels table! ( - tablo alınamadı  - )", 1) end
    if type(levels) ~= "table" then return debug("there is no levels table! ( - tablo alınamadı  - ) ",1) end
    return fromJSON(levels)
end

---------------------------------------
-- Export levels data (- level datasını gönderme -) --CLİENT
---------------------------------------
function export_level_data(data_name)
    local temporary_element_server = triggerServerEvent("get_levels_table_client_event",localPlayer)
    if temporary_element_server then 
        local temporary_element = true
        for k,v in ipairs(levels) do 
            if account_name == v.account_name then 
                local exp_table = v.levels_data
                exp_table = fromJSON(exp_table)
                for l,s in ipairs(exp_table) do 
                    if s[l][1] == data_name then 
                        temporary_element = false
                        return s[l][2]
                    end
                end
            end
        end
        if temporary_element then 
            debug(" operation failed! (- işlem başarısız - )",1)
            return false
        end
    else
        debug("there is no levels table! ( - tablo alınamadı  - ) ",1)
    end
end

]]--
-------------------------------------
-- Save exp in levels table ( -level tablosuna deneyimi kaydetme - ) --client
-------------------------------------
function export_save_exp(exp)
    triggerServerEvent("export_save_exp_s",localPlayer,localPlayer,exp)
end





