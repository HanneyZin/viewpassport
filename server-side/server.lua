-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Extinction = {}
Tunnel.bindInterface("viewpassport", Extinction)
local LoggedPlayers = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- AUTO LOGIN SYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		local players = GetPlayers()
		
		for _, playerId in ipairs(players) do
			local source = tonumber(playerId)

			if source and not LoggedPlayers[source] then
				local passport = vRP.Passport(source)
				if passport then
					LoggedPlayers[source] = passport
				end
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER CONNECTING EVENT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
	local source = source
	Citizen.SetTimeout(3000, function()
		local passport = vRP.Passport(source)
		if passport then
			LoggedPlayers[source] = passport
		end
	end)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER DROPPED EVENT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerDropped", function(reason)
	local source = source
	if LoggedPlayers[source] then
		LoggedPlayers[source] = nil
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CHARACTER CHOSEN EVENT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("CharacterChosen", function(Passport, source, Creation)
	LoggedPlayers[source] = Passport
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECT EVENT (ALTERNATIVO)
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect", function(Passport, source, Creation)
	LoggedPlayers[source] = Passport
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP ACTIVE EVENT (ALTERNATIVO)
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vRP:Active")
AddEventHandler("vRP:Active", function(Passport, source, Creation)
	LoggedPlayers[source] = Passport
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT EVENT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect", function(Passport)
	for source, playerPassport in pairs(LoggedPlayers) do
		if playerPassport == Passport then
			LoggedPlayers[source] = nil
			break
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MINIMALTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
function MinimalTimers(Seconds)
	if Seconds <= 0 then
		return "Expirado"
	end

	local Days = math.floor(Seconds / 86400)
	Seconds = Seconds % 86400

	local Hours = math.floor(Seconds / 3600)
	Seconds = Seconds % 3600

	local Minutes = math.floor(Seconds / 60)

	if Days > 0 then
		return string.format("%d Dias", Days)
	elseif Hours > 0 then
		return string.format("%d Horas", Hours)
	elseif Minutes > 0 then
		return string.format("%d Minutos", Minutes)
	else
		return string.format("%d Segundos", Seconds)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SANGUINE
-----------------------------------------------------------------------------------------------------------------------------------------
function Sanguine(Blood)
	if not Blood or Blood == 0 or Blood == "" then
		return "Desconhecido"
	end
	
	local bloodTypes = {
		[1] = "A+",
		[2] = "A-",
		[3] = "B+",
		[4] = "B-",
		[5] = "AB+",
		[6] = "AB-",
		[7] = "O+",
		[8] = "O-"
	}
	
	return bloodTypes[Blood] or tostring(Blood)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- IDENTIDADE
-----------------------------------------------------------------------------------------------------------------------------------------
function Extinction.Identidade(Number)
	local Number = Number
	local Identity = vRP.Identity(Number)
	
	if not Identity then
		return nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
	end
	
	local Account = vRP.Account(Identity.License)
	local Premium = 0
	local Rolepass = 0
	local VIP = "Nenhum"

	if Account then
		if Account.premium and Account.premium > 0 then
			Premium = MinimalTimers(Account.premium - os.time())
		else
			Premium = Config.Messages.NoPremium
		end

		if Account.rolepass and Account.rolepass > 0 then
			Rolepass = MinimalTimers(Account.rolepass - os.time())
		else
			Rolepass = Config.Messages.NoRolepass
		end
	else
		Premium = Config.Messages.NoPremium
		Rolepass = Config.Messages.NoRolepass
	end

	if vRP.HasPermission(Number, "Ouro") then
		VIP = "Ouro"
	elseif vRP.HasPermission(Number, "Prata") then
		VIP = "Prata"
	elseif vRP.HasPermission(Number, "Bronze") then
		VIP = "Bronze"
	end
	
	local passportId = Identity.id or Number
	
	return 
		Identity.Name,
		Identity.Lastname,
		passportId,
		Identity.Phone,
		Sanguine(Identity.Blood),
		Account and Account.Gemstone or 0,
		Premium,
		Rolepass,
		Identity.Avatar or "0",
		VIP
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENPASSPORT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("viewpassport:open")
AddEventHandler("viewpassport:open",function(Passport)
	local source = source
	
	if LoggedPlayers[source] then
		local UserPassport = LoggedPlayers[source]
		TriggerClientEvent("viewpassport:open",source,Passport)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GET MY PASSPORT
-----------------------------------------------------------------------------------------------------------------------------------------
function Extinction.GetMyPassport()
	local source = source
	
	if LoggedPlayers[source] then
		local passport = LoggedPlayers[source]
		return passport
	else
		return false
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- GET TARGET PASSPORT
-----------------------------------------------------------------------------------------------------------------------------------------
function Extinction.GetTargetPassport(targetSource)
	local targetPassport = vRP.Passport(targetSource)
	return targetPassport
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- IS ADMIN
-----------------------------------------------------------------------------------------------------------------------------------------
function Extinction.IsAdmin()
	
	local source = source
	
	if LoggedPlayers[source] then
		local UserPassport = LoggedPlayers[source]
		
		local adminLevel, adminName = vRP.HasPermission(UserPassport, "Admin")
		
		if adminLevel then
			return true
		end
		
		return false
	else
		return false
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- TEST PERMISSIONS COMMAND
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("testpermissions", function(source, args, rawCommand)
	if LoggedPlayers[source] then
		local Passport = LoggedPlayers[source]
		
		local adminLevel, adminName = vRP.HasPermission(Passport, "Admin")
		
		if adminLevel then
			TriggerClientEvent("Notify", source, "Permissões", "Você é " .. adminName .. " (Nível " .. adminLevel .. ")!", "verde", 5000)
		else
			TriggerClientEvent("Notify", source, "Permissões", "Você não é Administrador.", "vermelho", 5000)
		end
	else
		TriggerClientEvent("Notify", source, "Erro", "Você não está logado.", "vermelho", 5000)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOW ALL PERMISSIONS COMMAND
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("minhaspermissoes", function(source, args, rawCommand)
	if LoggedPlayers[source] then
		local Passport = LoggedPlayers[source]
		
		local userGroups = vRP.UserGroups(Passport)
		local permissions = {}
		
		for permission, _ in pairs(userGroups) do
			table.insert(permissions, permission)
		end
		
		if #permissions > 0 then
			local permissionText = table.concat(permissions, ", ")
			TriggerClientEvent("Notify", source, "Suas Permissões", permissionText, "verde", 10000)
		else
			TriggerClientEvent("Notify", source, "Permissões", "Você não tem nenhuma permissão.", "vermelho", 5000)
		end
	else
		TriggerClientEvent("Notify", source, "Erro", "Você não está logado.", "vermelho", 5000)
	end
end)
