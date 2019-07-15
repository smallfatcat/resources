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