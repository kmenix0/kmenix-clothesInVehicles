CreateThread(function()
    while true do
        Wait(0)

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        local vehicle = GetClosestVehicle(playerCoords.x, playerCoords.y, playerCoords.z, 7.0, 0, 71)

        if DoesEntityExist(vehicle) then
            local model = GetEntityModel(vehicle)

            for _, vehicleData in ipairs(allowedVehicles) do
                local vehicleName = vehicleData[1]
                local door1 = vehicleData[2]
                local door2 = vehicleData[3]

                if model == vehicleName then

                    local rearOffset = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -2.0, 0.0)
                    local distance = #(playerCoords - rearOffset)

                    BeginTextCommandDisplayHelp('STRING')
                    AddTextComponentSubstringPlayerName("Naciśnij ~INPUT_CONTEXT~ aby się przebrać!")
                    EndTextCommandDisplayHelp(0, false, true, 0)

                    if IsControlJustPressed(0, 38) then -- E
                        if GetVehicleDoorAngleRatio(vehicle, door1) > 0.1 or GetVehicleDoorAngleRatio(vehicle, door2) > 0.1 then
                            if door1 ~= nil then SetVehicleDoorShut(vehicle, door1, false) end
                            if door2 ~= nil then SetVehicleDoorShut(vehicle, door2, false) end
                        else
                            if door1 ~= nil then SetVehicleDoorOpen(vehicle, door1, false, false) end
                            if door2 ~= nil then SetVehicleDoorOpen(vehicle, door2, false, false) end
                            openClothesMenu(function()
                                if door1 ~= nil then SetVehicleDoorShut(vehicle, door1, false) end
                                if door2 ~= nil then SetVehicleDoorShut(vehicle, door2, false) end
                            end)
                        end
                    end
                end
            end
        end
    end
end)

function openClothesMenu(callback)
    local config = {
        ped = false,
        headBlend = false,
        faceFeatures = false,
        headOverlays = false,
        components = true,
        props = true,
        tattoos = false
    }

    exports['fivem-appearance']:startPlayerCustomization(function (appearance)
        callback()
    end, config)
end