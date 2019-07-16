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

function getComponentArray(num)
    local retValue = {}
    for i = 0, (num-1) do
        retValue[i+1] = i
    end
    return retValue
end

function clothesMenuFunc(menu)
    local component0 = getComponentArray(46)
    local component1 = getComponentArray(148)
    local component2 = getComponentArray(74)
    local component3 = getComponentArray(168)
    local component4 = getComponentArray(115)
    local component5 = getComponentArray(81)
    local component6 = getComponentArray(91)
    local component7 = getComponentArray(132)
    local component8 = getComponentArray(144)
    local component9 = getComponentArray(38)
    local component10 = getComponentArray(62)
    local component11 = getComponentArray(290)
    local comp0 = NativeUI.CreateListItem("Head", component0, 1)
    local comp1 = NativeUI.CreateListItem("Mask", component1, 1)
    local comp2 = NativeUI.CreateListItem("Hair", component2, 1)
    local comp3 = NativeUI.CreateListItem("Arms", component3, 1)
    local comp4 = NativeUI.CreateListItem("Legs", component4, 1)
    local comp5 = NativeUI.CreateListItem("Bags & Parachutes", component5, 1)
    local comp6 = NativeUI.CreateListItem("Shoes", component6, 1)
    local comp7 = NativeUI.CreateListItem("comp7", component7, 1)
    local comp8 = NativeUI.CreateListItem("Undershirt", component8, 1)
    local comp9 = NativeUI.CreateListItem("Armour", component9, 1)
    local comp10 = NativeUI.CreateListItem("Decals", component10, 1)
    local comp11 = NativeUI.CreateListItem("Shirt", component11, 1)
    
    menu:AddItem(comp0)
    menu:AddItem(comp1)
    menu:AddItem(comp2)
    menu:AddItem(comp3)
    menu:AddItem(comp4)
    menu:AddItem(comp5)
    menu:AddItem(comp6)
    menu:AddItem(comp7)
    menu:AddItem(comp8)
    menu:AddItem(comp9)
    menu:AddItem(comp10)
    menu:AddItem(comp11)

    local ped = GetPlayerPed(-1)
    local textureId = 0
    local paletteId = 0
    
    menu.OnListSelect = function(sender, item, index)
        if item == comp0 then
            local selectedComponent = item:IndexToItem(index)
            SetPedComponentVariation(ped, componentId, drawableId, textureId, paletteId)
            SetPedComponentVariation(ped, 0, selectedComponent, textureId, paletteId)
        end
        if item == comp1 then
            local selectedComponent = item:IndexToItem(index)
            SetPedComponentVariation(ped, componentId, drawableId, textureId, paletteId)
            SetPedComponentVariation(ped, 1, selectedComponent, textureId, paletteId)
        end
        if item == comp2 then
            local selectedComponent = item:IndexToItem(index)
            SetPedComponentVariation(ped, componentId, drawableId, textureId, paletteId)
            SetPedComponentVariation(ped, 2, selectedComponent, textureId, paletteId)
        end
        if item == comp3 then
            local selectedComponent = item:IndexToItem(index)
            SetPedComponentVariation(ped, componentId, drawableId, textureId, paletteId)
            SetPedComponentVariation(ped, 3, selectedComponent, textureId, paletteId)
        end
        if item == comp4 then
            local selectedComponent = item:IndexToItem(index)
            SetPedComponentVariation(ped, componentId, drawableId, textureId, paletteId)
            SetPedComponentVariation(ped, 4, selectedComponent, textureId, paletteId)
        end
        if item == comp5 then
            local selectedComponent = item:IndexToItem(index)
            SetPedComponentVariation(ped, componentId, drawableId, textureId, paletteId)
            SetPedComponentVariation(ped, 5, selectedComponent, textureId, paletteId)
        end
        if item == comp6 then
            local selectedComponent = item:IndexToItem(index)
            SetPedComponentVariation(ped, componentId, drawableId, textureId, paletteId)
            SetPedComponentVariation(ped, 6, selectedComponent, textureId, paletteId)
        end
        if item == comp7 then
            local selectedComponent = item:IndexToItem(index)
            SetPedComponentVariation(ped, componentId, drawableId, textureId, paletteId)
            SetPedComponentVariation(ped, 7, selectedComponent, textureId, paletteId)
        end
        if item == comp8 then
            local selectedComponent = item:IndexToItem(index)
            SetPedComponentVariation(ped, componentId, drawableId, textureId, paletteId)
            SetPedComponentVariation(ped, 8, selectedComponent, textureId, paletteId)
        end
        if item == comp9 then
            local selectedComponent = item:IndexToItem(index)
            SetPedComponentVariation(ped, componentId, drawableId, textureId, paletteId)
            SetPedComponentVariation(ped, 9, selectedComponent, textureId, paletteId)
        end
        if item == comp10 then
            local selectedComponent = item:IndexToItem(index)
            SetPedComponentVariation(ped, componentId, drawableId, textureId, paletteId)
            SetPedComponentVariation(ped, 10, selectedComponent, textureId, paletteId)
        end
        if item == comp11 then
            local selectedComponent = item:IndexToItem(index)
            SetPedComponentVariation(ped, componentId, drawableId, textureId, paletteId)
            SetPedComponentVariation(ped, 11, selectedComponent, textureId, paletteId)
        end
    end
end



_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Actions", "~b~Action Menu")
clothesMenu = NativeUI.CreateMenu("Clothes", "~b~Clothes Menu")


_menuPool:Add(mainMenu)
_menuPool:Add(clothesMenu)

itemMenu(mainMenu)
clothesMenuFunc(clothesMenu)
_menuPool:RefreshIndex()
mainMenu.Settings.MouseControlsEnabled = false
mainMenu.Settings.MouseEdgeEnabled = false
mainMenu.Settings.ControlDisablingEnabled = false
clothesMenu.Settings.MouseControlsEnabled = false
clothesMenu.Settings.MouseEdgeEnabled = false
clothesMenu.Settings.ControlDisablingEnabled = false

_progressBarPool = NativeUI.ProgressBarPool()
HackingProgressBar = NativeUI.CreateProgressBarItem("Hacking console...")
_progressBarPool:Add(HackingProgressBar)