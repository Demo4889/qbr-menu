
local headerShown = false
local sendData = nil
local closeFunction = nil
local sharedItems = exports['qbr-core']:GetItems()
-- Functions

local function openMenu(data, onClose)

    if not data or not next(data) then return end
	for _,v in pairs(data) do
		if v["icon"] then
			local img = "qbr-inventory/html/"
			if sharedItems[tostring(v["icon"])] then
				if not string.find(sharedItems[tostring(v["icon"])].image, "images/") then
					img = img.."images/"
				end
				v["icon"] = img..sharedItems[tostring(v["icon"])].image
			end
		end
	end
    SetNuiFocus(true, true)
    headerShown = false
    sendData = data
    SendNUIMessage({
        action = 'OPEN_MENU',
        data = table.clone(data)
    })
    closeFunction = onClose

end

local function closeMenu()
    sendData = nil
    headerShown = false
    SetNuiFocus(false)
    SendNUIMessage({
        action = 'CLOSE_MENU'
    })
end

local function showHeader(data)
    if not data or not next(data) then return end
    headerShown = true
    sendData = data
    SendNUIMessage({
        action = 'SHOW_HEADER',
        data = table.clone(data)
    })
end

-- Events

RegisterNetEvent('qbr-menu:client:openMenu', function(data, onClose)
    openMenu(data, onClose)
end)

RegisterNetEvent('qbr-menu:client:closeMenu', function()
    closeMenu()
end)


-- NUI Callbacks

RegisterNUICallback('clickedButton', function(option)
    if headerShown then headerShown = false end
    PlaySoundFrontend(-1, 'Highlight_Cancel', 'DLC_HEIST_PLANNING_BOARD_SOUNDS', 1)
    SetNuiFocus(false)
    if sendData then
        local data = sendData[tonumber(option)]
        sendData = nil
        if data then
            if data.params.event then
                if data.params.isServer then
                    TriggerServerEvent(data.params.event, data.params.args)
                elseif data.params.isCommand then
                    ExecuteCommand(data.params.event)
                elseif data.params.isQBCommand then
                    TriggerServerEvent('QBCore:CallCommand', data.params.event, data.params.args)
                elseif data.params.isAction then
                    data.params.event(data.params.args)
                else
                    TriggerEvent(data.params.event, data.params.args)
                end
            end
        end
    end
end)

RegisterNUICallback('mouseOver', function(option)
    PlaySoundFrontend(-1, 'NAV_UP_DOWN', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 1)
    if not sendData then return end 
    local data = sendData[tonumber(option)]
    if not data then return end 
    local onMouseOver = data.onMouseOver
    if not onMouseOver then return end
    local event = onMouseOver.event
    if event then 
        if onMouseOver.isServer then
            TriggerServerEvent(event, onMouseOver.args)
        elseif onMouseOver.isCommand then
            ExecuteCommand(event)
        elseif onMouseOver.isQBCommand then
            TriggerServerEvent('QBCore:CallCommand', event, onMouseOver.args)
        elseif onMouseOver.isAction then
            event(onMouseOver.args)
        else
            TriggerEvent(event, onMouseOver.args)
        end
    end
end)

RegisterNUICallback('mouseOut', function(option)
    if not sendData then return end 
    local data = sendData[tonumber(option)]
    if not data then return end 
    local onMouseOut = data.onMouseOut
    if not onMouseOut then return end
    local event = onMouseOut.event
    if  event then 
        if onMouseOut.isServer then
            TriggerServerEvent(event, onMouseOut.args)
        elseif onMouseOut.isCommand then
            ExecuteCommand(event)
        elseif onMouseOut.isQBCommand then
            TriggerServerEvent('QBCore:CallCommand', event, onMouseOut.args)
        elseif onMouseOut.isAction then
            event(onMouseOut.args)
        else
            TriggerEvent(event, onMouseOut.args)
        end
    end
end)

RegisterNUICallback('closeMenu', function()
    headerShown = false
    sendData = nil
    SetNuiFocus(false)
    if closeFunction then
        pcall(function()
             closeFunction()
        end)
    end
    closeFunction = nil
end)

-- Command and Keymapping

RegisterCommand('+playerfocus', function()
    if headerShown then
        SetNuiFocus(true, true)
    end
end)

RegisterKeyMapping('+playerFocus', 'Menu Focus', 'keyboard', 'LMENU')

-- Exports

exports('openMenu', openMenu)
exports('closeMenu', closeMenu)
exports('showHeader', showHeader)