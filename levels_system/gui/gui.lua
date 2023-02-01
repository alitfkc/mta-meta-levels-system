-----------------------------------
-- Panel
------------------------------------
loadstring(exports.dgs:dgsImportFunction())()
dgs = {}
language_selection = 1 --Export language 
local function resource_start()

    panel = dgsCreateWindow(0.27,0.25,0.45,0.45,language[language_selection][2][1],true,false,25,false,tocolor(0,120,0),false,tocolor(12,12,12,210))

    dgs.player_list = dgsCreateGridList(0.01,0.18,0.47,0.75,true,panel)
    player_list_column = dgsGridListAddColumn(dgs.player_list,language[language_selection][2][4],0.9)

    exp_list = dgsCreateGridList(0.51,0.07,0.47,0.3,true,panel)
    exp_list_column1 = dgsGridListAddColumn(exp_list,language[language_selection][2][5],0.5)
    exp_list_column2 = dgsGridListAddColumn(exp_list,language[language_selection][2][6],0.4)

    dgs.search = dgsCreateEdit(0.01,0.07,0.47,0.1,language[language_selection][2][2],true,panel)


    dgsSetVisible(panel,false)

    label = dgsCreateLabel(0.51,0.85,0.47,0.09,"asd",true,panel)
    -- Add or Remove panel
    dgs.add_edit = dgsCreateEdit(0.51,0.42,0.47,0.09,language[language_selection][2][8],true,panel)
    dgs.level_edit = dgsCreateEdit(0.51,0.62,0.47,0.09,"level",true,panel)
    dgs.add_or_rev_buton = dgsCreateButton(0.51,0.72,0.47,0.09,language[language_selection][2][3],true,panel,false,false,false,false,false,false,tocolor(0,120,0,220),tocolor(0,120,0,120),tocolor(0,120,0,120))

end
addEventHandler("onClientResourceStart",resourceRoot,resource_start)
