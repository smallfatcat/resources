print("loaded bank.lua")

RegisterNetEvent('BankDoor:OpenClient')
AddEventHandler('BankDoor:OpenClient', function(bankID, doorID)
    print("Door opened: "..doorID)
    print("bankID"..bankID.."doorID"..doorID)
    changeDoorHeading(bankID, doorID, "open")
end)

RegisterNetEvent('BankDoor:CloseClient')
AddEventHandler('BankDoor:CloseClient', function(bankID, doorID)
    print("Door closed: "..doorID)
    print("bankID"..bankID.."doorID"..doorID)
    changeDoorHeading(bankID, doorID, "close")
end)

RegisterCommand("hack", function(source, args)
    
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
            Draw3DText(consolePos, "Press E to hack")
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
    print("bankID"..bankID.."doorID"..doorID.."action"..action.."newHeading"..newHeading)
end

function tpBank(bankID)
    SetPedCoordsKeepVehicle(GetPlayerPed(-1), banks[bankID].x, banks[bankID].y, banks[bankID].z)
end

hackStarted = false

-- Hacking thread
CreateThread(function()
    print("Hacking thread")
    while true do
        Wait(1)
        local consoleDetected, consolePos, bankID, doorID = detectConsole()
        if consoleDetected then
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

