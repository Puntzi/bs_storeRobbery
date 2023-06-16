local QBCore = exports['qb-core']:GetCoreObject()
local cooldownRobbed = {}

RegisterNetEvent('bs_storeRobbery:putCooldown', function(name, cooldown)
    cooldownRobbed[name] = true

    SetTimeout(cooldown * 1000 * 60, function()
        cooldownRobbed[name] = false
    end)
end)

RegisterNetEvent('bs_storeRobbery:giveItems', function(name)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end

    if name == "cashRegister" then
        Player.Functions.AddItem(Config.Items[name].type, Config.Items[name].amount)
        return
    end

    local randomNum = math.random(1, #Config.Items[name])
    local randomItem = Config.Items[name][randomNum].item
    local amount = Config.Items[name][randomNum].amount

    Player.Functions.AddItem(randomItem, amount)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[randomItem], "add", amount)
end)

lib.register.callback('bs_storeRobbery:checkIsRobbed', function(source, name)
    return alreadyRobbed[atm] == true
end)