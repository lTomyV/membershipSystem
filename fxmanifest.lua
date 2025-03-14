fx_version 'cerulean'
game 'gta5'

author 'lTomyV'
description 'Memberships Resource'
version '1.0.0'

shared_script 'config.lua'

client_scripts {
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}