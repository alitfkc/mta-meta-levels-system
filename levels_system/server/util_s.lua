----------------------------------
-- GLOBAL ELEMENTS (- her yerde geçerli elementler -) --SERVER
----------------------------------
player_table = {}
admins = {}
----------------------------------
-- DEBUGS WRİTER function --SERVER
----------------------------------
function debug(msg,type,r,g,b)
    outputDebugString(getResourceName(getThisResource()).." : - "..msg,type,r,g,b)
end




-------------------------------------------
-- on player login add to global table (oyuncu oyuna girdiğinde küresel tabloya verilerini ekle)
--------------------------------------------
local function player_login(_,account)
    local account_name = getAccountName(account)
    local levels = get_levels_table()
    local temporary_element = true
    for k,v in ipairs(levels) do
        if account_name == v.account_name then 
            temporary_element = false
            local level = fromJSON(v.levels_data)
            table.insert(player_table,{account_name,level})
        end 
    end
    if temporary_element then  -- if not saved in levels table
        local level = {}
        for k,v in pairs(levels_dont_touch) do
            table.insert(level,{v,0})
        end
        table.insert(player_table,{account_name,level})
    end
end


addEventHandler("onPlayerLogin",root,player_login)




-------------------------------------------
-- on resource start add to global table (script çalıştırıldığında küresel tabloya verilerini ekle)
--------------------------------------------
local function resource_start()
    for k,v in ipairs(getElementsByType("player")) do 
        local account_name = getAccountName(getPlayerAccount(v))
        local levels = get_levels_table()
        local temporary_element = true
        for k,v in ipairs(levels) do
            if account_name == v.account_name then 
                temporary_element = false
                local level = fromJSON(v.levels_data)
                table.insert(player_table,{account_name,level})
            end 
        end
        if temporary_element then  -- if not saved in levels table
            local level = {}
            for k,v in pairs(levels_dont_touch) do
                table.insert(level,{v,0})
            end
            table.insert(player_table,{account_name,level})
        end
    end
end


addEventHandler("onResourceStart",resourceRoot,resource_start)


-----------------------------------------
-- on player logout save to db ( - oyuncu oturumu kapatıldığında db'ye kaydet -)
-----------------------------------------
local function player_logout(account)
    local account_name = getAccountName(account)
    for k,v in ipairs(player_table) do 
        if v[1] == account_name then 
            local levels = toJSON(v[2])
            table.remove(player_table,k)
            save_levels_table(account_name,levels)
        end
    end
    if admins[source] then 
        admins[source] = false
    else
        admins[source] = source 
    end
end

addEventHandler("onPlayerLogout",root,player_logout)


---------------------------------------------------------
--1  hours on save ( - 1 saatte bir kayıt etme - )
---------------------------------------------------------
function saved_second()
    for k,v in ipairs(player_table) do
        if v[1] == account_name then 
            local levels = toJSON(v[2])
            save_levels_table(account_name,levels)
        end
    end
end
setTimer(saved_second,3600000,0)



---------------------------------------------------
-- personnel player open panel (- Yetkili kişi paneli açma - ) --server
---------------------------------------------------
local function panel(thePlayer)
    local account_name = getAccountName ( getPlayerAccount ( thePlayer ) ) 
    if isObjectInACLGroup ("user."..account_name, aclGetGroup ( panel_acl_groups  ) ) then 
        triggerClientEvent("panel_open" ,thePlayer)
        if admins[thePlayer]  then
            admins[thePlayer] = nil
        else
            admins[thePlayer] = thePlayer
        end
    end
end
addCommandHandler (panel_command, panel ) -- Panel açma komutu

---------------------------------------------------------
-- return accounts on client side (- hesapları client tarafına gönder -)
----------------------------------------------------------
local function return_accounts()
    local accounts = getAccounts()
    local accounts_name = {}
    for k,v in ipairs(accounts) do 
        table.insert(accounts_name,getAccountName(v))
    end
    triggerClientEvent("return_accounts",source,accounts_name)
end
addEvent("get_accounts",true)
addEventHandler("get_accounts",root,return_accounts)


------------------------------------------------------
-- return player levels table ( - oyuncu tablosunu client paneline gönder - )
------------------------------------------------------
function return_player_table(account_name)
    local temporary_element = true
    local table = false
    for k,v in ipairs(player_table) do 
        if v[1] == account_name then 
            temporary_element = false
            table = v[2]
        end
    end
    if temporary_element then 
        local levels = get_levels_table()
        for k ,v in ipairs(levels) do 
            if v[1] == account_name then 
                table = fromJSON(v[2])
            end
        end
    end
    triggerClientEvent("return_player_table",source,table)
end
addEvent("get_player_levels_client",true)
addEventHandler("get_player_levels_client",root,return_player_table)


------------------------------------------------------------
--Change experience ( - deneyim miktarı değiştirme - )
------------------------------------------------------------
function change_exp(account_name,level,exp)
    local temporary_element = true
    local table = false
    for k,v in ipairs(player_table) do 
        if v[1] == account_name then 
            temporary_element = true
            for l,s in ipairs(v[2]) do 
                s[1] = level
                s[2] = tonumber(exp)
            end
            save_levels_table(account_name,toJSON(v[2]))
        end
    end
    if temporary_element then 
        local levels = get_levels_table()
        local table = {}
        for k ,v in ipairs(levels) do 
            if v.account_name == account_name then 
                table = fromJSON(v.levels_data) 
                for l,s in ipairs(table) do 
                    s[1] = level
                    s[2] =  tonumber(exp)
                end
                save_levels_table(account_name,toJSON(table))
                break
            end
        end
    end
end
addEvent("change_data_name_experience",true)
addEventHandler("change_data_name_experience",root,change_exp)


