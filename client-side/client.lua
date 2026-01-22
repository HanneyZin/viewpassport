 -----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("viewpassport")
local open = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYMAPPING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("viewpassport_f12", "Abrir passaporte com F12", "keyboard", "F12")
-----------------------------------------------------------------------------------------------------------------------------------------
-- IDENTIDADE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("viewpassport:open")
AddEventHandler("viewpassport:open",function(Passport)
	local nome, sobrenome, passaporte, phone, sangue, gemas, premium, rolepass, img, vip = vSERVER.Identidade(Passport)

	if not nome then
		TriggerEvent("Notify", "Atenção", Config.Messages.PassportNotFound, Config.Colors.Error, 5000)
		return
	end

	if not passaporte or passaporte == "" or passaporte == 0 then
		passaporte = Passport or "N/A"
	end

	if premium == 0 then
		premium = Config.Messages.NoPremium
	end

	if rolepass == 0 then
		rolepass = Config.Messages.NoRolepass
	end

	if gemas == 0 then
		gemas = Config.Messages.NoGems
	end

	exports["dynamic"]:AddMenu("Passaporte", "Informações do passaporte.", "passport")
	
	exports["dynamic"]:AddButton("Nome", nome .. " " .. sobrenome, "", "", "passport", false)
	exports["dynamic"]:AddButton("Passaporte", tostring(passaporte), "", "", "passport", false)
	exports["dynamic"]:AddButton("Telefone", phone, "", "", "passport", false)
	exports["dynamic"]:AddButton("Tipo Sanguíneo", sangue, "", "", "passport", false)
	exports["dynamic"]:AddButton("VIP", vip, "", "", "passport", false)
	exports["dynamic"]:AddButton("Gemas", gemas, "", "", "passport", false)
	
	exports["dynamic"]:Open()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMMANDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("viewpassport_f12", function()
	if not IsPauseMenuActive() and not LocalPlayer["state"]["Commands"] and not LocalPlayer["state"]["Handcuff"] and not LocalPlayer["state"]["Prison"] then
		if Config.F12Key and Config.F12Key.Enabled then
			local myPassport = vSERVER.GetMyPassport()
			
			if myPassport then
				TriggerServerEvent("viewpassport:open", myPassport)
			else
				TriggerEvent("Notify", "Erro", "Não foi possível obter seu passaporte.", "vermelho", 5000)
			end
		end
	end
end)

RegisterCommand(Config.Command,function(source,args)
	if vSERVER.IsAdmin() then
		local Passport = args[1]
		if Passport then
			TriggerServerEvent("viewpassport:open",Passport)
		else
			TriggerEvent("Notify", "Atenção", Config.Messages.UseCommand, Config.Colors.Warning, 5000)
		end
	else
		TriggerEvent("Notify", "Atenção", Config.Messages.NoPermission, Config.Colors.Error, 5000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET EVENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("viewpassport:openTarget")
AddEventHandler("viewpassport:openTarget", function(data)
	local targetPlayer = GetClosestPlayer()
	
	if targetPlayer then
		local targetPassport = vSERVER.GetTargetPassport(targetPlayer)
		
		if targetPassport then
			TriggerServerEvent("viewpassport:open", targetPassport)
		else
			TriggerEvent("Notify", "Erro", "Passaporte não encontrado.", "vermelho", 5000)
		end
	else
		TriggerEvent("Notify", "Erro", "Jogador não encontrado.", "vermelho", 5000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GET CLOSEST PLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
function GetClosestPlayer()
	local players = GetActivePlayers()
	local playerPed = PlayerPedId()
	local playerCoords = GetEntityCoords(playerPed)
	local closestPlayer = nil
	local closestDistance = 3.0
	
	for _, player in ipairs(players) do
		if player ~= PlayerId() then
			local targetPed = GetPlayerPed(player)
			local targetCoords = GetEntityCoords(targetPed)
			local distance = #(playerCoords - targetCoords)
			
			if distance < closestDistance then
				closestPlayer = GetPlayerServerId(player)
				closestDistance = distance
			end
		end
	end
	
	return closestPlayer
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMANDO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("testpassport", function()
	if not IsPauseMenuActive() and not LocalPlayer["state"]["Commands"] and not LocalPlayer["state"]["Handcuff"] and not LocalPlayer["state"]["Prison"] then
		local myPassport = vSERVER.GetMyPassport()
		
		if myPassport then
			TriggerServerEvent("viewpassport:open", myPassport)
		else
			TriggerEvent("Notify", "Erro", "Não foi possível obter seu passaporte.", "vermelho", 5000)
		end
	end
end)