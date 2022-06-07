fx_version 'adamant'

game 'gta5'

description 'Kmack710 710-lib'

version '1.0.0'

shared_scripts {
    '@es_extended/imports.lua', --- Command out if not using ESX 
    'configs/config.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'configs/custom-server.lua',
    'data/server.lua',
    
}

client_scripts {
    'configs/custom-client.lua',
    'data/client.lua',
    
}


lua54 'yes'