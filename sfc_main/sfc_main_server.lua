RegisterServerEvent('BankDoor:OpenServer')
AddEventHandler('BankDoor:OpenServer', function(bankID, doorID)
	TriggerClientEvent('BankDoor:OpenClient', -1, bankID, doorID)
end)

RegisterServerEvent('BankDoor:CloseServer')
AddEventHandler('BankDoor:CloseServer', function(bankID, doorID)
	TriggerClientEvent('BankDoor:CloseClient', -1, bankID, doorID)
end)
