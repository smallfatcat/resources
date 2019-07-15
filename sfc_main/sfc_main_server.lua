RegisterServerEvent('BankDoor:OpenServer')
AddEventHandler('BankDoor:OpenServer', function(doorID)
	TriggerClientEvent('BankDoor:OpenClient', -1, doorID)
end)

RegisterServerEvent('BankDoor:CloseServer')
AddEventHandler('BankDoor:CloseServer', function(doorID)
	TriggerClientEvent('BankDoor:CloseClient', -1, doorID)
end)
