fx_version 'adamant'

game 'gta5'

description 'Kmack710 710-lib'

version '2.1'

shared_scripts {
  -- '@es_extended/imports.lua', --- Comment out if not using ESX 
    '@ox_lib/init.lua',
    'config.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'data/server/main.lua',
    'data/server/groups_server.lua',
    --'data/server/serverboost.lua',
}

client_scripts {
    'data/client/main.lua',
    'data/client/groups.lua',
    --'data/client/serverboost.lua',

}

dependencies {
	--'es_extended' -- Comment out if using qbcore 
   -- 'qb-core' --- Comment out if using ESX 
   'ox_lib'
}

lua54 'yes'
