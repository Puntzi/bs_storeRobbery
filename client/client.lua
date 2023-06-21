local QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
    for k, v in pairs(Config.shelfs) do
        exports['qb-target']:AddBoxZone("shelf_"..k, v.coords.xyz, v.length, v.width, {
            name = "shelf_"..k,
            heading = v.coords.w,
            debugPoly = Config.debugPoly,
        }, {
            options = {
                {
                    icon = "fad fa-sack-dollar",
                    label = 'Robar del estante',
                    action = function()
                        startRobShelf("shelf_"..k, v.cooldown)
                    end,
                }
            },
            distance = 1.5,
        })
    end

    for k, v in pairs(Config.cashRegister) do
        exports['qb-target']:AddBoxZone("cashRegister_"..k, v.coords.xyz, v.length, v.width, {
            name = 'cashRegister_'..k,
            heading = v.coords.w,
            debugPoly = Config.debugPoly,
            minZ = v.coords.z - 1,
            maxZ = v.coords.z + 1,
        }, {
            options = {
                {
                    icon = "fad fa-sack-dollar",
                    label = 'Robar caja registradora',
                    action = function()
                        startRobRegister("cashRegister_"..k, v.cooldown)
                    end,
                    canInteract = function()
                        return checkWeapon()
                    end,
                }
            },
            distance = 1.5,
        })
    end

    
    for k, v in pairs(Config.safe) do
        exports['qb-target']:AddBoxZone('safe_'..k, v.coords.xyz, v.length, v.width, {
            name = 'safe_'..k,
            heading = v.coords.w,
            debugPoly = Config.debugPoly,
        }, {
            options = {
                {
                    icon = "fad fa-sack-dollar",
                    label = 'Robar la caja fuerte',
                    action = function()
                        startRobSafe('safe_'..k, v.cooldown)
                    end,
                    canInteract = function()
                        local Player = QBCore.Functions.GetPlayerData()
                        if --[[Player.gang and ]]checkWeapon() then return true end 
                        return false
                    end,
                }
            },
            distance = 1.5,
        })
    end
end)

function startRobSafe(nameSafe, cooldown)
    local isRobbed = lib.callback.await('bs_storeRobbery:checkIsRobbed', false, nameSafe)
    local ped = cache.ped
    if isRobbed then 
        QBCore.Functions.Notify("Parece que ya han robado esta caja fuerte", "error", 5000)
        return 
    end

    TriggerServerEvent('police:server:policeAlert', 'STORE ROBBERY IN PROGRESS')
    FreezeEntityPosition(ped, true)

    if lib.progressCircle({
        duration = 120000,
        label = "Forzando la caja fuerte...",
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
            FreezeEntityPosition(ped, false)
            QBCore.Functions.Notify("No pudiste forzar la caja fuerte", "error", 5000)
            return
        end

        TriggerServerEvent('bs_storeRobbery:putCooldown', nameSafe, cooldown)
        TriggerServerEvent('bs_storeRobbery:giveItems', "safe")
        StopAnimTask(ped, dict, "machinic_loop_mechandplayer", 1.0)
        ClearPedTasks(ped)
    else 
        QBCore.Functions.Notify("Paraste de forzar", 5000, "success")
    end

    FreezeEntityPosition(ped, false)
end

function startRobRegister(nameRegister, cooldown)
    local isRobbed = lib.callback.await('bs_storeRobbery:checkIsRobbed', false, nameRegister)
    local ped = cache.ped
    if isRobbed then 
        QBCore.Functions.Notify("Parece que ya han robado esta caja registradora", "error", 5000)
        return 
    end

    TriggerServerEvent('police:server:policeAlert', 'STORE ROBBERY IN PROGRESS')

    if lib.progressCircle({
        duration = 40000,
        label = "Forzando la caja registradora...",
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
        QBCore.Functions.Notify("Parece que ya han robado este estante", "error", 5000)
        return 
    end

    if lib.progressCircle({
        duration = 5000,
        label = "Buscando en el estante...",
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
            QBCore.Functions.Notify("Te pusiste nervioso y al final no cogiste nada", "error", 5000)
            return
        end

        TriggerServerEvent('bs_storeRobbery:putCooldown', nameShelf, cooldown)
        TriggerServerEvent('bs_storeRobbery:giveItems', "shelfs")
        StopAnimTask(ped, dict, "machinic_loop_mechandplayer", 1.0)
        ClearPedTasks(ped)
    else 
        QBCore.Functions.Notify("Paraste de buscar", "success", 5000)
    end
end

function checkWeapon()
    for _, weapon in pairs(Config.weapons) do 
        if joaat(weapon) == GetSelectedPedWeapon(cache.ped) then 
            return true 
        end
    end

    return false
end