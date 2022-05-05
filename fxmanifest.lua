fx_version 'adamant'

game 'gta5'

description 'Kmack710 - ESX - '

version '1.0.0'

shared_scripts {
    '@es_extended/imports.lua', --- Command out if not using ESX 
    'config.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'data/server.lua'
}

client_scripts {
    'data/client.lua'
}

escrow_ignore {
    'config.lua'
}

lua54 'yes'