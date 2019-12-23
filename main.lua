--[[
	Mod Initialization: Mort's Character Development

	GCD 2.0
]] --

-- Ensure that the player has the necessary MWSE version.
if (mwse.buildDate == nil or mwse.buildDate < 20181231) then
	mwse.log("[MCD] Build date of %s does not meet minimum build date of 20181231.", mwse.buildDate)
	event.register(
		"initialized",
		function()
			tes3.messageBox("MCD requires a newer version of MWSE. Please run MWSE-Update.exe.")
		end
	)
	return
end

-- The default configuration values.
local defaultConfig = {
	modDisabled = false,
	miscSkillsRaised = 0
}

-- Load our config file, and fill in default values for missing elements.
local config = mwse.loadConfig("MCD")
if (config == nil) then
	config = defaultConfig
else
	for k, v in pairs(defaultConfig) do
		if (config[k] == nil) then
			config[k] = v
		end
	end
end

local function setLevel(ref, lvl)
    mwscript.setLevel{reference=ref, level=lvl}
    if ref == tes3.player then
        local menu = tes3ui.findMenu(tes3ui.registerID("MenuStat"))
        local elem = menu:findChild(tes3ui.registerID("MenuStat_level"))
        elem.text = tostring(lvl)
        menu:updateLayout()
    end
end

local function incrementSkill(skill)
	if skill == 20 or skill == 1 or skill == 6 or skill == 4 or skill == 5 then --strength
		tes3.modStatistic{reference=tes3.player,attribute=0,value=1}
	elseif skill == 16 or skill == 13 or skill == 9 or skill == 18 then --intelligence
		tes3.modStatistic{reference=tes3.player,attribute=1,value=1}
	elseif skill == 11 or skill == 10 or skill == 14 or skill == 15 then --willpower
		tes3.modStatistic{reference=tes3.player,attribute=2,value=1}
	elseif skill == 0 or skill == 21 or skill == 23 or skill == 19 then --agility
		tes3.modStatistic{reference=tes3.player,attribute=3,value=1}
	elseif skill == 8 or skill == 26 or skill == 22 or skill == 17 then --speed
		tes3.modStatistic{reference=tes3.player,attribute=4,value=1}
	elseif skill == 3 or skill == 2 or skill == 7 then --endurance
		tes3.modStatistic{reference=tes3.player,attribute=5,value=1}
	elseif skill == 12 or skill == 24 or skill == 25 then --personality
		tes3.modStatistic{reference=tes3.player,attribute=6,value=1}
	end	
	--add support for custom skills?
end

local function onSkillUp(e)
	if config.modDisabled == true then
		return(e)
	end
	local class = tes3.player.object.class
	local majors = class.majorSkills
	local minors = class.minorSkills
	local threshold = 9 --9 for major/minor 10 for misc, this affects how many skills levels you up
	local skillType = "misc"
	
	for _,skill in pairs(majors) do
		if skill == e.skill then
			skillType = "major"
		end
	end
	
	for _,skill in pairs(minors) do
		if skill == e.skill then
			skillType = "minor"
		end
	end
	
	--major and minor treated the same...for now
	--1 stat every 2 levels
	if (skillType == "major") and (e.level >= 0) and (e.level % 2 == 0 ) then
		incrementSkill(e.skill)
	elseif (skillType == "minor") and (e.level >= 0) and (e.level % 2 == 0 ) then
		incrementSkill(e.skill)
	--misc only give stats over 30, major/minor at 20
	elseif (skillType == "misc") and (e.level >= 30) and (e.level % 2 == 0 ) then
		incrementSkill(e.skill)
	end
	
	--3 misc stats gives you a level point
	if skillType == "misc" then
		config.miscSkillsRaised = config.miscSkillsRaised + 1
		if config.miscSkillsRaised >= 3 then
			config.miscSkillsRaised = 0
			tes3.mobilePlayer.levelUpProgress = tes3.mobilePlayer.levelUpProgress + 1
		end
		mwse.saveConfig("MCD", config)
	end
	
	if skillType == "major" or skillType == "minor" then
		threshold = 9
	else
		threshold = 10
	end
	
	if tes3.mobilePlayer.levelUpProgress >= threshold then
		tes3.mobilePlayer.levelUpProgress = -1
		local next_level = (tes3.player.object.level + 1)
		setLevel(tes3.player, next_level)
		tes3.modStatistic{reference=tes3.player,attribute=7,value=1}
	end
end

local function onInitialized()
	event.register("skillRaised", onSkillUp)
	mwse.log("[mcd] Initialized.")
end
event.register("initialized", onInitialized)


---
--- Mod Config
---
local modConfig = {}

local function toggleMessageBox(e)
	config.showMessageBox = not config.showMessageBox
	local button = e.source
	button.text = config.showMessageBox and tes3.findGMST(tes3.gmst.sYes).value or tes3.findGMST(tes3.gmst.sNo).value
end

local function toggleHideTrapped(e)
	config.hideTrapped = not config.hideTrapped
	local button = e.source
	button.text = config.hideTrapped and tes3.findGMST(tes3.gmst.sYes).value or tes3.findGMST(tes3.gmst.sNo).value
end

local function toggleShowPlants(e)
	config.showPlants = not config.showPlants
	local button = e.source
	button.text = config.showPlants and tes3.findGMST(tes3.gmst.sYes).value or tes3.findGMST(tes3.gmst.sNo).value
end

local function toggleScriptedContainers(e)
	config.showScripted = not config.showScripted
	local button = e.source
	button.text = config.showScripted and tes3.findGMST(tes3.gmst.sYes).value or tes3.findGMST(tes3.gmst.sNo).value
end

local function toggleConfirmLock(e)
	config.hideLocked = not config.hideLocked
	local button = e.source
	button.text = config.hideLocked and tes3.findGMST(tes3.gmst.sYes).value or tes3.findGMST(tes3.gmst.sNo).value
end

function modConfig.onCreate(container)
	local mainBlock = container:createThinBorder({})
	mainBlock.flowDirection = "top_to_bottom"
	mainBlock.layoutWidthFraction = 1.0
	mainBlock.layoutHeightFraction = 1.0
	mainBlock.paddingAllSides = 6
	
	-- do
		-- local hBlockOne = mainBlock:createBlock({})
		-- hBlockOne.flowDirection = "left_to_right"
		-- hBlockOne.layoutWidthFraction = 1.0
		-- hBlockOne.autoHeight = true
	
		-- local labelOne = hBlockOne:createLabel({ text = "Display messagebox on loot?" })
		-- labelOne.layoutOriginFractionX = 0.0

		-- local buttonOne = hBlockOne:createButton({ text = (config.showMessageBox and tes3.findGMST(tes3.gmst.sYes).value or tes3.findGMST(tes3.gmst.sNo).value) })
		-- buttonOne.layoutOriginFractionX = 1.0
		-- buttonOne.paddingTop = 3
		-- buttonOne:register("mouseClick", toggleMessageBox)	
	-- end
	-- do
		-- local hBlockTwo = mainBlock:createBlock({})
		-- hBlockTwo.flowDirection = "left_to_right"
		-- hBlockTwo.layoutWidthFraction = 1.0
		-- hBlockTwo.autoHeight = true
	
		-- local labelTwo = hBlockTwo:createLabel({ text = "Hide trapped containers items? (False will show you the items but trigger the trap if you attempt to take one) " })
		-- labelTwo.layoutOriginFractionX = 0.0

		-- local buttonTwo = hBlockTwo:createButton({ text = (config.hideTrapped and tes3.findGMST(tes3.gmst.sYes).value or tes3.findGMST(tes3.gmst.sNo).value) })
		-- buttonTwo.layoutOriginFractionX = 1.0
		-- buttonTwo.paddingTop = 3
		-- buttonTwo:register("mouseClick", toggleHideTrapped)
	-- end
	-- do
		-- local hBlockThree = mainBlock:createBlock({})
		-- hBlockThree.flowDirection = "left_to_right"
		-- hBlockThree.layoutWidthFraction = 1.0
		-- hBlockThree.autoHeight = true
	
		-- local labelThree = hBlockThree:createLabel({ text = "Hide lock status? (False will display Locked when chests are locked and nothing when set to true) " })
		-- labelThree.layoutOriginFractionX = 0.0

		-- local buttonThree = hBlockThree:createButton({ text = (config.hideLocked and tes3.findGMST(tes3.gmst.sYes).value or tes3.findGMST(tes3.gmst.sNo).value) })
		-- buttonThree.layoutOriginFractionX = 1.0
		-- buttonThree.paddingTop = 3
		-- buttonThree:register("mouseClick", toggleConfirmLock)
	-- end
	-- do
		-- local hBlockFour = mainBlock:createBlock({})
		-- hBlockFour.flowDirection = "left_to_right"
		-- hBlockFour.layoutWidthFraction = 1.0
		-- hBlockFour.autoHeight = true
	
		-- local labelFour = hBlockFour:createLabel({ text = "Show quickloot menu on plant / organic containers? " })
		-- labelFour.layoutOriginFractionX = 0.0

		-- local buttonFour = hBlockFour:createButton({ text = (config.showPlants and tes3.findGMST(tes3.gmst.sYes).value or tes3.findGMST(tes3.gmst.sNo).value) })
		-- buttonFour.layoutOriginFractionX = 1.0
		-- buttonFour.paddingTop = 3
		-- buttonFour:register("mouseClick", toggleShowPlants)
	-- end
	-- do
		-- local hBlockFive = mainBlock:createBlock({})
		-- hBlockFive.flowDirection = "left_to_right"
		-- hBlockFive.layoutWidthFraction = 1.0
		-- hBlockFive.autoHeight = true
	
		-- local labelFive = hBlockFive:createLabel({ text = "Show containers with scripted onActivate? (Can break some container scripts) " })
		-- labelFive.layoutOriginFractionX = 0.0

		-- local buttonFive = hBlockFive:createButton({ text = (config.showScripted and tes3.findGMST(tes3.gmst.sYes).value or tes3.findGMST(tes3.gmst.sNo).value) })
		-- buttonFive.layoutOriginFractionX = 1.0
		-- buttonFive.paddingTop = 3
		-- buttonFive:register("mouseClick", toggleScriptedContainers)
	-- end
	-- do
		-- local hBlockSix = mainBlock:createBlock({})
		-- hBlockSix.flowDirection = "left_to_right"
		-- hBlockSix.layoutWidthFraction = 1.0
		-- hBlockSix.autoHeight = true
	
		-- local labelNumberDisplayed = hBlockSix:createLabel({ text = "Number of items displayed by default: " .. tostring(config.maxItemDisplaySize+1) })
		-- labelNumberDisplayed.layoutOriginFractionX = 0.0
		
		-- local sliderNumberDisplayed = hBlockSix:createSlider({ current = config.maxItemDisplaySize-4, max = 25, min = 4, jump = 2})
		-- sliderNumberDisplayed.layoutOriginFractionX = 1.0
		-- sliderNumberDisplayed.width = 300
		-- sliderNumberDisplayed:register("PartScrollBar_changed", function(e)
			-- local slider = e.source
			-- config.maxItemDisplaySize = (slider.widget.current + 4)
			-- labelNumberDisplayed.text = "Number of items displayed by default: " .. tostring(config.maxItemDisplaySize+1)
			-- end)
	-- end
	-- do
		-- local hBlockSeven = mainBlock:createBlock({})
		-- hBlockSeven.flowDirection = "left_to_right"
		-- hBlockSeven.layoutWidthFraction = 1.0
		-- hBlockSeven.autoHeight = true
	
		-- local labelXPosition = hBlockSeven:createLabel({ text = "Menu X position (higher = right): " .. tostring(config.menuX) })
		-- labelXPosition.layoutOriginFractionX = 0.0
		
		-- local sliderXPosition = hBlockSeven:createSlider({ current = config.menuX, max = 10, jump = 1 })
		-- sliderXPosition.layoutOriginFractionX = 1.0
		-- sliderXPosition.width = 300
		-- sliderXPosition:register("PartScrollBar_changed", function(e)
			-- local slider = e.source
			-- config.menuX = slider.widget.current
			-- labelXPosition.text = "Menu X position (higher = right): " .. tostring(config.menuX)
			-- end)
	-- end
	-- do
		-- local hBlockEight = mainBlock:createBlock({})
		-- hBlockEight.flowDirection = "left_to_right"
		-- hBlockEight.layoutWidthFraction = 1.0
		-- hBlockEight.autoHeight = true
	
		-- local labelYPosition = hBlockEight:createLabel({ text = "Menu Y position (higher = down): " .. tostring(config.menuY) })
		-- labelYPosition.layoutOriginFractionX = 0.0
		
		-- local sliderYPosition = hBlockEight:createSlider({ current = config.menuY, max = 10, jump = 1 })
		-- sliderYPosition.layoutOriginFractionX = 1.0
		-- sliderYPosition.width = 300
		-- sliderYPosition:register("PartScrollBar_changed", function(e)
			-- local slider = e.source
			-- config.menuY = slider.widget.current
			-- labelYPosition.text = "Menu Y position (higher = down): " .. tostring(config.menuY)
			-- end)
	-- end
	do
		local spacerBlock = mainBlock:createBlock({})
		spacerBlock.layoutWidthFraction = 1.0
		spacerBlock.paddingAllSides = 10
		spacerBlock.layoutHeightFraction = 1.0
		spacerBlock.flowDirection = "top_to_bottom"

		local buttonRestoreDefaults = spacerBlock:createButton({ text = "Restore Defaults" })
		buttonRestoreDefaults.layoutOriginFractionX = 0.2
		buttonRestoreDefaults.layoutOriginFractionY = 0.1
		buttonRestoreDefaults.paddingTop = 3
		buttonRestoreDefaults:register("mouseClick", function(e)
			for k, v in pairs(default) do
				config[k] = default[k]
			end
			mainBlock:destroy()
			modConfig.onCreate(container)
		end)
		
		local buttonEnableMCD = spacerBlock:createButton()
		if config.modDisabled == true then
			buttonEnableMCD.text = "Enable MCD? Current: No"
		else
			buttonEnableMCD.text = "Enable MCD? Current: Yes"
		end
		buttonEnableMCD.layoutOriginFractionX = 0.7
		buttonEnableMCD.layoutOriginFractionY = 0.1
		buttonEnableMCD.paddingTop = 3
		buttonEnableMCD:register("mouseClick", function(e)
			if config.modDisabled == true then
				buttonEnableMCD.text = "Enable MCD? Current: Yes"
				config.modDisabled = false
			else
				buttonEnableMCD.text = "Enable MCD? Current: No"
				config.modDisabled = true
			end
		end)
	end
end

function modConfig.onClose(container)
	mwse.log("[MCD] Saving mod configuration")
	mwse.saveConfig("MCD", config)
end

local function registerModConfig()
    mwse.registerModConfig("Mort's Character Development", modConfig)
end
event.register("modConfigReady", registerModConfig)