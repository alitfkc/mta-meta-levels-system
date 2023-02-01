accounts = {}
admins = {}
----------------------------------
--personnel player open panel (- Yetkili kişi paneli açma - ) --client
-----------------------------------
local function panel_open_c()
    if dgsGetVisible(panel) then 
        dgsSetVisible(panel,false)
        showCursor(false)
        for k,v in pairs(dgs) do 
            removeEventHandler ( "onDgsMouseClick", v,click_dgs )
        end
        removeEventHandler("onDgsTextChange",dgs.search,account_search)
    else
        dgsSetVisible(panel,true)
        showCursor(true)
        add_players_accounts()
        for k,v in pairs(dgs) do 
            addEventHandler ( "onDgsMouseClick", v,click_dgs )
        end
        addEventHandler("onDgsTextChange",dgs.search,account_search)
    end
end
addEvent("panel_open",true)
addEventHandler("panel_open",localPlayer,panel_open_c)




--account search (- hesap arama -)
---------------------------------------------------
function account_search()
    local value = dgsGetText(dgs.search)
    dgsGridListClear(dgs.player_list)
    for k,v in pairs(accounts) do 
        if string.find(v,value,1,true) then 
            local row = dgsGridListAddRow ( dgs.player_list )
            dgsGridListSetItemText ( dgs.player_list, row, player_list_column, v)
        end
    end
end

----------------------------------------------------
-- gridlist add to player accounts (- oyuncu hesaplarını listeye ekleme -)
----------------------------------------------------
function add_players_accounts()
    triggerServerEvent("get_accounts",localPlayer)
end
function add_gridlist_accounts(accounts_table)
    dgsGridListClear(dgs.player_list)
    accounts = accounts_table
    for k,v in pairs(accounts_table) do 
        local row = dgsGridListAddRow ( dgs.player_list )
        dgsGridListSetItemText ( dgs.player_list, row, player_list_column, v)
    end
end
addEvent("return_accounts",true)
addEventHandler("return_accounts",localPlayer,add_gridlist_accounts)

-------------------------------------------------------
--on dgs click ( - dgs'ye tıklama - )
-------------------------------------------------------
local tick = 0
function click_dgs()
    if getTickCount()-tick <= 500 then return end 
    if source == dgs.player_list then 
        local Selected = dgsGridListGetSelectedItem(dgs.player_list)
		if Selected ~=-1 then 
			local output= dgsGridListGetItemText(dgs.player_list,Selected,player_list_column)
            get_player_levels(output)
        end
    elseif source == dgs.add_or_rev_buton then 
        local level = dgsGetText(dgs.level_edit)
        local exp = dgsGetText(dgs.add_edit)
        exp = tonumber(exp)
        local state = false
        for k,v in ipairs(levels_names) do 
            if level == v[1] then 
                state = true
                break
            end
        end
        if not state then return end
        local state = false
        local end_index = #levels_names
        for k,v in ipairs(levels_names) do
            if k + 1 <= end_index then 
                if exp >= v[2] and exp < levels_names[k+1][2]  then 
                    if level == v[1] then
                        state = true
                    end  
                    break
                end
            else
                if exp >= v[2]  then 
                    if level == v[1] then
                        state = true
                    end 
                    break
                end
            end
        end
        if not state then return end
        if not level and not exp then return end
        local Selected = dgsGridListGetSelectedItem(dgs.player_list)
		if Selected ~=-1 then 
			local account_name= dgsGridListGetItemText(dgs.player_list,Selected,player_list_column)
            triggerServerEvent("change_data_name_experience",localPlayer,account_name,level,exp)
            get_player_levels(account_name)
        end
    elseif source == dgs.search then 
        dgsSetText(dgs.search,"")
    elseif source == dgs.add_edit then 
        dgsSetText(dgs.add_edit,"")
    elseif source == dgs.level_edit then 
        dgsSetText(dgs.level_edit,"")
    end
    tick = getTickCount()
end


----------------------------------------------------------------
--get player levels table 
-----------------------------------------------------------------
local timer = nil
function get_player_levels(account_name)
    triggerServerEvent("get_player_levels_client",localPlayer,account_name)
end
function set_gridlist_selected_player_levels(table)
    dgsGridListClear(exp_list)
    if type(table) ~= "table" then return debug("is not a table ( - tablo mevcut değil - ) ",0,123,120,54) end
    local row = dgsGridListAddRow ( exp_list )

    dgsGridListSetItemText (exp_list , row, exp_list_column1, table[1][1])
    dgsGridListSetItemText (exp_list , row, exp_list_column2,table[1][2])
    dgsSetText(dgs.add_edit,table[1][2])
    dgsSetText(dgs.level_edit,table[1][1])

    local exp = table[1][2]
    local end_index = #levels_names
    for k,v in ipairs(levels_names) do
        if k + 1 <= end_index then 
            if exp >= v[2] and exp < levels_names[k+1][2]  then 
                local result =  ( levels_names[k+1][2] - exp) - 100
                dgsSetText(label,table[1][1].."-"..result)
                break
            end
        else
            if exp >= v[2]  then 
                local result = 1000 - ( level_cap- exp)
                dgsSetText(label,table[1][1].." XP: "..exp.." %"..result)
                break
            end
        end
    end
end
addEvent("return_player_table",true)
addEventHandler("return_player_table",localPlayer,set_gridlist_selected_player_levels)

----------------------------------
-- DEBUGS WRİTER function --client
----------------------------------
function debug(msg,type,r,g,b)
    outputDebugString(getResourceName(getThisResource()).." : - "..msg,type,r,g,b)
end




---------------------------------------------------------
--Refresh List ( - Xp alınca listeyi yenileme -)
---------------------------------------------------------
function refresh_list_c()
    local Selected = dgsGridListGetSelectedItem(dgs.player_list)
    if Selected ~=-1 then 
        local output= dgsGridListGetItemText(dgs.player_list,Selected,player_list_column)
        get_player_levels(output)
    end
end
addEvent("refresh_list",true)
addEventHandler("refresh_list",localPlayer,refresh_list_c)





