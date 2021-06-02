function RepairVehicle()
    local playerPed = GetPlayerPed(-1)
    local coords = GetEntityCoords(playerPed)
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    -- local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)

    local inVehicle = false
    local isBusy = false

        if vehicle == 0 then
        vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
        if vehicle == 0 then
            exports['mb_notify']:sendNotification('You must be inside or near a vehicle to repair it', {type="error", vertical="top", horizontal="center", variant="filled"})
            return
        end
    else
        inVehicle = true
    end

    local plate = GetVehicleNumberPlateText(vehicle)
    local vehicleHash = GetEntityModel(vehicle)
    local vehicleName = GetDisplayNameFromVehicleModel(vehicleHash)
    local vehicleNameText = GetLabelText(vehicleName)

    if isBusy then return end

    isBusy = true
    if inVehicle == false then
        TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
    end
    Citizen.CreateThread(function()
        exports['mb_notify']:sendNotification('Repairing vehicle '..plate..' '..vehicleNameText, {duration=19000, type="info", vertical="top", horizontal="center", variant="filled"})
        Citizen.Wait(20000)

        SetVehicleFixed(vehicle)
        SetVehicleDeformationFixed(vehicle)
        SetVehicleUndriveable(vehicle, false)
        SetVehicleEngineOn(vehicle, true, true)
        if inVehicle == false then
            ClearPedTasksImmediately(playerPed)
        end

        isBusy = false
        -- exports['mythic_notify'].DoLongHudText('success', 'Vehicle repaired')
        exports['mb_notify']:sendNotification('Repaired vehicle '..plate..' '..vehicleNameText, {duration=5000, type="success", vertical="top", horizontal="center", variant="filled"})
    end)
end

RegisterCommand("repair", function(source, args, rawCommand)
    RepairVehicle()
end)

AddEventHandler('havoc:client:repair', function()
        RepairVehicle()
end)

RegisterNetEvent('havoc:client:heal')
AddEventHandler('havoc:client:heal', function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name == 'ambulance' then
        xPlayer.triggerEvent('esx_basicneeds:healPlayer')
    end
end)