ESX = exports['es_extended']:getSharedObject()
local isRepairing = false
local inRepairZone = false

local function createBlips()
    for _, coords in ipairs(Config.Locations) do
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, Config.Blip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, Config.Blip.scale)
        SetBlipColour(blip, Config.Blip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(Config.Blip.label)
        EndTextCommandSetBlipName(blip)
    end
end

local function isNearRepairStation()
    local playerCoords = GetEntityCoords(PlayerPedId())
    for _, coords in ipairs(Config.Locations) do
        if #(playerCoords - coords) <= Config.InteractionRadius then
            return true
        end
    end
    return false
end

local function repairVehicle()
    if isRepairing then
        return lib.notify({
            title = 'Repair Station',
            description = 'Already repairing vehicle',
            type = 'error'
        })
    end

    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if vehicle == 0 then
        return lib.notify({
            title = 'Repair Station',
            description = 'You must be in a vehicle',
            type = 'error'
        })
    end

    if not isNearRepairStation() then
        return lib.notify({
            title = 'Repair Station',
            description = 'You are not at a repair station',
            type = 'error'
        })
    end

    ESX.TriggerServerCallback('wokn-repairstation:checkMoney', function(hasMoney)
        if not hasMoney then
            return lib.notify({
                title = 'Repair Station',
                description = 'Insufficient funds ($' .. Config.RepairCost .. ' required)',
                type = 'error'
            })
        end

        isRepairing = true
        FreezeEntityPosition(playerPed, true)
        FreezeEntityPosition(vehicle, true)
        SetVehicleEngineOn(vehicle, false, true, true)

        if lib.progressBar({
            duration = Config.RepairDuration,
            label = 'Repairing vehicle',
            useWhileDead = false,
            canCancel = false,
            disable = {
                car = true,
                move = true,
                combat = true,
                mouse = false
            }
        }) then
            TriggerServerEvent('wokn-repairstation:repairComplete')
            SetVehicleFixed(vehicle)
            SetVehicleDeformationFixed(vehicle)
            SetVehicleUndriveable(vehicle, false)
            SetVehicleEngineHealth(vehicle, 1000.0)
            SetVehicleBodyHealth(vehicle, 1000.0)
            SetVehiclePetrolTankHealth(vehicle, 1000.0)
            
            lib.notify({
                title = 'Repair Station',
                description = 'Vehicle repaired successfully',
                type = 'success'
            })
        end

        isRepairing = false
        FreezeEntityPosition(playerPed, false)
        FreezeEntityPosition(vehicle, false)
    end)
end

RegisterCommand('repair', function()
    repairVehicle()
end, false)

CreateThread(function()
    createBlips()
end)
