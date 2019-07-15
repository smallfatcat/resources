function getTPPnames()
    local names = {}
    for _,item in ipairs(tpCoords) do
        table.insert(names,item.name)
    end
    return names
end

function itemMenu(menu)
    local b = {1,2,3,4}
    local emoteList = {}
    for i = 1, #Config.Anims do
        emoteList[i] = Config.Anims[i].name
    end
    local startT  = NativeUI.CreateItem("Start Timer", "~g~start stopwatch")
    local stopT  = NativeUI.CreateItem("Stop timer", "~g~stop stopwatch")
    local hideT  = NativeUI.CreateItem("Hide timer", "~g~hide stopwatch")
    local startST  = NativeUI.CreateItem("Start Speed Timer", "~g~start stopwatch")
    local click  = NativeUI.CreateItem("Start Fight Club", "~g~make peds fight")
    local tplist = NativeUI.CreateListItem("Teleport to Bank", b, 1)
    local openlist = NativeUI.CreateListItem("Open Bank Door", b, 1)
    local closelist = NativeUI.CreateListItem("Close Bank Door", b, 1)
    local emotes = NativeUI.CreateListItem("Emote", emoteList, 1)
    local tppNames = getTPPnames()
    local tpplist = NativeUI.CreateListItem("Teleport to...", tppNames, 1)
    
    menu:AddItem(startT)
    menu:AddItem(stopT)
    menu:AddItem(hideT)
    menu:AddItem(startST)
    menu:AddItem(click)
    menu:AddItem(tplist)
    menu:AddItem(openlist)
    menu:AddItem(closelist)
    menu:AddItem(emotes)
    menu:AddItem(tpplist)

    --menu.MouseControlsEnabled = false
    menu.OnItemSelect = function(sender, item, index)
        -- print("debug: in 1:")
        if item == click then
            fightclub()
            notify("~g~Fight Club started")
        end
        if item == startT then
            startTimer()
        end
        if item == stopT then
            stopTimer()
        end
        if item == hideT then
            timerVisible = false
        end
        if item == startST then
            startSpeedTimer()
        end
    end
    menu.OnListSelect = function(sender, item, index)  
        if item == tplist then
            local selectedBank = item:IndexToItem(index)
            tpBank(tonumber(selectedBank))
            notify("~g~Teleported to bank "..tonumber(selectedBank))
        end
        if item == openlist then
            local selectedBank = item:IndexToItem(index)
            openBankDoor(tonumber(selectedBank),1)
            notify("~g~Opened Bank Door "..tonumber(selectedBank))
        end
        if item == closelist then
            local selectedBank = item:IndexToItem(index)
            closeBankDoor(tonumber(selectedBank),1)
            notify("~g~Closed Bank Door "..tonumber(selectedBank))
        end
        if item == emotes then
            local emoteName = item:IndexToItem(index)
            ExecuteCommand("e "..emoteName)
            notify("~g~Emoted "..emoteName)
        end
        if item == tpplist then
            local name = item:IndexToItem(index)
            tpSpecial(name)
            notify("~g~Teleported to "..name)
        end
    end
end

_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Actions", "~b~Action Menu")

_menuPool:Add(mainMenu)

itemMenu(mainMenu)
_menuPool:RefreshIndex()
mainMenu.Settings.MouseControlsEnabled = false
mainMenu.Settings.MouseEdgeEnabled = false
mainMenu.Settings.ControlDisablingEnabled = false

_progressBarPool = NativeUI.ProgressBarPool()
HackingProgressBar = NativeUI.CreateProgressBarItem("Hacking console...")
_progressBarPool:Add(HackingProgressBar)