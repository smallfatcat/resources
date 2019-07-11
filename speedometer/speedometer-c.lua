-- Test lua script for FiveM

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

RegisterCommand("tpbank1", function(source)
    SetPedCoordsKeepVehicle(GetPlayerPed(-1), vBank1.x, vBank1.y, vBank1.z)
end)

RegisterCommand("tpbank2", function(source)
    SetPedCoordsKeepVehicle(GetPlayerPed(-1), vBank2.x, vBank2.y, vBank2.z)
end)

RegisterCommand("tpbank3", function(source)
    SetPedCoordsKeepVehicle(GetPlayerPed(-1), vBank3.x, vBank3.y, vBank3.z)
end)

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

function lineSpawner()
    local vStart = vector3(1719.97, 3239.41, 41.15)
    local vEnd = vector3(1712.10, 3267.57, 41.15)
    local num = 5

    local vLine = vector3(vEnd.x-vStart.x, vEnd.y-vStart.y, vEnd.z-vStart.z)
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
        vehicles[i] = CreateVehicle(car, x, y, z, 107.0, true, false)
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
        distance = GetDistanceBetweenCoords(x, y, z, vehcoords.x, vehcoords.y, vehcoords.z, true)
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
        local isInVehicle = GetVehiclePedIsIn(ped, false) ~= 0
        if ped ~= GetPlayerPed(-1) and not isInVehicle then
            pedcoords = GetEntityCoords(ped)
            distance = GetDistanceBetweenCoords(x, y, z, pedcoords.x, pedcoords.y, pedcoords.z, true)
            if (distance < nearest) then
                nearest = distance
                closest = ped
            end
        end
    end
    return closest
end

function closestObjectID()
    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local nearest = 1000000
    local closest = 0
    for obj in EnumerateObjects() do
        local isInVehicle = GetVehiclePedIsIn(obj, false) ~= 0
        if obj ~= GetPlayerPed(-1) then
            objcoords = GetEntityCoords(obj)
            distance = GetDistanceBetweenCoords(x, y, z, objcoords.x, objcoords.y, objcoords.z, true)
            if (distance < nearest) then
                nearest = distance
                closest = obj
            end
        end
    end
    return closest
end

-- Variables
--------------------------------------------------------------------------

vehicles = {0,0,0,0,0}
v1 = vector3(1726.0500488281, 3239.4248046875, 41.545928955078)
v2 = vector3(1726.0500488281, 3244.4248046875, 41.545928955078)
v3 = vector3(1726.0500488281, 3249.4248046875, 41.545928955078)
v4 = vector3(1726.0500488281, 3254.4248046875, 41.545928955078)
v5 = vector3(1726.0500488281, 3259.4248046875, 41.545928955078)
local unusedBool, v1ground = GetGroundZFor_3dCoord(v1.x, v1.y, v1.z, 0)
vBank1 = vector3(255.51, 226.60, 101.87)
vBank2 = vector3(-2957.44, 480.30, 15.70)
vBank3 = vector3(-104.17, 6470.57, 31.62)
carNames = {"adder","cheetah","zentorno","bf400","comet3"}

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
            --SetVehicleEnginePowerMultiplier(vehicle , 50.0)
                    
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
    while true do
        Citizen.Wait(1)
            -- the "Vdist2" native checks how far two vectors are from another. 
            -- https://runtime.fivem.net/doc/natives/#_0xB7A628320EFF8E47
            --if Vdist2(GetEntityCoords(PlayerPedId(), false), v1) < distance_until_text_disappears then
                Draw3DText(v1, "1")
                Draw3DText(v2, "2")
                Draw3DText(v3, "3")
                Draw3DText(v4, "4")
                Draw3DText(v5, "5")
                Draw3DText(GetEntityCoords(closestVehicleID()), "Vehicle")
                local closestPed = closestPedID()
                local closestObject = closestObjectID()
                local headingObject = GetEntityPhysicsHeading(closestObject)
                --local pedGroup = GetPedGroupIndex(closestPed)
                --local groupHash = GetPedRelationshipGroupHash(closestPed)
                Draw3DText(GetEntityCoords(closestPed), "Ped")
                Draw3DText(GetEntityCoords(closestObject), "Object "..closestObject.." "..headingObject)
            --end
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