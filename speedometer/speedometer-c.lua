-- Test lua script for FiveM
_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Actions", "~b~Action Menu")

_menuPool:Add(mainMenu)

RegisterNetEvent('BankDoor:OpenClient')
AddEventHandler('BankDoor:OpenClient', function(doorID)
    print("Door opened: "..doorID)
    --print("Debug2:"..bankDoors[2].open)
    changeDoorHeading(doorID, bankDoors[tonumber(doorID)].open)
end)

RegisterNetEvent('BankDoor:CloseClient')
AddEventHandler('BankDoor:CloseClient', function(doorID)
    print("Door closed: "..doorID)
    changeDoorHeading(doorID, bankDoors[tonumber(doorID)].closed)
end)

RegisterCommand("debugDisplay", function(source, args)
    --print("Debug"..args[1])
    if args[1] ~= nil then
        if tonumber(args[1]) == 1 then
            DEBUG_DISPLAY = true
        else
            DEBUG_DISPLAY = false
        end
    else
        if DEBUG_DISPLAY then
            DEBUG_DISPLAY = false
        else
            DEBUG_DISPLAY = true
        end
    end
    --print("Debug: "..tostring(DEBUG_DISPLAY))
    threadFrame  = 0
end)

RegisterCommand("bo", function(source, args)
    local doorID = args[1]
    --local doorID = closestObjectIDtoCoords(bankDoors[doorID].pos)
    --openBankDoor(doorID)
    TriggerServerEvent("BankDoor:OpenServer", doorID)
end)

RegisterCommand("bc", function(source, args)
    local doorID = args[1]
    --local doorID = closestObjectIDtoCoords(bankDoors[i].pos)
    --closeBankDoor(doorID)
    TriggerServerEvent("BankDoor:CloseServer", doorID)
end)

RegisterCommand("posObject", function(source)
    local objectID = closestObjectID()
    local coords = GetEntityCoords(objectID, false)
    print("ObjectCoords: "..coords.x..", "..coords.y..", "..coords.z)
end)

RegisterCommand("pos", function(source)
    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    outputString = "X: " .. x .." Y: " .. y .." Z: " .. z
    TriggerEvent("chatMessage", "[GPS]", {0,255,0}, outputString)
end)

RegisterCommand("tp", function(source, args)
    local vTarget = vector3(1726.05,3239.42,41.54)
    if args[1] ~= nil and args[2] ~= nil and args[3] ~= nil then
        vTarget = vector3(tonumber(args[1]), tonumber(args[2]),tonumber(args[3]))
    end
    SetPedCoordsKeepVehicle(GetPlayerPed(-1), vTarget.x, vTarget.y, vTarget.z)
end)

RegisterCommand("tpb", function(source, args)
    tpBank(tonumber(args[1]))
end)

RegisterCommand("deleteVehicle", function(source)
    local veh  = closestVehicleID()
    SetEntityAsMissionEntity(veh, true, true)
    DeleteVehicle(veh)
    TriggerEvent("chatMessage", "[DELETED V]", {0,255,0}, veh)
end)

RegisterCommand("deletePed", function(source)
    local ped  = closestPedID()
    --SetEntityAsMissionEntity(veh, true, true)
    DeletePed(ped)
    TriggerEvent("chatMessage", "[DELETED P]", {0,255,0}, ped)
end)

RegisterCommand("blips", function(source)
    blipsVisible = not blipsVisible
    if blipsVisible then
        SetBlipDisplay(blip1, 6)
        SetBlipDisplay(blip2, 6)
        SetBlipDisplay(blip3, 6)
        SetBlipDisplay(blip4, 6)
        SetBlipDisplay(blip5, 6)
    else
        SetBlipDisplay(blip1, 0)
        SetBlipDisplay(blip2, 0)
        SetBlipDisplay(blip3, 0)
        SetBlipDisplay(blip4, 0)
        SetBlipDisplay(blip5, 0)
    end
end)

RegisterCommand("lineSpawner", function(source)
    lineSpawner()
end)

RegisterCommand("kidnap", function(source)
    kidnapPed()
end)

RegisterCommand("fightclub", function(source)
    fightclub()
end)

RegisterCommand("trackV", function(source)
    trackVehicle()
end)

RegisterCommand("trackP", function(source)
    trackPed()
end)

RegisterCommand("medic", function(source)
    medicPed()
end)

RegisterCommand("police", function(source)
    policePed()
end)

RegisterCommand("weather", function(source)
    weather()
end)

-- Functions
--------------------------------------------------------------------------

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
            openBankDoor(tonumber(selectedBank))
            notify("~g~Opened Bank Door "..tonumber(selectedBank))
        end
        if item == closelist then
            local selectedBank = item:IndexToItem(index)
            closeBankDoor(tonumber(selectedBank))
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

function getTPPnames()
    local names = {}
    for _,item in ipairs(tpCoords) do
        table.insert(names,item.name)
    end
    return names
end

function closeBankDoor(doorID)
    TriggerServerEvent("BankDoor:CloseServer", doorID)
end

function openBankDoor(doorID)
    TriggerServerEvent("BankDoor:OpenServer", doorID)
end

function changeDoorHeading(doorID, heading)
    bankDoorID = closestObjectIDtoCoords(bankDoors[tonumber(doorID)].pos)
    SetEntityCanBeDamaged(bankDoorID, false)
    NetworkRequestControlOfEntity(bankDoorID)
    SetEntityHeading(bankDoorID, tonumber(heading))
end

function tpBank(bankID)
    SetPedCoordsKeepVehicle(GetPlayerPed(-1), banks[bankID].x, banks[bankID].y, banks[bankID].z)
end

function tpSpecial(name)
    for _,item in pairs(tpCoords) do
        if item.name == name then
            SetPedCoordsKeepVehicle(GetPlayerPed(-1), item.coords.x, item.coords.y, item.coords.z)
        end
    end
end

function notify(msg)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(true,false)
end

function checkDoor()
    doorID = closestObjectID()
    Heading = GetEntityHeading(doorID)
    print("Heading "..Heading)
end

function lockDoor()
    doorID = closestObjectID()
    NetworkRequestControlOfEntity(doorID)
    FreezeEntityPosition(doorID, true)
end

function unlockDoor()
    doorID = closestObjectID()
    NetworkRequestControlOfEntity(doorID)
    FreezeEntityPosition(doorID, false)
end

function openDoor(Heading)
    doorID = closestObjectID()
    SetEntityCanBeDamaged(doorID, false)
    NetworkRequestControlOfEntity(doorID)
    SetEntityHeading(doorID, tonumber(Heading))
end

function trackVehicle()
    AddBlipForEntity(closestVehicleID())
end

function trackPed()
    SetEntityAsMissionEntity(ped, true, false)
    AddBlipForEntity(closestPedID())
end

function medicPed()
    local ped = closestDeadPedID()
    --NetworkSetMissionFinished()
    --local q = IsEntityAMissionEntity(ped)
    print("debug: closestDeadPedID:"..ped.." mission: "..tostring(q))
    CreateIncidentWithEntity(5, ped, 2, 3.0)
end

function policePed()
    local ped = closestPedID()
    --NetworkSetMissionFinished()
    --local q = IsEntityAMissionEntity(ped)
    print("debug: closestDeadPedID:"..ped.." mission: "..tostring(q))
    CreateIncidentWithEntity(7, ped, 2, 3.0)
end

function weather()
    print(tostring(GetNextWeatherTypeHashName()))
    --SetWeatherTypeNowPersist("RAIN")
    SetWeatherTypeOverTime("THUNDER", 10)
    --SetWeatherTypeOverTime("CLEAR", 30000)
    --[["CLEAR"  
        "EXTRASUNNY"  
        "CLOUDS"  
        "OVERCAST"  
        "RAIN"  
        "CLEARING"  
        "THUNDER"  
        "SMOG"  
        "FOGGY"  
        "XMAS"  
        "SNOWLIGHT"  
        "BLIZZARD"--]]
end

function kidnapPed()
    local ped = closestPedID()
    SetEntityAsMissionEntity(ped, true, false)
    ClearPedTasksImmediately(ped)
    SetBlockingOfNonTemporaryEvents(ped, true)
    local vehicle = closestVehicleID()
    local timeout = 15000
    local seat = 0
    local speed = 1.0
    local flag = 1
    local p6 = 0
    TaskEnterVehicle(ped, vehicle, timeout, seat, speed, flag, p6)
end

function fightclub()
    local peds = closestNPedIDs(2)
    local ped = peds[1][1]
    local targetped = peds[2][1]
    SetEntityAsMissionEntity(ped, true, false)
    ClearPedTasksImmediately(ped)
    --SetBlockingOfNonTemporaryEvents(ped, true)
    SetEntityAsMissionEntity(targetped, true, false)
    ClearPedTasksImmediately(targetped)
    --SetBlockingOfNonTemporaryEvents(targetped, true)
    TaskCombatPed(ped, targetped, 0, 16)
    TaskCombatPed(targetped, ped, 0, 16)
end

function lineSpawner()
    local vStart = vector3(1719.97, 3239.41, 41.15)
    local vEnd = vector3(1712.10, 3267.57, 41.15)
    local num = 10

    local vLine = vector3(vEnd.x-vStart.x, vEnd.y-vStart.y, vEnd.z-vStart.z)
    local carHeading  = GetHeadingFromVector_2d(vLine.x, vLine.y) + 90.0

    for i = 1, num do
        local grid = (i-1)/(num-1)
        local x = vStart.x + (vLine.x * grid)
        local y = vStart.y + (vLine.y * grid)
        local z = vStart.z + (vLine.z * grid)

        local car = GetHashKey(carNames[i])
        RequestModel(car)
        while not HasModelLoaded(car) do
            RequestModel(car)
            Citizen.Wait(0)
        end
        vehicles[i] = CreateVehicle(car, x, y, z, carHeading, true, false)
        SetEntityAsMissionEntity(vehicles[i], true, true)
        TriggerEvent("chatMessage", "[SPAWNED]", {0,255,0}, GetVehicleNumberPlateText(vehicles[i]).." "..car.." V: "..vehicles[i])
    end
end

function addBlip(v, sprite, label)
    local blip = AddBlipForCoord(v.x, v.y)
    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 6)
    SetBlipScale(blip, 0.9)
    BeginTextCommandSetBlipName("STRING");
    AddTextComponentString(label)
    EndTextCommandSetBlipName(blip)
    return blip
end

function text(content) 
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(0.5,0.5)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(content)
    DrawText(0.01,0.75)
end

function bottomText(content) 
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(0.5,0.5)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(content)
    DrawText(0.5,0.90)
end

function Draw3DText(v, text)
    SetDrawOrigin(v.x, v.y, v.z, 0)
    SetTextScale(0.0, 0.35)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(0, 0)
    ClearDrawOrigin()
end

function closestVehicleID()
    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local nearest = 1000000
    local closest = 0
    for veh in EnumerateVehicles() do
        vehcoords = GetEntityCoords(veh)
        distance = Vdist2(x, y, z, vehcoords.x, vehcoords.y, vehcoords.z, true)
        if (distance < nearest) then
            nearest = distance
            closest = veh
        end
        --print("ID: "..veh.." Coords: "..vehcoords.." Dist: "..distance)
    end
    --print("ClosestID: ".. closest)
    return closest
end

function closestPedID()
    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local nearest = 1000000
    local closest = 0
    for ped in EnumeratePeds() do
        if pedIsValidTarget(ped) then
            pedcoords = GetEntityCoords(ped)
            distance = Vdist2(x, y, z, pedcoords.x, pedcoords.y, pedcoords.z)
            if (distance < nearest) then
                nearest = distance
                closest = ped
            end
        end
    end
    return closest
end

function closestDeadPedID()
    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local nearest = 1000000
    local closest = 0
    for ped in EnumeratePeds() do
        if pedIsValidVictim(ped) then
            pedcoords = GetEntityCoords(ped)
            distance = Vdist2(x, y, z, pedcoords.x, pedcoords.y, pedcoords.z)
            if (distance < nearest) then
                nearest = distance
                closest = ped
            end
        end
    end
    return closest
end

function closestPedIDignore(ignore)
    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local nearest = 1000000
    local closest = 0
    for ped in EnumeratePeds() do
        if ignore ~= ped and pedIsValidTarget(ped) then
            pedcoords = GetEntityCoords(ped)
            distance = Vdist2(x, y, z, pedcoords.x, pedcoords.y, pedcoords.z)
            if (distance < nearest) then
                nearest = distance
                closest = ped
            end
        end
    end
    return closest
end

function closestNPedIDs(N)
    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local peds = {}
    for ped in EnumeratePeds() do
        if pedIsValidTarget(ped) then
            pedcoords = GetEntityCoords(ped)
            local distance = Vdist2(x, y, z, pedcoords.x, pedcoords.y, pedcoords.z)
            table.insert(peds, {ped,distance})            
        end
    end
    local nearestNPeds = sortPedsByDistance(peds, N)
    return nearestNPeds
end

function pedIsValidTarget(ped)
    local isInVehicle = GetVehiclePedIsIn(ped, false) ~= 0
    return ped ~= GetPlayerPed(-1) and not isInVehicle and not IsPedDeadOrDying(ped) and IsPedHuman(ped)
    --return ped ~= GetPlayerPed(-1) and not isInVehicle and IsPedHuman(ped)
end

function pedIsValidVictim(ped)
    local isInVehicle = GetVehiclePedIsIn(ped, false) ~= 0
    return ped ~= GetPlayerPed(-1) and not isInVehicle and IsPedHuman(ped) and IsPedDeadOrDying(ped)
end

function closestObjectID()
    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local coords = vector3(x, y, z)
    return closestObjectIDtoCoords(coords)
end

function closestObjectIDtoCoords(coords)
    local x = coords.x
    local y = coords.y
    local z = coords.z
    local nearest = 1000000
    local closest = 0
    for obj in EnumerateObjects() do
        local isInVehicle = GetVehiclePedIsIn(obj, false) ~= 0
        if obj ~= GetPlayerPed(-1) then
            objcoords = GetEntityCoords(obj)
            distance = Vdist2(x, y, z, objcoords.x, objcoords.y, objcoords.z, true)
            if (distance < nearest) then
                nearest = distance
                closest = obj
            end
        end
    end
    return closest
end

function startTimer()
    timerStart = GetGameTimer()
    timerRunning = true
    timerVisible = true
end

function stopTimer()
    timerEnd = timer
    timerRunning = false
    timerVisible = true
end

function startSpeedTimer()
    speedTimerRunning = true
    timerWaitingToStart = true
    --startTimer()
end

function stopSpeedTimer()
    speedTimerRunning = false
    stopTimer()
end

-- Variables (More set in config.lua)

local blip1 = addBlip(v1, 225, "1")
local blip2 = addBlip(v2, 225, "2")
local blip3 = addBlip(v3, 225, "3")
local blip4 = addBlip(v4, 225, "4")
local blip5 = addBlip(v5, 225, "5")
local blip6 = addBlip(v5, 225, "5")
local blipsVisible = true

itemMenu(mainMenu)
_menuPool:RefreshIndex()
mainMenu.Settings.MouseControlsEnabled = false
mainMenu.Settings.MouseEdgeEnabled = false
mainMenu.Settings.ControlDisablingEnabled = false

-- Threads
---------------------------------------------------------------------------

-- Timer Thread
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if timerRunning then
            timer = GetGameTimer() - timerStart
        end
        if timerVisible then
            bottomText("Timer: "..tostring(timer/1000))
        end
        if speedTimerRunning then
            if(IsPedInAnyVehicle(GetPlayerPed(-1), false)) then
                local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                local speed = tonumber(GetEntitySpeed(vehicle)*2.2369)
                if (speed >= limitBottom) and (timerWaitingToStart) then
                    timerWaitingToStart = false
                    startTimer()
                end
                if (speed >= limitTop) and (speedTimerRunning) then
                    stopSpeedTimer()
                end
            end
        end
    end
end)

-- Menu Activation Thread
Citizen.CreateThread(function()
    --print("debug: menu")
    while true do
        Citizen.Wait(1)
        _menuPool:ProcessMenus()
        --[[ The "z" button will activate the menu ]]
        if IsControlJustReleased(1, 48) then
            --print("debug: "..tostring(mainMenu.MouseControlsEnabled))
            mainMenu:Visible(not mainMenu:Visible())
            --print("debug: menu")
        end
    end
end)

-- Vehicle Hud Thread
Citizen.CreateThread(function()

    while true do
        Citizen.Wait(1)
        -- Condition to check if the ped is in a vehicle
        if(IsPedInAnyVehicle(GetPlayerPed(-1), false)) then
            local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
            local speed = (GetEntitySpeed(vehicle)*2.2369)
            
            local gear  = GetVehicleCurrentGear(vehicle)
            local fuel = GetVehicleFuelLevel(vehicle)
            local clutch  = GetVehicleClutch(vehicle)
            local rpm  = GetVehicleCurrentRpm(vehicle)
            --local accel = GetVehicleCurrentAcceleration(vehicle)
            local maxV = GetVehicleHandlingInt(vehicle, 'CHandlingData', 'fInitialDriveMaxFlatVel')
            local driveF = GetVehicleHandlingInt(vehicle, 'CHandlingData', 'fEngineDamageMult')
            local health = GetVehicleEngineHealth(vehicle)
            SetVehicleEnginePowerMultiplier(vehicle , 10.0)
                    
            --text(math.floor(speed) .. " MPH ")
            text(
                math.floor(speed) 
                .. " MPH - Gear " 
                .. math.floor(gear) 
                .. " - Fuel " 
                .. math.floor(fuel) 
                .. " - rpm " 
                .. math.floor(rpm*8000) 
                .. " - MaxV " 
                .. maxV
                .. " - health " 
                .. health
            )
        end
    end
end)

-- Debug Display Thread
Citizen.CreateThread(function()
    threadFrame  = 0
    local closestPed, secondClosest, closestObject
    while true do
        Citizen.Wait(1)
        if DEBUG_DISPLAY then
            Draw3DText(GetEntityCoords(closestVehicleID()), "Vehicle")
            local deadPed = closestDeadPedID()
            if threadFrame == 0 then
                local peds = closestNPedIDs(2)
                
                if peds ~= nil and peds[1] ~= nil and peds[2] ~= nil then
                    closestPed = peds[1][1]
                    secondClosest = peds[2][1]
                    --closestObject = closestObjectID()
                else
                    closestPed = 0
                    secondClosest = 0
                end
            end
            --local headingObject = GetEntityPhysicsHeading(closestObject)
            --local pedGroup = GetPedGroupIndex(closestPed)
            --local groupHash = GetPedRelationshipGroupHash(closestPed)
            distToDeadPed = GetDistanceBetweenCoords(GetEntityCoords(deadPed), GetEntityCoords(GetPlayerPed(-1)), true)
            Draw3DText(GetEntityCoords(closestPed), "Ped "..GetEntityHealth(closestPed))
            Draw3DText(GetEntityCoords(secondClosest), "Ped "..GetEntityHealth(secondClosest))
            if distToDeadPed < 200.0 then
                Draw3DText(GetEntityCoords(deadPed), "Dead Ped "..GetEntityHealth(deadPed).." "..tostring(math.floor(distToDeadPed)))
            end
            --Draw3DText(GetEntityCoords(closestObject), "Object "..closestObject.." "..headingObject)
        end
        threadFrame = threadFrame + 1
        if threadFrame >= threadLimit then
            threadFrame = 0
        end
    end
end)

-- Marker Thread
CreateThread(function()
    while true do
        -- draw every frame
        Wait(0)
        DrawMarker(
            23,         -- type
            v1.x,       -- posX
            v1.y,       -- posY
            v1ground + 0.1, -- posZ
            0.0,        -- dirX
            0.0,        -- dirY
            0.0,        -- dirZ
            0.0,        -- rotX
            180.0,      -- rotY
            0.0,        -- rotZ
            1.0,        -- scaleX
            1.0,        -- scaleY
            1.0,        -- scaleZ
            255,        -- red
            0,        -- green
            0,          -- blue
            200,         -- alpha
            false,      -- bobUpAndDown
            true,       -- faceCamera
            2,          -- p19
            nil,        -- rotate
            nil,        
            false
        )
    end
end)

-- AI Density Thread
DensityMultiplier = 0.9
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        SetVehicleDensityMultiplierThisFrame(DensityMultiplier)
        SetPedDensityMultiplierThisFrame(DensityMultiplier)
        SetRandomVehicleDensityMultiplierThisFrame(DensityMultiplier)
        SetParkedVehicleDensityMultiplierThisFrame(DensityMultiplier)
        SetScenarioPedDensityMultiplierThisFrame(DensityMultiplier, DensityMultiplier)
    end
end)


--entityEnumerator
---------------------------------------------------------------

local entityEnumerator = {
  __gc = function(enum)
    if enum.destructor and enum.handle then
      enum.destructor(enum.handle)
    end
    enum.destructor = nil
    enum.handle = nil
  end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
  return coroutine.wrap(function()
    local iter, id = initFunc()
    if not id or id == 0 then
      disposeFunc(iter)
      return
    end
    
    local enum = {handle = iter, destructor = disposeFunc}
    setmetatable(enum, entityEnumerator)
    
    local next = true
    repeat
      coroutine.yield(id)
      next, id = moveFunc(iter)
    until not next
    
    enum.destructor, enum.handle = nil, nil
    disposeFunc(iter)
  end)
end

function EnumerateObjects()
  return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function EnumeratePeds()
  return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
  return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumeratePickups()
  return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end

function pairsByKeys(t, f)
  local a = {}
  for n in pairs(t) do table.insert(a, n) end
  table.sort(a, f)
  local i = 0      -- iterator variable
  local iter = function ()   -- iterator function
    i = i + 1
    if a[i] == nil then return nil
    else return a[i], t[ a[i] ]
    end
  end
  return iter
end

function sortPedsByDistance(t, num)
    local keys = {}
    
    for k in pairs(t) do table.insert(keys, k) end
    
    table.sort(keys, function(a, b) return t[a][2] < t[b][2] end)

    local numCount = 1
    local closestNPeds = {}
    for _, k in ipairs(keys) do
        if numCount <= num then
            table.insert(closestNPeds, {t[k][1], t[k][2]})
            numCount = numCount + 1
        end
    end
    return closestNPeds
end