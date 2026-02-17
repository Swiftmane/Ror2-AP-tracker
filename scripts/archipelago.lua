-- this is an example/ default implementation for AP autotracking
-- it will use the mappings defined in item_mapping.lua and location_mapping.lua to track items and locations via thier ids
-- it will also load the AP slot data in the global SLOT_DATA, keep track of the current index of on_item messages in CUR_INDEX
-- addition it will keep track of what items are local items and which one are remote using the globals LOCAL_ITEMS and GLOBAL_ITEMS
-- this is useful since remote items will not reset but local items might
ScriptHost:LoadScript("scripts/ap_item_mapping.lua")
ScriptHost:LoadScript("scripts/ap_location_mapping.lua")

PriorityToHighlight = {}
if Highlight then
	PriorityToHighlight = {
		[0] = Highlight.Unspecified,
		[10] = Highlight.NoPriority,
		[20] = Highlight.Avoid,
		[30] = Highlight.Priority,
		[40] = Highlight.None -- found
	}
end

CUR_INDEX = -1
SLOT_DATA = nil
LOCAL_ITEMS = {}
GLOBAL_ITEMS = {}

function onClear(slot_data)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onClear, slot_data:\n%s", dump_table(slot_data)))
    end
    SLOT_DATA = slot_data
    CUR_INDEX = -1
	
	
    -- reset locations
    for _, v in pairs(LOCATION_MAPPING) do
        if v[1] then
            if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: clearing location %s", v[1]))
            end
            local obj = Tracker:FindObjectForCode(v[1])
            if obj then
                if v[1]:sub(1, 1) == "@" then
                    obj.AvailableChestCount = obj.ChestCount
                else
                    obj.Active = false
                end
            elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: could not find object for code %s", v[1]))
            end
        end
    end
    -- reset items
    for _, v in pairs(ITEM_MAPPING) do
        if v[1] and v[2] then
            if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: clearing item %s of type %s", v[1], v[2]))
            end
            local obj = Tracker:FindObjectForCode(v[1])
            if obj then
                if v[2] == "toggle" then
                    obj.Active = false
                elseif v[2] == "progressive" then
                    obj.CurrentStage = 0
                    obj.Active = false
                elseif v[2] == "consumable" then
                    obj.AcquiredCount = 0
                elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                    print(string.format("onClear: unknown item type %s for code %s", v[2], v[1]))
                end
            elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: could not find object for code %s", v[1]))
            end
        end
    end

    PLAYER_ID = Archipelago.PlayerNumber or -1
	TEAM_NUMBER = Archipelago.TeamNumber or 0

    if Archipelago.PlayerNumber > -1 then
		HINTS_ID = "_read_hints_"..TEAM_NUMBER.."_"..PLAYER_ID

		if Highlight then
			Archipelago:SetNotify({HINTS_ID})
			Archipelago:Get({HINTS_ID})
		end
	end

    LOCAL_ITEMS = {}
    GLOBAL_ITEMS = {}
	
	for k, v in pairs(SETTINGS_MAPPING) do
		obj = Tracker:FindObjectForCode(v)

		local value = SLOT_DATA[k]
		
		print("-----------------------------------------------------------")
		print(k, value)
		print("-----------------------------------------------------------")
		
		if k == "goal" then
			if value == 0 then
				Tracker:FindObjectForCode("exploreCheck").Active = false
				Tracker:FindObjectForCode("classicCheck").Active = true
			elseif value == 1 then
				Tracker:FindObjectForCode("exploreCheck").Active = true
				Tracker:FindObjectForCode("classicCheck").Active = false
			end
		elseif k == "chestsPerStage" then
            Tracker:FindObjectForCode('@Explore/Distant Roost/Distant Roost Chest/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Distant Roost (2)/Distant Roost (2) Chest/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Abandoned Aqueduct/Abandoned Aqueduct Chest/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Rallypoint Delta/Rallypoint Delta Chest/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Abyssal Depths/Abyssal Depths Chest/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Sky Meadow/Sky Meadow Chest/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Titanic Plains/Titanic Plains Chest/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Titanic Plains (2)/Titanic Plains (2) Chest/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Wetland Aspect/Wetland Aspect Chest/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Scorched Acres/Scorched Acres Chest/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Sirens Call/Sirens Call Chest/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Helminth Hatchery/Helminth Hatchery Chest/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Verdant Falls/Verdant Falls Chest/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Viscous Falls/Viscous Falls Chest/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Aphelian Sanctuary/Aphelian Sanctuary Chest/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Sulfur Pools/Sulfur Pools Chest/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Sundered Grove/Sundered Grove Chest/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Shattered Abodes/Shattered Abodes Chest/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Disturbed Impact/Disturbed Impact Chest/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Reformed Altar/Reformed Altar Chest/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Treeborn Colony/Treeborn Colony Chest/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Siphoned Forest/Siphoned Forest Chest/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Golden Dieback/Golden Dieback Chest/1').AvailableChestCount = value
		elseif k == "shrinesPerStage" then
            Tracker:FindObjectForCode('@Explore/Distant Roost/Distant Roost Shrine/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Distant Roost (2)/Distant Roost (2) Shrine/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Abandoned Aqueduct/Abandoned Aqueduct Shrine/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Rallypoint Delta/Rallypoint Delta Shrine/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Abyssal Depths/Abyssal Depths Shrine/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Sky Meadow/Sky Meadow Shrine/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Titanic Plains/Titanic Plains Shrine/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Titanic Plains (2)/Titanic Plains (2) Shrine/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Wetland Aspect/Wetland Aspect Shrine/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Scorched Acres/Scorched Acres Shrine/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Sirens Call/Sirens Call Shrine/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Helminth Hatchery/Helminth Hatchery Shrine/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Verdant Falls/Verdant Falls Shrine/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Viscous Falls/Viscous Falls Shrine/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Aphelian Sanctuary/Aphelian Sanctuary Shrine/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Sulfur Pools/Sulfur Pools Shrine/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Sundered Grove/Sundered Grove Shrine/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Shattered Abodes/Shattered Abodes Shrine/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Disturbed Impact/Disturbed Impact Shrine/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Reformed Altar/Reformed Altar Shrine/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Treeborn Colony/Treeborn Colony Shrine/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Siphoned Forest/Siphoned Forest Shrine/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Golden Dieback/Golden Dieback Shrine/1').AvailableChestCount = value
		elseif k == "altarsPerStage" then	
            Tracker:FindObjectForCode('@Explore/Distant Roost/Distant Roost Newt Altar/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Distant Roost (2)/Distant Roost (2) Newt Altar/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Abandoned Aqueduct/Abandoned Aqueduct Newt Altar/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Rallypoint Delta/Rallypoint Delta Newt Altar/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Abyssal Depths/Abyssal Depths Newt Altar/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Sky Meadow/Sky Meadow Newt Altar/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Titanic Plains/Titanic Plains Newt Altar/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Titanic Plains (2)/Titanic Plains (2) Newt Altar/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Wetland Aspect/Wetland Aspect Newt Altar/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Scorched Acres/Scorched Acres Newt Altar/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Sirens Call/Sirens Call Newt Altar/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Helminth Hatchery/Helminth Hatchery Newt Altar/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Verdant Falls/Verdant Falls Newt Altar/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Viscous Falls/Viscous Falls Newt Altar/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Aphelian Sanctuary/Aphelian Sanctuary Newt Altar/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Sulfur Pools/Sulfur Pools Newt Altar/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Sundered Grove/Sundered Grove Newt Altar/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Shattered Abodes/Shattered Abodes Newt Altar/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Disturbed Impact/Disturbed Impact Newt Altar/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Reformed Altar/Reformed Altar Newt Altar/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Treeborn Colony/Treeborn Colony Newt Altar/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Siphoned Forest/Siphoned Forest Newt Altar/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Golden Dieback/Golden Dieback Newt Altar/1').AvailableChestCount = value
		elseif k == "scannerPerStage" then	
            Tracker:FindObjectForCode('@Explore/Distant Roost/Distant Roost Radio Scanner/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Distant Roost (2)/Distant Roost (2) Radio Scanner/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Abandoned Aqueduct/Abandoned Aqueduct Radio Scanner/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Rallypoint Delta/Rallypoint Delta Radio Scanner/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Abyssal Depths/Abyssal Depths Radio Scanner/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Sky Meadow/Sky Meadow Radio Scanner/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Titanic Plains/Titanic Plains Radio Scanner/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Titanic Plains (2)/Titanic Plains (2) Radio Scanner/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Wetland Aspect/Wetland Aspect Radio Scanner/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Scorched Acres/Scorched Acres Radio Scanner/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Sirens Call/Sirens Call Radio Scanner/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Helminth Hatchery/Helminth Hatchery Radio Scanner/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Verdant Falls/Verdant Falls Radio Scanner/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Viscous Falls/Viscous Falls Radio Scanner/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Aphelian Sanctuary/Aphelian Sanctuary Radio Scanner/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Sulfur Pools/Sulfur Pools Radio Scanner/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Sundered Grove/Sundered Grove Radio Scanner/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Shattered Abodes/Shattered Abodes Radio Scanner/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Disturbed Impact/Disturbed Impact Radio Scanner/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Reformed Altar/Reformed Altar Radio Scanner/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Treeborn Colony/Treeborn Colony Radio Scanner/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Siphoned Forest/Siphoned Forest Radio Scanner/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Golden Dieback/Golden Dieback Radio Scanner/1').AvailableChestCount = value
		elseif k == "scavengersPerStage" then	
            Tracker:FindObjectForCode('@Explore/Distant Roost/Distant Roost Scavenger/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Distant Roost (2)/Distant Roost (2) Scavenger/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Abandoned Aqueduct/Abandoned Aqueduct Scavenger/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Rallypoint Delta/Rallypoint Delta Scavenger/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Abyssal Depths/Abyssal Depths Scavenger/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Sky Meadow/Sky Meadow Scavenger/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Titanic Plains/Titanic Plains Scavenger/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Titanic Plains (2)/Titanic Plains (2) Scavenger/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Wetland Aspect/Wetland Aspect Scavenger/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Scorched Acres/Scorched Acres Scavenger/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Sirens Call/Sirens Call Scavenger/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Helminth Hatchery/Helminth Hatchery Scavenger/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Verdant Falls/Verdant Falls Scavenger/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Viscous Falls/Viscous Falls Scavenger/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Aphelian Sanctuary/Aphelian Sanctuary Scavenger/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Sulfur Pools/Sulfur Pools Scavenger/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Sundered Grove/Sundered Grove Scavenger/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Shattered Abodes/Shattered Abodes Scavenger/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Disturbed Impact/Disturbed Impact Scavenger/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Reformed Altar/Reformed Altar Scavenger/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Treeborn Colony/Treeborn Colony Scavenger/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Siphoned Forest/Siphoned Forest Scavenger/1').AvailableChestCount = value
            Tracker:FindObjectForCode('@Explore/Golden Dieback/Golden Dieback Scavenger/1').AvailableChestCount = value
		elseif k == "totalLocations" then	
			Tracker:FindObjectForCode('@Classic/Item Pickup/ItemPickup').AvailableChestCount = value
			
		end
	end
		
end

-- called when an item gets collected
function onItem(index, item_id, item_name, player_number)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onItem: %s, %s, %s, %s, %s", index, item_id, item_name, player_number, CUR_INDEX))
    end
    if index <= CUR_INDEX then
        return
    end
    local is_local = player_number == Archipelago.PlayerNumber
    CUR_INDEX = index;
    local v = ITEM_MAPPING[item_id]
    if not v then
        if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("onItem: could not find item mapping for id %s", item_id))
        end
        return
    end
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onItem: code: %s, type %s", v[1], v[2]))
    end
    if not v[1] then
        return
    end
    local obj = Tracker:FindObjectForCode(v[1])
    if obj then
        if v[2] == "toggle" then
            obj.Active = true
        elseif v[2] == "progressive" then
            if obj.Active then
                obj.CurrentStage = obj.CurrentStage + 1
            else
                obj.Active = true
            end
        elseif v[2] == "consumable" then
            obj.AcquiredCount = obj.AcquiredCount + obj.Increment
        elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("onItem: unknown item type %s for code %s", v[2], v[1]))
        end
    elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onItem: could not find object for code %s", v[1]))
    end
end


--called when a location gets cleared
function onLocation(location_id, location_name)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onLocation: %s, %s", location_id, location_name))
    end
    local v = LOCATION_MAPPING[location_id]
    if not v and AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onLocation: could not find location mapping for id %s", location_id))
    end
    if not v[1] then
        return
    end
    local obj = Tracker:FindObjectForCode(v[1])
    if obj then
        if v[1]:sub(1, 1) == "@" then
            obj.AvailableChestCount = obj.AvailableChestCount - 1
        else
            obj.Active = true
        end
    elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onLocation: could not find object for code %s", v[1]))
	end
end

function OnNotify(key, value, old_value)
	if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
		print(string.format("called onNotify: %s, %s, %s", key, dump_table(value), old_value))
	end

	if value == old_value then
		return
	end

	if key == HINTS_ID and Highlight then
		for _, hint in ipairs(value) do
			if not hint.found and hint.finding_player == Archipelago.PlayerNumber then
				UpdateHints(hint.location, hint.status)
			else
				ClearHints(hint.location)
			end
		end
	elseif key == DATA_STORAGE_ID and value ~= nil then
		for k, v in pairs(value) do
			if (DataStorageLocationTable[k]) then
				Tracker:FindObjectForCode(DataStorageLocationTable[k]).AvailableChestCount = v and 0 or 1
			elseif (DataStorageItemTable[k]) then
				Tracker:FindObjectForCode(DataStorageItemTable[k]).Active = v or false
			elseif (k == "Learned Pedestal Sequence" and v) then
				for i, pair in ipairs(SLOT_DATA["lost_woods_item_sequence"]) do
					if (i < 4) then
						Tracker:FindObjectForCode("pedestal_d_"..i).CurrentStage = 3 - pair[1]
					end
					Tracker:FindObjectForCode("pedestal_"..i).CurrentStage = pair[2]
				end
			elseif (k == "Learned Lost Woods Sequence" and v) then
				for i, pair in ipairs(SLOT_DATA["lost_woods_main_sequence"]) do
					if (i < 4) then
						Tracker:FindObjectForCode("lost_woods_d_"..i).CurrentStage = 3 - pair[1]
					end
					Tracker:FindObjectForCode("lost_woods_"..i).CurrentStage = pair[2]
				end
			end
		end
		Tracker:FindObjectForCode(HiddenSetting).Active = not Tracker:FindObjectForCode(HiddenSetting).Active
	end
end

function OnNotifyLaunch(key, value)
	if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
		print(string.format("called onNotifyLaunch: %s, %s", key, dump_table(value)))
	end
	OnNotify(key, value)
end

-- called when a location is hinted or the status of a hint is changed
function UpdateHints(locationID, status)
	if not Highlight then
		return
	end
	local locations = LOCATION_MAPPING[locationID]
	-- print("Hint", dump(locations), status)
	for _, location in ipairs(locations) do
		local section = Tracker:FindObjectForCode(location)
		---@cast section LocationSection
		if section then
			section.Highlight = PriorityToHighlight[status]
		else
			print(string.format("No object found for code: %s", location))
		end
	end
end

function ClearHints(locationID)
	if not Highlight then
		return
	end
	local locations = LOCATION_MAPPING[locationID]
	if (not locations) then
		return
	end
	for _, location in ipairs(locations) do
		local section = Tracker:FindObjectForCode(location)
		---@cast section LocationSection
		if section then
			section.Highlight = Highlight.None
		else
			print(string.format("No object found for code: %s", location))
		end
	end
end


-- add AP callbacks
-- un-/comment as needed
Archipelago:AddClearHandler("clear handler", onClear)
Archipelago:AddItemHandler("item handler", onItem)
Archipelago:AddLocationHandler("location handler", onLocation)
Archipelago:AddSetReplyHandler("notify handler", OnNotify)
Archipelago:AddRetrievedHandler("notify launch handler", OnNotifyLaunch)
-- Archipelago:AddScoutHandler("scout handler", onScout)
-- Archipelago:AddBouncedHandler("bounce handler", onBounce)
