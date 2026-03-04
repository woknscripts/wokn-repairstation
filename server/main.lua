ESX = exports['es_extended']:getSharedObject()

ESX.RegisterServerCallback('wokn-repairstation:checkMoney', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return cb(false) end
    
    local hasMoney = exports.ox_inventory:Search(source, 'count', 'money') >= Config.RepairCost
    cb(hasMoney)
end)

RegisterNetEvent('wokn-repairstation:repairComplete', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    local hasMoney = exports.ox_inventory:Search(source, 'count', 'money') >= Config.RepairCost
    
    if hasMoney then
        exports.ox_inventory:RemoveItem(source, 'money', Config.RepairCost)
    end
end)
