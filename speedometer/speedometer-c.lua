-- Test lua script for FiveM
_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Actions", "~b~Action Menu")

_menuPool:Add(mainMenu)

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
    
    menu:AddItem(startT)
    menu:AddItem(stopT)
    menu:AddItem(hideT)
    menu:AddItem(startST)
    menu:AddItem(click)
    menu:AddItem(tplist)
    menu:AddItem(openlist)
    menu:AddItem(closelist)
    menu:AddItem(emotes)

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
    end
end

itemMenu(mainMenu)
_menuPool:RefreshIndex()
mainMenu.Settings.MouseControlsEnabled = false
mainMenu.Settings.MouseEdgeEnabled = false
mainMenu.Settings.ControlDisablingEnabled = false

print("debugnow: "..tostring(mainMenu.MouseControlsEnabled))



DEBUG_DISPLAY = true

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

function changeDoorHeading(doorID, heading)
    bankDoorID = closestObjectIDtoCoords(bankDoors[tonumber(doorID)].pos)
    SetEntityCanBeDamaged(bankDoorID, false)
    NetworkRequestControlOfEntity(bankDoorID)
    SetEntityHeading(bankDoorID, tonumber(heading))
end

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

RegisterCommand("debugTest", function(source, args)
    local npeds = closestNPedIDs(5)
    for ped in npeds do
        print(ped)
    end
end)

RegisterCommand("bo", function(source, args)
    local doorID = args[1]
    --local doorID = closestObjectIDtoCoords(bankDoors[doorID].pos)
    openBankDoor(doorID)
end)

function openBankDoor(doorID)
    TriggerServerEvent("BankDoor:OpenServer", doorID)
end

RegisterCommand("bc", function(source, args)
    local doorID = args[1]
    --local doorID = closestObjectIDtoCoords(bankDoors[i].pos)
    closeBankDoor(doorID)
end)

function closeBankDoor(doorID)
    TriggerServerEvent("BankDoor:CloseServer", doorID)
end

RegisterCommand("posObject", function(source)
    local objectID = closestObjectID()
    local coords = GetEntityCoords(objectID, false)
    print("ObjectCoords: "..coords.x..", "..coords.y..", "..coords.z)
end)

RegisterCommand("fuel", function(source, args)
    if(IsPedInAnyVehicle(GetPlayerPed(-1), false)) then
        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
        SetVehicleFuelLevel(vehicle,tonumber(args[1]))
        --Citizen.Trace(tostring(args[1]))
    end
end)

RegisterCommand("maxv", function(source, args)
    if(IsPedInAnyVehicle(GetPlayerPed(-1), false)) then
        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
        SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fInitialDriveMaxFlatVel', tonumber(args[1]))
    end
end)

RegisterCommand("pos", function(source)
    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    outputString = "X: " .. x .." Y: " .. y .." Z: " .. z
    TriggerEvent("chatMessage", "[GPS]", {0,255,0}, outputString)
end)

RegisterCommand("testcar", function(source, args)
    spawnCar(args[1])
    TriggerEvent("chatMessage", "[SPAWNED]", {0,255,0}, args[1])
end)

RegisterCommand("testcars", function(source)
    spawnCars()
    --TriggerEvent("chatMessage", "[SPAWNED]", {0,255,0}, "cars")
end)

RegisterCommand("tp", function(source, args)
    local vTarget = vector3(1726.05,3239.42,41.54)
    if args[1] ~= nil and args[2] ~= nil and args[3] ~= nil then
        --print("vTarget.x = "..vTarget.x.."type: "..type(vTarget.x))
        --print("vTarget.y = "..vTarget.y.."type: "..type(vTarget.y))
        --print("vTarget.z = "..vTarget.z.."type: "..type(vTarget.z))
        --print("args[1] = "..args[1].."type: "..type(tonumber(args[1])))
        --print("args[2] = "..args[2].."type: "..type(tonumber(args[2])))
        --print("args[3] = "..args[3].."type: "..type(tonumber(args[3])))
        --vTarget.x = tonumber(args[1])
        --vTarget.y = tonumber(args[2])
        --vTarget.z = tonumber(args[3])
        vTarget = vector3(tonumber(args[1]), tonumber(args[2]),tonumber(args[3]))
    end
    SetPedCoordsKeepVehicle(GetPlayerPed(-1), vTarget.x, vTarget.y, vTarget.z)
end)

RegisterCommand("tpb", function(source, args)
    tpBank(tonumber(args[1]))
end)

function tpBank(bankID)
    SetPedCoordsKeepVehicle(GetPlayerPed(-1), banks[bankID].x, banks[bankID].y, banks[bankID].z)
end

RegisterCommand("tpp", function(source)
    --RequestIpl("bkr_biker_interior_placement_interior_3_biker_dlc_int_ware02_milo")
    local serverFarm =  vector3(895.5518,-3246.038, -98.04907)
    SetPedCoordsKeepVehicle(GetPlayerPed(-1), serverFarm.x, serverFarm.y, serverFarm.z)
end)

RegisterCommand("boom", function(source)
    --ExplodeVehicle(vehicles[tonumber(args[1])],true,true)
    for i = 1, 5 do
        DeleteVehicle(vehicles[i])
        TriggerEvent("chatMessage", "[BOOM]", {0,255,0}, vehicles[i])
    end
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

RegisterCommand("closest", function(source)
    print(closestVehicleID())
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

RegisterCommand("openDoor", function(source, args)
    openDoor(tonumber(args[1]))
end)

RegisterCommand("checkDoor", function(source, args)
    checkDoor()
end)

RegisterCommand("lockDoor", function(source)
    lockDoor()
end)

RegisterCommand("unlockDoor", function(source)
    unlockDoor()
end)




-- Functions
--------------------------------------------------------------------------

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

function spawnCars()
    for i = 1, 5 do
        local car = GetHashKey(carNames[i])
        RequestModel(car)
        while not HasModelLoaded(car) do
            RequestModel(car)
            Citizen.Wait(0)
        end
        vehicles[i] = CreateVehicle(car, v1.x, v1.y +((i-1)*5), v1.z, 90.0, true, false)
        SetEntityAsMissionEntity(vehicles[i], true, true)
        TriggerEvent("chatMessage", "[SPAWNED]", {0,255,0}, GetVehicleNumberPlateText(vehicles[i]).." "..car.." V: "..vehicles[i])
    end
end

function spawnCar(car)
    local car = GetHashKey(car)

    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(0)
    end

    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local vehicle = CreateVehicle(car, v1.x, v1.y, v1.z, 90.0, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
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
        if IsPedHuman(ped) then
            local isInVehicle = GetVehiclePedIsIn(ped, false) ~= 0
            if ped ~= GetPlayerPed(-1) and not isInVehicle then
                pedcoords = GetEntityCoords(ped)
                distance = Vdist2(x, y, z, pedcoords.x, pedcoords.y, pedcoords.z)
                if (distance < nearest) then
                    nearest = distance
                    closest = ped
                end
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
        if IsPedHuman(ped) and (ignore ~= ped) then
            local isInVehicle = GetVehiclePedIsIn(ped, false) ~= 0
            if ped ~= GetPlayerPed(-1) and not isInVehicle then
                pedcoords = GetEntityCoords(ped)
                distance = Vdist2(x, y, z, pedcoords.x, pedcoords.y, pedcoords.z)
                if (distance < nearest) then
                    nearest = distance
                    closest = ped
                end
            end
        end
    end
    return closest
end

function closestNPedIDs(N)
    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local peds = {}
    for ped in EnumeratePeds() do
        local isInVehicle = GetVehiclePedIsIn(ped, false) ~= 0
        if ped ~= GetPlayerPed(-1) and not isInVehicle and not IsPedDeadOrDying(ped) then
            pedcoords = GetEntityCoords(ped)
            local distance = Vdist2(x, y, z, pedcoords.x, pedcoords.y, pedcoords.z)
            table.insert(peds, {ped,distance})            
        end
    end
    local nearestNPeds = sortPedsByDistance(peds, N)
    return nearestNPeds
end

runOnceFlag = true
function runOnce(distances)
    if runOnceFlag then
        runOnceFlag = false
        for i, n in pairs(distances) do
            --print("Debug: in runOnce")
            print("i: "..i.." n: "..n)
        end
    end
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

-- Variables
--------------------------------------------------------------------------
limitBottom = 1.0
limitTop = 100.0
timerWaitingToEnd   = false
timerWaitingToStart = false
timerVisible = false
timerRunning = false
speedTimerRunning = false
timerStart   = 0
timerEnd     = 0
timer        = 0

threadFrame  = 0
threadLimit  = 20

vehicles = {0,0,0,0,0}
v1 = vector3(1726.0500488281, 3239.4248046875, 41.545928955078)
v2 = vector3(1726.0500488281, 3244.4248046875, 41.545928955078)
v3 = vector3(1726.0500488281, 3249.4248046875, 41.545928955078)
v4 = vector3(1726.0500488281, 3254.4248046875, 41.545928955078)
v5 = vector3(1726.0500488281, 3259.4248046875, 41.545928955078)
local unusedBool, v1ground = GetGroundZFor_3dCoord(v1.x, v1.y, v1.z, 0)
local vBank1 = vector3(255.51, 226.60, 101.87)
local vBank2 = vector3(-2957.44, 480.30, 15.70)
local vBank3 = vector3(-104.17, 6470.57, 31.62)
local vBank4 = vector3(1179.65, 2705.01, 38.08)

banks = {vBank1,vBank2,vBank3,vBank4}
--vBank1Door1 = vector3(255.228,223.976,102.393)
local bankDoor1 = {pos = vector3(255.228, 223.976, 102.393), closed =  160.0, open = 10.0}
local bankDoor2 = {pos = vector3(-2958.538, 482.270, 15.835), closed =  357.542, open = 270.0}
local bankDoor3 = {pos = vector3(-104.604, 6473.443, 31.795), closed =  45.0, open = 150.0}
local bankDoor4 = {pos = vector3(1175.542, 2710.861, 38.226), closed =  90.0, open = 0.0}

bankDoors = {bankDoor1, bankDoor2, bankDoor3, bankDoor4}
local controlPanel1 = vector3(252.916, 228.527, 102.088)
local controlPanel2 = vector3(-2956.500, 482.063, 15.897)
local controlPanel3 = vector3(-104.604, 6473.443, 31.795)
local controlPanel4 = vector3(1175.542, 2710.861, 38.226)
--print("Debug:"..bankDoors[2].open)
carNames = {"jester2","cheetah","zentorno","infernus","comet3", "carbonizzare", "autarch", "bullet", "scramjet", "t20"}

local blip1 = addBlip(v1, 225, "1")
local blip2 = addBlip(v2, 225, "2")
local blip3 = addBlip(v3, 225, "3")
local blip4 = addBlip(v4, 225, "4")
local blip5 = addBlip(v5, 225, "5")
local blip6 = addBlip(v5, 225, "5")
local blipsVisible = true

-- Threads
---------------------------------------------------------------------------

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

Citizen.CreateThread(function()
    threadFrame  = 0
    local closestPed, secondClosest, closestObject
    while true do
        Citizen.Wait(1)
        -- the "Vdist2" native checks how far two vectors are from another. 
        -- https://runtime.fivem.net/doc/natives/#_0xB7A628320EFF8E47
        --if Vdist2(GetEntityCoords(PlayerPedId(), false), v1) < distance_until_text_disappears then
        if DEBUG_DISPLAY then
            for i = 1, 4 do
                local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
                local dist = math.ceil(GetDistanceBetweenCoords(banks[i].x, banks[i].y, banks[i].z, x, y, z, true))
                Draw3DText(banks[i], i.." "..dist.."m")
            end

            Draw3DText(GetEntityCoords(closestVehicleID()), "Vehicle")
            if threadFrame == 0 then
                local peds = closestNPedIDs(2)
                closestPed = peds[1][1]
                secondClosest = peds[2][1]
                closestObject = closestObjectID()
            end
            local headingObject = GetEntityPhysicsHeading(closestObject)
            --local pedGroup = GetPedGroupIndex(closestPed)
            --local groupHash = GetPedRelationshipGroupHash(closestPed)
            Draw3DText(GetEntityCoords(closestPed), "Ped "..GetEntityHealth(closestPed))
            
            Draw3DText(GetEntityCoords(secondClosest), "Ped "..GetEntityHealth(secondClosest))

            Draw3DText(GetEntityCoords(closestObject), "Object "..closestObject.." "..headingObject)
        end
        threadFrame = threadFrame + 1
        if threadFrame >= threadLimit then
            threadFrame = 0
        end
    end
end)

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

DensityMultiplier = 1.0
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

--[[ example sorting iterator
distArr = {
      ["7.1"] = 234,
      ["2"] = 1112,
      ["7.0"] = 23456,
    }

function pairsByKeys (t, f)
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

for dist, id in pairsByKeys(distArr ) do
      print(id, dist)
    end
]]

--[[ Better Example
local t = {
  a = {1,2},
  b = {2,3},
  c = {4,1},
  d = {9,9},
}
local keys = {}
for k in pairs(t) do table.insert(keys, k) end
table.sort(keys, function(a, b) return t[a][2] < t[b][2] end)
for _, k in ipairs(keys) do print(k, t[k][1], t[k][2]) end
--]]

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