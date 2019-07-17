--[[
GET_PED_DRAWABLE_VARIATION(Ped ped, int componentId)
GET_NUMBER_OF_PED_DRAWABLE_VARIATIONS(Ped ped, int componentId)
GET_PED_TEXTURE_VARIATION(Ped ped, int componentId)
GET_NUMBER_OF_PED_TEXTURE_VARIATIONS(Ped ped, int componentId, int drawableId)
SET_PED_COMPONENT_VARIATION(Ped ped, int componentId, int drawableId, int textureId, int paletteId)
SET_PED_RANDOM_COMPONENT_VARIATION(Ped ped, BOOL p1)
SET_PED_DEFAULT_COMPONENT_VARIATION(Ped ped)
--]]

RegisterCommand("setProp", function(source, args)
    setProp(tonumber(args[1]), tonumber(args[2]))
end)

RegisterCommand("getProps", function(source, args)
    getAvailableProps()
end)

RegisterCommand("flare2", function(source, args)
    --local coords = GetEntityCoords(GetPlayerPed(-1))
    bankID = tonumber(args[1])
    doorID = tonumber(args[2])
    local coords = banksObject[bankID].doors[doorID].pos
    local offset = {}
    offset[1] = vector3(-0.4, -1.15, -0.1)
    offset[2] = vector3(-0.4, -1.15, -0.1)
    offset[3] = vector3( 1.15, -0.4, -0.1)
    local lockCoords = vector3(coords.x + offset[doorID].x, coords.y + offset[doorID].y, coords.z + offset[doorID].z)
    local explosionType = 22
    local damageScale = 1.0
    local isAudible = true 
    local isInvisible = false
    local cameraShake = 1.0
    AddExplosion(lockCoords.x, lockCoords.y, lockCoords.z, explosionType, damageScale, isAudible, isInvisible, cameraShake)
    print("flare2 lockCoords x: "..lockCoords.x.." y: "..lockCoords.y.." z: "..lockCoords.z)
end)

RegisterCommand("flare", function(source, args)
    --local coords = GetEntityCoords(GetPlayerPed(-1))
    bankID = tonumber(args[1])
    doorID = tonumber(args[2])
    local lockCoords = banksObject[bankID].locks[doorID].pos
    local explosionType = 22
    local damageScale = 1.0
    local isAudible = true 
    local isInvisible = false
    local cameraShake = 1.0
    AddExplosion(lockCoords.x, lockCoords.y, lockCoords.z, explosionType, damageScale, isAudible, isInvisible, cameraShake)
    print("lockCoords x: "..lockCoords.x.." y: "..lockCoords.y.." z: "..lockCoords.z)
end)

function setProp(componentId, drawableId)
    ped = GetPlayerPed(-1)
    textureId = 0
    paletteId = 0
    SetPedComponentVariation(ped, componentId, drawableId, textureId, paletteId)
end

function getAvailableProps()
    ped = GetPlayerPed(-1)
    for i = 0, 11 do
        numberOfVariations = GetNumberOfPedDrawableVariations(ped, i)
        print("componentId: "..i.." numberOfVariations: "..numberOfVariations)
    end
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