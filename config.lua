-----------------------------------------------------------------------------------------------------------------------------------------
-- CONFIGURAÇÕES DO VIEWPASSPORT
-----------------------------------------------------------------------------------------------------------------------------------------
Config = {}

-- Configurações gerais
Config.Command = "rg" -- Comando para abrir o passaporte

-- Configurações da tecla F12
Config.F12Key = {
	Enabled = true, -- Habilita/desabilita a funcionalidade da tecla F12
	KeyMapping = "F12", -- Tecla configurada (F12)
	Description = "Pressione F12 para abrir seu passaporte"
}

-- Mensagens
Config.Messages = {
	PassportNotFound = "Passaporte não encontrado.",
	UseCommand = "Use: /rg [passaporte] (Apenas Administradores)",
	NoPremium = "Nenhum ativado.",
	NoRolepass = "Não ativado.",
	NoGems = "Nenhuma na conta.",
	NoPermission = "Você não tem permissão para usar este comando.",
	NoVip = "Nenhum"
}

-- Cores das notificações
Config.Colors = {
	Error = "vermelho",
	Warning = "amarelo",
	Success = "verde"
} 