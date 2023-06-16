local QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
    for k, v in pairs(Config.shelfs) do
        exports['qb-target']:AddBoxZone("shelf_"..k, v.coords.xyz, v.length, v.width, {
            name = "shelf_"..k,
            heading = v.coords.w,
            debugPoly = Config.debugPoly
        }, {
            options = {
                {
                    icon = "fad fa-sack-dollar",
                    label = 'Robar del estante',
                    action = function()
                        startRobShelf("shelf_"..k, v.cooldown)
                    end,
                }
            }
        })
    end

    for k, v in pairs(Config.cashRegister) do 
        exports['qb-target']:AddBoxZone("cashRegister_"..k, v.coords.xyz, v.length, v.width, {
            name = 'cashRegister_'..k,
            heading = v.coords.w,
            debugPoly = Config.debugPoly,
        }, {
            options = {
                icon = "fad fa-sack-dollar",
                label = 'Robar caja registradora'
                action = function()
                    startRobRegister("cashRegister_"..k, v.cooldown)
                end,
                canInteract = function()
                    local Player = QBCore.Functions.GetPlayerData()
                    if Player.gang and GetSelectedPedWeapon('weapon_crowbar') then return true end 
                    return false
                end,
            }
        })
    end

    
    for k, v in pairs(Config.safe) do
        exports['qb-target']:AddBoxZone('safe_'..k, v.coords.xyz, v.length, v.width, {
            name = 'safe_'..k,
            heading = v.coords.w,
            debugPoly = Config.debugPoly,
        }, {
            options = {
                icon = "fad fa-sack-dollar",
                label = 'Robar la caja fuerte',
                action = function()
                    startRobSafe('safe_'..k, v.cooldown)
                end,
                canInteract = function()
                    local Player = QBCore.Functions.GetPlayerData()
                    if Player.gang then return true end 
                    return false
                end,
            }
        })
    end
end)

function startRobSafe(nameSafe, cooldown)
    local isRobbed = lib.callback.await('bs_storeRobbery:checkIsRobbed', false, nameSafe)
    local ped = cache.ped
    if isRobbed then 
        QBCore.Functions.Notify("Parece que ya han robado esta caja fuerte", 5000, "error")
        return 
    end

    if lib.progressCircle({
        duration = 5000,
        label = "Forzando la caja fuerte..."
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
        },
        anim = {
            dict = 'mini@repair',
            clip = 'fixing_a_player',
            flag = 16,
        },
    }) then
        local success = exports["pd-safe"]:createSafe({math.random(0,99)})
        if not success then 
            QBCore.Functions.Notify("No pudiste forzar la caja fuerte", 5000, "error")
            return
        end

        policeCall()
        TriggerServerEvent('bs_storeRobbery:putCooldown', nameSafe, cooldown)
        TriggerServerEvent('bs_storeRobbery:giveItems', "safe")
        StopAnimTask(ped, dict, "machinic_loop_mechandplayer", 1.0)
        ClearPedTasks(ped)
    else 
        QBCore.Functions.Notify("Paraste de forzar", 5000, "success")
    end
end

function startRobRegister(nameRegister, cooldown)
    local isRobbed = lib.callback.await('bs_storeRobbery:checkIsRobbed', false, nameRegister)
    local ped = cache.ped
    if isRobbed then 
        QBCore.Functions.Notify("Parece que ya han robado esta caja registradora", 5000, "error")
        return 
    end

    if lib.progressCircle({
        duration = 5000,
        label = "Forzando la caja registradora..."
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
        },
        anim = {
            dict = 'mini@repair',
            clip = 'fixing_a_player',
            flag = 16,
        },
    }) then 
        local success = lib.skillCheck({'easy', 'easy', 'medium', 'easy'})
        if not success then 
            QBCore.Functions.Notify("No pudiste forzar la caja", 5000, "error")
            return
        end

        policeCall()
        TriggerServerEvent('bs_storeRobbery:putCooldown', nameRegister, cooldown)
        TriggerServerEvent('bs_storeRobbery:giveItems', "cashRegister")
        StopAnimTask(ped, dict, "machinic_loop_mechandplayer", 1.0)
        ClearPedTasks(ped)
    else 
        QBCore.Functions.Notify("Paraste de forzar", 5000, "success")
    end
end

function startRobShelf(nameShelf, cooldown)
    local isRobbed = lib.callback.await('bs_storeRobbery:checkIsRobbed', false, nameShelf)
    local ped = cache.ped
    if isRobbed then 
        QBCore.Functions.Notify("Parece que ya han robado este estante", 5000, "error")
        return 
    end

    if lib.progressCircle({
        duration = 5000,
        label = "Buscando en el estante..."
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
        },
        anim = {
            dict = 'mini@repair',
            clip = 'fixing_a_player',
            flag = 16,
        },
    }) then 
        local success = lib.skillCheck({'easy', 'easy', 'easy'})
        if not success then 
            QBCore.Functions.Notify("Te pusiste nervioso y al final no cogiste nada", 5000, "error")
            return
        end

        policeCall()
        TriggerServerEvent('bs_storeRobbery:putCooldown', nameShelf, cooldown)
        TriggerServerEvent('bs_storeRobbery:giveItems', "shelfs")
        StopAnimTask(ped, dict, "machinic_loop_mechandplayer", 1.0)
        ClearPedTasks(ped)
    else 
        QBCore.Functions.Notify("Paraste de buscar", 5000, "success")
    end
end

function policeCall()
    local chance = 75
    if GetClockHours() >= 0 and GetClockHours() <= 6 then
        chance = 50
    end
    if math.random(1, 100) <= chance then
        TriggerServerEvent('police:server:policeAlert', 'STORE ROBBERY IN PROGRESS')
    end
end