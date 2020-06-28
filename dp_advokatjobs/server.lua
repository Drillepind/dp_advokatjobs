--██████╗ ██████╗ ██╗██╗     ██╗     ███████╗██████╗ ██╗███╗   ██╗██████╗ 
--██╔══██╗██╔══██╗██║██║     ██║     ██╔════╝██╔══██╗██║████╗  ██║██╔══██╗
--██║  ██║██████╔╝██║██║     ██║     █████╗  ██████╔╝██║██╔██╗ ██║██║  ██║
--██║  ██║██╔══██╗██║██║     ██║     ██╔══╝  ██╔═══╝ ██║██║╚██╗██║██║  ██║
--██████╔╝██║  ██║██║███████╗███████╗███████╗██║     ██║██║ ╚████║██████╔╝
--╚═════╝ ╚═╝  ╚═╝╚═╝╚══════╝╚══════╝╚══════╝╚═╝     ╚═╝╚═╝  ╚═══╝╚═════╝ 
------------------------CREDITS------------------------
--   Copyright 2020 ©Drillepind. All rights reserved --
-------------------------------------------------------

MySQL = module("vrp_mysql", "MySQL")
local Proxy = module("vrp", "lib/Proxy")
local Tunnel = module("vrp", "lib/Tunnel")

vRP = Proxy.getInterface("vRP")

status = false

RegisterServerEvent('dp:status')
AddEventHandler('dp:status', function ()
    local source = source
    TriggerClientEvent("dp_status_c", source, status)
end)

RegisterServerEvent('dp:startet')
AddEventHandler('dp:startet', function ()
    status = true
    TriggerClientEvent("dp_status_c", -1, status)
end)

RegisterServerEvent('dp:stop')
AddEventHandler('dp:stop', function ()
    status = false
    TriggerClientEvent("dp_status_c", -1, status)
end)

RegisterServerEvent('dp:AdvokatCheckJob')
AddEventHandler('dp:AdvokatCheckJob', function()
    local user_id = vRP.getUserId({source})
    local player = vRP.getUserSource({user_id})

    if vRP.hasPermission({user_id,"advokat.garage"}) then
        TriggerEvent("dp:startet")
        TriggerClientEvent("dp_AdvokatHelp",player)
    else
        TriggerClientEvent("pNotify:SendNotification", source,{text = "Du er ikke Advokat", type = "success", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    end
end)

RegisterServerEvent('dp:SavedByAdvokat')
AddEventHandler('dp:SavedByAdvokat', function()
    local source = source
    local user_id = vRP.getUserId({source})
    local amount = math.random( 5000,12000)
    vRP.giveBankMoney({user_id,amount})
    TriggerClientEvent("pNotify:SendNotification", source,{text = "Modtog <b style='color: #4E9350'>"..amount.." DKK</b> For at have hjulpet klienten.", type = "success", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    TriggerEvent("dp:stop")
end)