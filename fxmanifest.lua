fx_version 'adamant'

game 'gta5'

description 'Kmack710 710-lib'

version '2.0'

shared_scripts {
  -- '@es_extended/imports.lua', --- Comment out if not using ESX 
    '@ox_lib/init.lua',
    'config.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'data/server.lua',
    'data/groups_server.lua',
    
}

client_scripts {
    'data/client.lua',
    'data/groups_client.lua',
}

dependencies {
	--'es_extended' -- Comment out if using qbcore 
   -- 'qb-core' --- Comment out if using ESX 
   'ox_lib'
}

lua54 'yes'
