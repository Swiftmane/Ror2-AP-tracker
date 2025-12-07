function Zone1Access()
	local value = 
        Tracker:ProviderCountForCode("Distant Roost") +
        Tracker:ProviderCountForCode("Distant Roost (2)") +
        Tracker:ProviderCountForCode("Titanic Plains") +
        Tracker:ProviderCountForCode("Titanic Plains (2)") +
        Tracker:ProviderCountForCode("Siphoned Forest") +
        Tracker:ProviderCountForCode("Verdant Fall") +
		Tracker:ProviderCountForCode("Viscous Falls") +
		Tracker:ProviderCountForCode("Shattered Abodes") +
		Tracker:ProviderCountForCode("Disturbed Impact")

	if (value > 0) and (Tracker:ProviderCountForCode("Stage 1") > 0) then
		return 1
	elseif (value > 0) and (Tracker:ProviderCountForCode("Progressive Stage") > 0) then
		return 1
    end
	
	return 0
end




function Zone2Access()
	local value = 
        Tracker:ProviderCountForCode("Abandoned Aqueduct") +
        Tracker:ProviderCountForCode("Wetland Aspect") +
        Tracker:ProviderCountForCode("Aphelian Sanctuary") +
		Tracker:ProviderCountForCode("Reformed Altar")
		
	if (value > 0) and (Tracker:ProviderCountForCode("Stage 2") > 0) then
		return 1
	elseif (value > 0) and (Tracker:ProviderCountForCode("Progressive Stage") > 1) then
		return 1
    end
	
	return 0
end

function Zone3Access()
    local value = 
        Tracker:ProviderCountForCode("Rallypoint Delta") +
        Tracker:ProviderCountForCode("Sulfur Pools") +
        Tracker:ProviderCountForCode("Scorched Acres") +
		(Tracker:ProviderCountForCode("Golden Dieback") +
			Tracker:ProviderCountForCode("Treeborn Colony")) *
			Tracker:ProviderCountForCode("Reformed Altar")
		-- Note: the above 3 lines make it so that Golden Dieback and Treeborn Colony only count if you have access to Reformed altar in order to mimic logic

	if (value > 0) and (Tracker:ProviderCountForCode("Stage 3") > 0) then
		return 1
	elseif (value > 0) and (Tracker:ProviderCountForCode("Progressive Stage") > 2) then
		return 1
    end
	
		return 0
end

function Zone4Access()
    local value = 
        Tracker:ProviderCountForCode("Abyssal Depths") +
        Tracker:ProviderCountForCode("Sirens Call") +
        Tracker:ProviderCountForCode("Sundered Grove")

	if (value > 0) and (Tracker:ProviderCountForCode("Stage 4") > 0) then
		return 1
	elseif (value > 0) and (Tracker:ProviderCountForCode("Progressive Stage") > 3) then
		return 1
    end
	
	return 0
end

function Zone5Access()
	local value =
		Tracker:ProviderCountForCode("Sky Meadow") +
		Tracker:ProviderCountForCode("Helminth Hatchery")

	return value 
end

function PrimeMeridianStageCount()
	local value = 
		Tracker:ProviderCountForCode("Reformed Altar") *
			(Tracker:ProviderCountForCode("Golden Dieback") +
			Tracker:ProviderCountForCode("Treeborn Colony"))
	if (value > 0) and ((Tracker:ProviderCountForCode("Stage 4") > 0) or (Tracker:ProviderCountForCode("Progressive Stage") > 3)) then
		return 1
	end

	return 0
end