RegisterCommand("save", function(source, args)
    local argString = table.concat(args, " ")
    MySQL.Async.fetchAll("INSERT INTO users (steam_id ,name, cash) VALUES(@steam_id, @name, @cash)",     
    --[[ 
        (id, name, args)
        These are the columns (in our database) we will be insterting the data into  
    ]]
    {["@steam_id"] = GetPlayerIdentifiers(source)[1], ["@name"] = GetPlayerName(source), ["@cash"] = 123},
        --[[ 
            Here we are defining the '@' variables to in-game native functions
         ]]
        function (result)
        TriggerClientEvent("output", source, "^2".. argString.. "^0")

    end)
end)