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

function skinMenuFunc(menu)
    local skinList = NativeUI.CreateSliderItem("Skins", skins, skinIndexChangedto, true)
    menu:AddItem(skinList)
    menu.OnSliderChange = function(sender, item, index)
        if item == skinList then
            local selectedSkin = item:IndexToItem(index)
            print("Debug: "..tostring(index))
            skinIndexChangedto = index
            setSkin(selectedSkin)
        end
    end
end

function clothesMenuFunc(menu)
    componentText = {"Head","Mask","Hair","Arms","Legs","Bags & Parachutes","Shoes","Neck","Undershirt","Armour","Decals","Shirt"}
    ped = GetPlayerPed(-1)
    
    componentArray = {}
    compArray = {}
    for j = 0, 11 do
        local numVars = GetNumberOfPedDrawableVariations(ped, j)
        print("componentID: "..j.." vars: "..numVars)
        table.insert(componentArray, getComponentArray(numVars) )
        table.insert(compArray, NativeUI.CreateSliderItem(componentText[j+1], componentArray[j+1], 1, false) )
        if numVars > 1 then
            menu:AddItem(compArray[j+1])
        end
    end
    
    --[[ local component0 = getComponentArray(GetNumberOfPedDrawableVariations(ped, 0))
    local comp0 = NativeUI.CreateSliderItem("Head", component0, 1, false)
    menu:AddItem(comp0)
    
    local component1 = getComponentArray(GetNumberOfPedDrawableVariations(ped, 1))
    local component2 = getComponentArray(GetNumberOfPedDrawableVariations(ped, 2))
    local component3 = getComponentArray(GetNumberOfPedDrawableVariations(ped, 3))
    local component4 = getComponentArray(GetNumberOfPedDrawableVariations(ped, 4))
    local component5 = getComponentArray(GetNumberOfPedDrawableVariations(ped, 5))
    local component6 = getComponentArray(GetNumberOfPedDrawableVariations(ped, 6))
    local component7 = getComponentArray(GetNumberOfPedDrawableVariations(ped, 7))
    local component8 = getComponentArray(GetNumberOfPedDrawableVariations(ped, 8))
    local component9 = getComponentArray(GetNumberOfPedDrawableVariations(ped, 9))
    local component10 = getComponentArray(GetNumberOfPedDrawableVariations(ped, 10))
    local component11 = getComponentArray(GetNumberOfPedDrawableVariations(ped, 11))
    
    local comp1 = NativeUI.CreateSliderItem("Mask", component1, 1, false)
    local comp2 = NativeUI.CreateSliderItem("Hair", component2, 1, false)
    local comp3 = NativeUI.CreateSliderItem("Arms", component3, 1, false)
    local comp4 = NativeUI.CreateSliderItem("Legs", component4, 1, false)
    local comp5 = NativeUI.CreateSliderItem("Bags & Parachutes", component5, 1, false)
    local comp6 = NativeUI.CreateSliderItem("Shoes", component6, 1, false)
    local comp7 = NativeUI.CreateSliderItem("Neck", component7, 1, false)
    local comp8 = NativeUI.CreateSliderItem("Undershirt", component8, 1, false)
    local comp9 = NativeUI.CreateSliderItem("Armour", component9, 1, false)
    local comp10 = NativeUI.CreateSliderItem("Decals", component10, 1, false)
    local comp11 = NativeUI.CreateSliderItem("Shirt", component11, 1, false)
    
    
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
    menu:AddItem(comp11)--]]

    local ped = GetPlayerPed(-1)
    local textureId = 0
    local paletteId = 0
    
    menu.OnSliderChange = function(sender, item, index)
        for k = 1, 12 do
            if item == compArray[k] then
                local selectedComponent = item:IndexToItem(index)
                SetPedComponentVariation(ped, k-1, selectedComponent, textureId, paletteId)
            end
        end
        --[[if item == compArray[2] then
            local selectedComponent = item:IndexToItem(index)
            SetPedComponentVariation(ped, 1, selectedComponent, textureId, paletteId)
        end
        if item == compArray[3] then
            local selectedComponent = item:IndexToItem(index)
            SetPedComponentVariation(ped, 2, selectedComponent, textureId, paletteId)
        end
        if item == compArray[4] then
            local selectedComponent = item:IndexToItem(index)
            SetPedComponentVariation(ped, 3, selectedComponent, textureId, paletteId)
        end
        if item == compArray[5] then
            local selectedComponent = item:IndexToItem(index)
            SetPedComponentVariation(ped, 4, selectedComponent, textureId, paletteId)
        end
        if item == compArray[6] then
            local selectedComponent = item:IndexToItem(index)
            SetPedComponentVariation(ped, 5, selectedComponent, textureId, paletteId)
        end
        if item == compArray[7] then
            local selectedComponent = item:IndexToItem(index)
            SetPedComponentVariation(ped, 6, selectedComponent, textureId, paletteId)
        end
        if item == compArray[8] then
            local selectedComponent = item:IndexToItem(index)
            SetPedComponentVariation(ped, 7, selectedComponent, textureId, paletteId)
        end
        if item == compArray[9] then
            local selectedComponent = item:IndexToItem(index)
            SetPedComponentVariation(ped, 8, selectedComponent, textureId, paletteId)
        end
        if item == compArray[10] then
            local selectedComponent = item:IndexToItem(index)
            SetPedComponentVariation(ped, 9, selectedComponent, textureId, paletteId)
        end
        if item == compArray[11] then
            local selectedComponent = item:IndexToItem(index)
            SetPedComponentVariation(ped, 10, selectedComponent, textureId, paletteId)
        end
        if item == compArray[12] then
            local selectedComponent = item:IndexToItem(index)
            SetPedComponentVariation(ped, 11, selectedComponent, textureId, paletteId)
        end--]]
    end
end

-- TODO:only in here for testing
--setSkin("mp_m_freemode_01")
function setUpMenus()
    _menuPool = NativeUI.CreatePool()
    mainMenu = NativeUI.CreateMenu("Actions", "~b~Action Menu")
    clothesMenu = NativeUI.CreateMenu("Clothes", "~b~Clothes Menu")
    skinMenu = NativeUI.CreateMenu("Skins", "~b~Skin Menu")

    _menuPool:Add(mainMenu)
    _menuPool:Add(clothesMenu)
    _menuPool:Add(skinMenu)

    itemMenu(mainMenu)
    clothesMenuFunc(clothesMenu)
    print("debug: about to call skinMenu")
    skinMenuFunc(skinMenu)
    _menuPool:RefreshIndex()
    mainMenu.Settings.MouseControlsEnabled = false
    mainMenu.Settings.MouseEdgeEnabled = false
    mainMenu.Settings.ControlDisablingEnabled = false
    clothesMenu.Settings.MouseControlsEnabled = false
    clothesMenu.Settings.MouseEdgeEnabled = false
    clothesMenu.Settings.ControlDisablingEnabled = false
    skinMenu.Settings.MouseControlsEnabled = false
    skinMenu.Settings.MouseEdgeEnabled = false
    skinMenu.Settings.ControlDisablingEnabled = false
end
skinIndexChangedto = 1
setUpMenus()

_progressBarPool = NativeUI.ProgressBarPool()
HackingProgressBar = NativeUI.CreateProgressBarItem("Hacking console...")
_progressBarPool:Add(HackingProgressBar)

function changeSkinMenu()
    _menuPool:Remove(clothesMenu)
    clothesMenu = NativeUI.CreateMenu("Clothes", "~b~Clothes Menu")
    _menuPool:Add(clothesMenu)
    clothesMenuFunc(clothesMenu)
    _menuPool:RefreshIndex()
    clothesMenu.Settings.MouseControlsEnabled = false
    clothesMenu.Settings.MouseEdgeEnabled = false
    clothesMenu.Settings.ControlDisablingEnabled = false
end

RegisterCommand("setSkin", function(source, args)
    setSkin( skins[ tonumber(args[1]) ] )
    print( skins[ tonumber(args[1]) ] )
end)

RegisterCommand("skinPreview", function(source, args)
    local currentSkinIndex = 1
    local DrawTextForSkin = true
    SetGameplayCamRelativeHeading(180.0)
    Citizen.CreateThread(function()
        for i = 183, #skins do
            currentSkinIndex = i
            setSkin(skins[i])
            --setSkin("mp_m_freemode_01")
            --print(skins[i])
            Wait(5000)
            InvalidateIdleCam()
            N_0x9e4cfff989258472()
        end
        DrawTextForSkin = false
    end)

    Citizen.CreateThread(function()
        while DrawTextForSkin do
            SetGameplayCamRelativeHeading(180.0)
            Draw3DText(GetEntityCoords(GetPlayerPed(-1), false), skins[currentSkinIndex] )
            Wait(1)
        end
    end)
end)

Citizen.CreateThread(function()
    while true do
        Wait(1)
        if skinMenu:Visible() then
            SetGameplayCamRelativeHeading(180.0)
            Draw3DText(GetEntityCoords(GetPlayerPed(-1), false), skins[currentSkinIndex] )
        end
    end
end)

lastModel = 0
skinJustUpdated = false

function setSkin(skin)
    Citizen.CreateThread(function()
        if lastModel ~= 0 then
            SetModelAsNoLongerNeeded(lastModel)
        end
        local model = GetHashKey(skin)
        RequestModel(model)
        lastModel = model
        while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
        end
        SetPlayerModel(PlayerId(), model)
        --setUpMenus()
        SetPedComponentVariation(GetPlayerPed(-1), 0, 0, 0, 0)
        skinJustUpdated = true
    end)
end