fx_version 'cerulean'
games { 'gta5' }
author 'OppoNoppo#0226'
description 'op-duty | duty script with ox_lib'
version '1.0.3'

lua54 'yes'

-- What to run
client_scripts {
    'client/*.lua',
}

shared_script {
	'@ox_lib/init.lua',
	'@es_extended/imports.lua',
	'config.lua'
}

server_script {
    'server/*.lua'
}

dependency {
	'es_extended',
	'ox_lib'
}
