print("loaded bank.lua")

RegisterNetEvent('BankDoor:OpenClient')
AddEventHandler('BankDoor:OpenClient', function(bankID, doorID, lockedStatus)
    --print("Door opened: "..doorID)
    --print("bankID"..bankID.."doorID"..doorID)
    if banksObject[bankID].doors[doorID].type == "vault" then
        print("Vault open")
        changeDoorHeading(bankID, doorID, "open")
    else
        changeGateStatus(bankID, doorID, "open")
        --changeDoorHeading(bankID, doorID, "open")
    end
    updateLockedStatus(bankID, doorID, lockedStatus)
end)

RegisterNetEvent('BankDoor:CloseClient')
AddEventHandler('BankDoor:CloseClient', function(bankID, doorID, lockedStatus)
    --print("Door closed: "..doorID)
    --print("bankID"..bankID.."doorID"..doorID)
    if banksObject[bankID].doors[doorID].type == "vault" then
        changeDoorHeading(bankID, doorID, "closed")
    else
        changeGateStatus(bankID, doorID, "closed")
        changeDoorHeading(bankID, doorID, "closed")
    end
    updateLockedStatus(bankID, doorID, lockedStatus)
end)

RegisterCommand("blowtorch", function(source, args)
    playerPed = GetPlayerPed(-1)
    TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
    Citizen.CreateThread(function()
        Citizen.Wait(10000)
        ClearPedTasksImmediately(playerPed)
    end)
end)

RegisterCommand("bo", function(source, args)
    local bankID = args[1]
    local doorID = args[2]
    --local doorID = closestObjectIDtoCoords(bankDoors[doorID].pos)
    --openBankDoor(doorID)
    TriggerServerEvent("BankDoor:OpenServer", bankID, doorID)
end)

RegisterCommand("bc", function(source, args)
    local bankID = args[1]
    local doorID = args[2]
    --local doorID = closestObjectIDtoCoords(bankDoors[i].pos)
    --closeBankDoor(doorID)
    TriggerServerEvent("BankDoor:CloseServer", bankID, doorID)
end)

RegisterCommand("tpb", function(source, args)
    tpBank(tonumber(args[1]))
end)

function updateLockedStatus(bankID, doorID, lockedStatus)
    banksObject[bankID].doors[doorID].locked =  lockedStatus
end

function hackConsole(bankID, doorID)
    TriggerEvent("Radiant_Animations:Hack")
    local progress = 0
    Citizen.CreateThread(function()
        local hackIsRunning = true
        while hackIsRunning do
            _progressBarPool:Draw()
            Citizen.Wait(1)
            if (progress >= 100) then
                hackIsRunning = false
                TriggerServerEvent("BankDoor:OpenServer", bankID, doorID)
                hackStarted = false
            else
                progress = progress + 0.05
            end
            HackingProgressBar:SetPercentage(progress)
        end
    end)
end

function thermLock(bankID, doorID)
    --TriggerEvent("Radiant_Animations:Hack")
    local progress = 0
    local commandFlare = "flare "..tostring(bankID).." "..tostring(doorID)
    local commandEmoteStart = "e therm1"
    local commandEmoteStop = "e stop"
    local emoteRunning = true
    local flareStarted = false
    print("Thermite command ran")
    ExecuteCommand(commandEmoteStart)
    local startThermalTime = GetGameTimer()
    local timeThermalHasBeenRunning = 0
    Citizen.CreateThread(function()
        local thermIsRunning = true
        while thermIsRunning do
            Citizen.Wait(1)
            timeThermalHasBeenRunning = GetGameTimer() - startThermalTime
            if timeThermalHasBeenRunning >= 5000 and not flareStarted then
                ExecuteCommand(commandFlare)
                flareStarted = true
            end
            if timeThermalHasBeenRunning >= 8000 and emoteRunning then
                ExecuteCommand(commandEmoteStop)
                emoteRunning = false
            end

            if (timeThermalHasBeenRunning >= 57000) then
                thermIsRunning = false
                TriggerServerEvent("BankDoor:OpenServer", bankID, doorID)
                print("Thermite finished")
                thermStarted = false
            end
        end
    end)
end

function checkAllBankDoors()
    for bankID = 1, #banksObject do
        local bank = banksObject[bankID]
        for doorID = 1, #bank.doors do
            if IsDoorInRangeOfPlayer(bankID, doorID) then
                if banksObject[bankID].doors[doorID].locked then
                    TriggerEvent('BankDoor:CloseClient', bankID, doorID, true)
                else
                    TriggerEvent('BankDoor:OpenClient', bankID, doorID, false)
                end
            end
        end
    end
end

function IsDoorInRangeOfPlayer(bankID, doorID)
    local doorPos = banksObject[bankID].doors[doorID].pos
    local playerPos = GetEntityCoords(GetPlayerPed(-1))
    if Vdist2(doorPos, playerPos) < 400 then
        --print("Door in range, BankID: "..bankID.." doorID"..doorID)
        return true
    else
        return false
    end
end

function detectConsole()
    for bankID = 1, #banksObject do
        local bank = banksObject[bankID]
        for consoleID = 1, #bank.consoles do
            --print("bankID:"..bankID.." consoleID:"..consoleID.."#banksObject"..#banksObject)
            if Vdist2(bank.consoles[consoleID].pos, GetEntityCoords(GetPlayerPed(-1))) < 4 then
                return true, bank.consoles[consoleID].pos, bankID, consoleID
            end
        end
    end
    return false, vector3(0,0,0), 0, 0
end

function detectLock()
    for bankID = 1, #banksObject do
        local bank = banksObject[bankID]
        for lockID = 1, #bank.locks do
            --print("bankID:"..bankID.." consoleID:"..consoleID.."#banksObject"..#banksObject)
            if Vdist2(bank.locks[lockID].pos, GetEntityCoords(GetPlayerPed(-1))) < 4 then
                return true, bank.locks[lockID].pos, bankID, lockID
            end
        end
    end
    return false, vector3(0,0,0), 0, 0
end

function closeBankDoor(bankID, doorID)
    TriggerServerEvent("BankDoor:CloseServer", bankID, doorID)
end

function openBankDoor(bankID, doorID)
    TriggerServerEvent("BankDoor:OpenServer", bankID, doorID)
end

function hackListener(bankID, doorID, consolePos)
    print("hackListener started")
    local waitingForKeyPress = true
    
    CreateThread(function()
        while waitingForKeyPress and hackListenerStarted do
            -- draw every frame
            Draw3DText(consolePos, "Press ~r~E ~w~to hack")
            Wait(1)
            if IsControlJustReleased(1, 51) then
                hackListenerStarted = false
                waitingForKeyPress = false
                hackConsole(bankID, doorID)
                hackStarted = true
            end
        end
        print("hackListener ended")
    end)
end

function thermListener(bankID, doorID, lockPos)
    print("thermListener started")
    local waitingForKeyPress = true
    
    CreateThread(function()
        while waitingForKeyPress and thermListenerStarted do
            -- draw every frame
            Draw3DText(lockPos, "Press ~r~G ~w~to thermite")
            Wait(1)
            if IsControlJustReleased(1, 47) then
                thermListenerStarted = false
                waitingForKeyPress = false
                thermLock(bankID, doorID)
                thermStarted = true
            end
        end
        print("thermListener ended")
    end)
end

function changeDoorHeading(bankID, doorID, action)
    local doorCoords = banksObject[bankID].doors[doorID].pos
    local newHeading
    if action == "open" then
        newHeading = banksObject[bankID].doors[doorID].heading_open
    else
        newHeading = banksObject[bankID].doors[doorID].heading_closed
    end
    bankDoorID = closestObjectIDtoCoords(doorCoords)
    SetEntityCanBeDamaged(bankDoorID, false)
    NetworkRequestControlOfEntity(bankDoorID)
    SetEntityHeading(bankDoorID, tonumber(newHeading))
    --print("bankID"..bankID.."doorID"..doorID.."action"..action.."newHeading"..newHeading)
end

function changeGateStatus(bankID, doorID, action)
    local doorCoords = banksObject[bankID].doors[doorID].pos
    bankDoorID = closestObjectIDtoCoords(doorCoords)
    SetEntityCanBeDamaged(bankDoorID, false)
    NetworkRequestControlOfEntity(bankDoorID)
    if action == "open" then
        FreezeEntityPosition(bankDoorID, false)
    else
        FreezeEntityPosition(bankDoorID, true)
    end
    
    --SetEntityHeading(bankDoorID, tonumber(newHeading))
    --print("bankID"..bankID.."doorID"..doorID.."action"..action.."newHeading"..newHeading)
end

function tpBank(bankID)
    SetPedCoordsKeepVehicle(GetPlayerPed(-1), banks[bankID].x, banks[bankID].y, banks[bankID].z)
end

hackStarted = false
thermStarted = false

-- Hacking thread
CreateThread(function()
    print("Hacking thread")
    while true do
        Wait(1)
        local consoleDetected, consolePos, bankID, doorID = detectConsole()
        if consoleDetected and banksObject[bankID].doors[doorID].locked then
            if not hackListenerStarted and not hackStarted then
                --Draw3DText(consolePos, "Press E to hack")
                hackListener(bankID, doorID, consolePos)
                hackListenerStarted = true
            end
        else
            hackListenerStarted = false
        end
    end
end)

-- therm thread
CreateThread(function()
    print("therm thread")
    while true do
        Wait(1)
        local lockDetected, lockPos, bankID, doorID = detectLock()
        if lockDetected and banksObject[bankID].doors[doorID].locked and banksObject[bankID].doors[doorID].type == "gate" then
            if not thermListenerStarted and not thermStarted then
                --Draw3DText(consolePos, "Press E to thermite")
                thermListener(bankID, doorID, lockPos)
                thermListenerStarted = true
            end
        else
            thermListenerStarted = false
        end
    end
end)

-- Door Check thread
CreateThread(function()
    while true do
        Wait(1000)
        checkAllBankDoors()
    end
end)

