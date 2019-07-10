resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_script "db-c.lua"

server_scripts {
    "db-s.lua",
    "@mysql-async/lib/MySQL.lua"
    --[[ 
        the "@" references a file from a different resource,
        In this instance, we refernce the mysql library for FiveM.
    ]]
}