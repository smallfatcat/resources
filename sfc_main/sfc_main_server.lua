RegisterServerEvent('BankDoor:OpenServer')
AddEventHandler('BankDoor:OpenServer', function(bankID, doorID)
	local lockedStatus = false
	updateLockedStatus(bankID, doorID, lockedStatus)
	TriggerClientEvent('BankDoor:OpenClient', -1, bankID, doorID, lockedStatus)
end)

RegisterServerEvent('BankDoor:CloseServer')
AddEventHandler('BankDoor:CloseServer', function(bankID, doorID)
	local lockedStatus = true
	updateLockedStatus(bankID, doorID, lockedStatus)
	TriggerClientEvent('BankDoor:CloseClient', -1, bankID, doorID, lockedStatus)
end)

function updateLockedStatus(bankID, doorID, lockedStatus)
	banksObject[bankID].doors[doorID].locked = 	lockedStatus
end