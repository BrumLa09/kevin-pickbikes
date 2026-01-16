ESX = exports["es_extended"]:getSharedObject()

local bike = nil
local hasbike = false
local closebike = false

local function PickUpBike(hash)
	local ped = PlayerPedId()
	local name = string.lower(GetDisplayNameFromVehicleModel(hash))
	RequestAnimDict("anim@heists@box_carry@")
	while (not HasAnimDictLoaded("anim@heists@box_carry@")) do
		Wait(1)
	end
	TaskPlayAnim(ped, "anim@heists@box_carry@" ,"idle", 5.0, -1, -1, 50, 0, false, false, false)
	AttachEntityToEntity(bike, ped, GetPedBoneIndex(player, 60309), Config.Bikes[name].x, Config.Bikes[name].y, Config.Bikes[name].z, Config.Bikes[name].RotX, Config.Bikes[name].RotY, Config.Bikes[name].RotZ, true, false, false, true, 0, true)
	hasbike = true
	lib.showTextUI('[' .. Config.InteractKey .. '] Drop')
	print("IF BUG TRY USE COMMAND /DROPBIKE")
end

local function PressedKey(hash)
	CreateThread(function ()
		while not hasbike do
			local ped = PlayerPedId()
			if IsControlJustReleased(0, 38) then
				PickUpBike(hash)
			end
			Wait(1)
		end
	end)
end

CreateThread(function()
    for k, v in pairs(Config.Bikes) do
        local hash = GetHashKey(k)
        exports.ox_target:addModel(hash, {
            {š
                name = 'pickup_bike_' .. hash,
                icon = 'fas fa-bicycle',
                label = 'Pick Up',
                distance = 2.0,
                onSelect = function(data)
                    TriggerEvent('kevin-pickbikes:client:takeup', {
                        hash = hash,
                        entity = data.entity
                    })
                end
            }
        })
    end
end)

RegisterNetEvent("kevin-pickbikes:client:takeup", function(data)
    if not data or not data.entity then return end
	if not IsThisModelABicycle(GetEntityModel(data.entity)) then return end
		
    local hash = data.hash
    bike = data.entity
    PickUpBike(hash)
end)

RegisterCommand('dropbike', function()
	if IsEntityAttachedToEntity(bike, PlayerPedId()) then
		DetachEntity(bike, false, false)
		SetVehicleOnGroundProperly(bike)
		ClearPedTasks(PlayerPedId())
		hasbike = false
		closebike = false
		lib.hideTextUI()
	end
end)
