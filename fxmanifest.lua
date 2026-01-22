fx_version "bodacious"
game "gta5"
lua54 "yes"
version "1.5.0"

autor "Hanney"
description "View Passport System"
 
shared_scripts {
	"config.lua"
}

client_scripts {
	"@vrp/lib/Utils.lua",
	"@vrp/config/Native.lua",
	"client-side/*"
}
server_scripts {
	"@vrp/lib/Utils.lua",
	"server-side/*"
}