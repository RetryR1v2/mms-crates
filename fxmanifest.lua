fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'

version '1.1.0'
vorp_checker 'yes'
vorp_name '^5MMS-crates ^4version Check^3'
vorp_github 'https://github.com/RetryR1v2/mms-crates'

description 'mms-crates'
author 'Markus Mueller'

client_scripts {
	'client/client.lua'
}

server_scripts {
	'server/server.lua',
	'@oxmysql/lib/MySQL.lua',
}

shared_scripts {
    'config.lua',
	'shared/locale.lua',
	'languages/*.lua',
}

dependency {
	'vorp_core',
}

lua54 'yes'