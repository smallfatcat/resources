local display = false
SetNuiFocus(false, false)

RegisterCommand("on", function()
    Citizen.CreateThread(function()
      TriggerEvent('nui:on', true)
    end)
end)

RegisterCommand("off", function()
  Citizen.CreateThread(function()
      TriggerEvent("nui:off", true)
  end)
end)

RegisterNetEvent('nui:on')
AddEventHandler('nui:on', function()
  SendNUIMessage({
    type = "ui",
    display = true
  })
  --SetNuiFocus(true, true)
end)

RegisterNetEvent('nui:off')
AddEventHandler('nui:off', function()
  SendNUIMessage({
    type = "ui",
    display = false
  })
  --SetNuiFocus(false, false)
end)

RegisterNUICallback('myEvent', function(data, cb)
    -- Do something here
    print("callback from nui")
    cb('ok')
end)