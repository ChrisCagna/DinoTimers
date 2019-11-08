DinoTimersVariables = {

}
local DinoTimersFont = "Interface\\AddOns\\DinoTimers\\Fonts\\FFF_Tusj.ttf"
local version = 1.0
local dtClr = "|cff009F00"
local gryClr = "|cffA9A9A9"

local width = 100
local height = 100
local fontSize = 20
local fontFlags = "OUTLINE"

local xpos1 = 0
local ypos1 = 0
local xpos2 = 0
local ypos2 = 0
local xpos3 = 0
local ypos3 = 0
local updateInterval = 1

local tStart = time() -- time when logged on
local sessionTime = 0
local timeSinceUpdate = 0;
local updateNow = false;

-- local values
local NW = 0;
local N = 0;
local E = 0;
local W = 0;
local SW = 0;
local SE = 0;

local playerPosition

local dinoFoundTime = -100
local dinoFoundSoundInterval = 45

local mobName = "Devilsaur"
local addonSync = false
local connected = false
local channelNumber = 0

local previousZone = ""
local goalZone = "Un'Goro Crater"


SLASH_DINOTIMERS1 = "/dt"
-- SLASH_DINOTIMERS2 = "/DT"
-- SLASH_DINOTIMERS3 = "/Dt"
local function handler(msg, editBox)
	if(msg == "test") then
				if(not connected) then
					diedAt(getPlayerArea(getPlayerPosition()))
				else
					sendDiedAtMessage(getPlayerArea(getPlayerPosition()))
				end
	elseif(msg == "NW" or msg == "N" or msg == "E" or msg == "W" or msg == "SW" or msg == "SE") then
		diedAt(msg)
	elseif(msg == "bigger") then
		fontSize = fontSize + 4
		adjustSize()
	elseif(msg == "smaller") then
		fontSize = fontSize - 4
		adjustSize()
	else
		DEFAULT_CHAT_FRAME:AddMessage(dtClr .. "Dino Timers Commands: |r")
	end
end
SlashCmdList["DINOTIMERS"] = handler;

local Init_Frame = CreateFrame("Frame")
Init_Frame:RegisterEvent("ADDON_LOADED")
Init_Frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
Init_Frame:RegisterEvent("PLAYER_ENTERING_WORLD")
Init_Frame:SetScript("OnEvent",
	function(self, event, ...)
		local arg1 = ...
		if(arg1 == "DinoTimers") then
			DEFAULT_CHAT_FRAME:AddMessage("|TInterface\\Icons\\Inv_misc_pelt_03:16|t" .. dtClr .. "Dino Timers Loaded!|r|TInterface\\Icons\\Inv_misc_pelt_03:16|t")
		end
		if(event=="ZONE_CHANGED_NEW_AREA") then
			updateLocation()
		end
		if(event=="PLAYER_ENTERING_WORLD") then
			previousZone = GetZoneText()
			updateLocation()
		end
end)

createFrames = function()
MainFrame=CreateFrame("Frame","MainFrame",UIParent)
ChatFrame=CreateFrame("Frame","ChatFrame",UIParent)

text=MainFrame:CreateFontString(nil,"OVERLAY","GameFontNormal")
text1=MainFrame:CreateFontString(nil,"OVERLAY","GameFontNormal")
text2=MainFrame:CreateFontString(nil,"OVERLAY","GameFontNormal")
text3=MainFrame:CreateFontString(nil,"OVERLAY","GameFontNormal")
text4=MainFrame:CreateFontString(nil,"OVERLAY","GameFontNormal")
text5=MainFrame:CreateFontString(nil,"OVERLAY","GameFontNormal")
text6=MainFrame:CreateFontString(nil,"OVERLAY","GameFontNormal")

timer=MainFrame:CreateFontString(nil,"OVERLAY","GameFontNormal")
timer1=MainFrame:CreateFontString(nil,"OVERLAY","GameFontNormal")
timer2=MainFrame:CreateFontString(nil,"OVERLAY","GameFontNormal")
timer3=MainFrame:CreateFontString(nil,"OVERLAY","GameFontNormal")
timer4=MainFrame:CreateFontString(nil,"OVERLAY","GameFontNormal")
timer5=MainFrame:CreateFontString(nil,"OVERLAY","GameFontNormal")
timer6=MainFrame:CreateFontString(nil,"OVERLAY","GameFontNormal")

resetButton = CreateFrame("Button","startButton1",MainFrame,"UIPanelButtonGrayTemplate")
startButton1 = CreateFrame("Button","startButton1",MainFrame,"UIPanelButtonGrayTemplate")
startButton2 = CreateFrame("Button","startButton1",MainFrame,"UIPanelButtonGrayTemplate")
startButton3 = CreateFrame("Button","startButton1",MainFrame,"UIPanelButtonGrayTemplate")
startButton4 = CreateFrame("Button","startButton1",MainFrame,"UIPanelButtonGrayTemplate")
startButton5 = CreateFrame("Button","startButton1",MainFrame,"UIPanelButtonGrayTemplate")
startButton6 = CreateFrame("Button","startButton1",MainFrame,"UIPanelButtonGrayTemplate")
syncButton = CreateFrame("Button","startButton1",MainFrame,"UIPanelButtonGrayTemplate")

MainFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
MainFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
MainFrame:RegisterEvent("UPDATE_MOUSEOVER_UNIT")

ChatFrame:RegisterEvent("CHAT_MSG_CHANNEL")

end

setDefaults = function()
	MainFrame:SetPoint("CENTER")
	MainFrame:SetSize(200,200)
	MainFrame:RegisterForDrag("LeftButton")
	MainFrame:SetMovable(true)
	MainFrame:SetAlpha(1)
	MainFrame:SetClampedToScreen(true)
	MainFrame:SetUserPlaced(true)
	MainFrame:EnableMouse()
	MainFrame:SetScript("OnUpdate", MainFrame.OnUpdate)


	text:SetPoint("TOPLEFT")
	text:SetJustifyH("LEFT")
	--text:SetFont(DinoTimersFont, 10, "OUTLINE")
	text:SetText(dtClr .. "|TInterface\\Icons\\Inv_misc_pelt_03:16|tSession:            \n ")
	text:SetFont(DinoTimersFont, fontSize, fontFlags)


	text1:SetPoint("TOPLEFT",text,"BOTTOMLEFT",0,0)
	text1:SetText(gryClr .. "North West:")
	text1:SetFont(DinoTimersFont, fontSize, fontFlags)

	text2:SetPoint("TOPLEFT",text1,"BOTTOMLEFT",0,-3)
	text2:SetText(gryClr .. "North:")
	text2:SetFont(DinoTimersFont, fontSize, fontFlags)

	text3:SetPoint("TOPLEFT",text2,"BOTTOMLEFT",0,-3)
	text3:SetText(gryClr .. "East:")
	text3:SetFont(DinoTimersFont, fontSize, fontFlags)

	text4:SetPoint("TOPLEFT",text3,"BOTTOMLEFT",0,-3)
	text4:SetText(gryClr .. "West:")
	text4:SetFont(DinoTimersFont, fontSize, fontFlags)

	text5:SetPoint("TOPLEFT",text4,"BOTTOMLEFT",0,-3)
	text5:SetText(gryClr .. "South West:")
	text5:SetFont(DinoTimersFont, fontSize, fontFlags)

	text6:SetPoint("TOPLEFT",text5,"BOTTOMLEFT",0,-3)
	text6:SetText(gryClr .. "South East:")
	text6:SetFont(DinoTimersFont, fontSize, fontFlags)

	timer:SetPoint("TOPLEFT",text,"TOPRIGHT")
	timer:SetText(gryClr .. "00:00")
	timer:SetFont(DinoTimersFont, fontSize, fontFlags)

	timer1:SetPoint("TOPLEFT",text,"BOTTOMRIGHT",0,0)
	timer1:SetText(gryClr .. "00:00")
	timer1:SetFont(DinoTimersFont, fontSize, fontFlags)

	timer2:SetPoint("TOPLEFT",timer1,"BOTTOMLEFT",0,-3)
	timer2:SetText(gryClr .. "00:00")
	timer2:SetFont(DinoTimersFont, fontSize, fontFlags)

	timer3:SetPoint("TOPLEFT",timer2,"BOTTOMLEFT",0,-3)
	timer3:SetText(gryClr .. "00:00")
	timer3:SetFont(DinoTimersFont, fontSize, fontFlags)

	timer4:SetPoint("TOPLEFT",timer3,"BOTTOMLEFT",0,-3)
	timer4:SetText(gryClr .. "00:00")
	timer4:SetFont(DinoTimersFont, fontSize, fontFlags)

	timer5:SetPoint("TOPLEFT",timer4,"BOTTOMLEFT",0,-3)
	timer5:SetText(gryClr .. "00:00")
	timer5:SetFont(DinoTimersFont, fontSize, fontFlags)

	timer6:SetPoint("TOPLEFT",timer5,"BOTTOMLEFT",0,-3)
	timer6:SetText(gryClr .. "00:00")
	timer6:SetFont(DinoTimersFont, fontSize, fontFlags)
end

setButtonDefaults = function()
resetButton:SetPoint("TOPRIGHT",text, "TOPLEFT",-2,0)
resetButton:SetWidth(timer:GetStringWidth()/1.5)
resetButton:SetHeight(text:GetStringHeight()/2)
resetButton:SetText("Reset")
resetButton:RegisterForClicks("LeftButtonUp")

startButton1:SetPoint("TOPRIGHT",text1, "TOPLEFT",-2,0)
startButton1:SetWidth(timer:GetStringWidth()/1.5)
startButton1:SetHeight(text1:GetStringHeight())
startButton1:SetText("Start")
startButton1:RegisterForClicks("LeftButtonUp")
--startButton1:CreateFontString(nil,"OVERLAY","GameFontNormal")
--startButton1:SetFont(DinoTimersFont, 10, "OUTLINE")

startButton2:SetPoint("TOPRIGHT",text2, "TOPLEFT",-2,0)
startButton2:SetWidth(timer:GetStringWidth()/1.5)
startButton2:SetHeight(text2:GetStringHeight())
startButton2:SetText("Start")
startButton2:RegisterForClicks("LeftButtonUp")

startButton3:SetPoint("TOPRIGHT",text3, "TOPLEFT",-2,0)
startButton3:SetWidth(timer:GetStringWidth()/1.5)
startButton3:SetHeight(text3:GetStringHeight())
startButton3:SetText("Start")
startButton3:RegisterForClicks("LeftButtonUp")

startButton4:SetPoint("TOPRIGHT",text4, "TOPLEFT",-2,0)
startButton4:SetWidth(timer:GetStringWidth()/1.5)
startButton4:SetHeight(text4:GetStringHeight())
startButton4:SetText("Start")
startButton4:RegisterForClicks("LeftButtonUp")

startButton5:SetPoint("TOPRIGHT",text5, "TOPLEFT",-2,0)
startButton5:SetWidth(timer:GetStringWidth()/1.5)
startButton5:SetHeight(text5:GetStringHeight())
startButton5:SetText("Start")
startButton5:RegisterForClicks("LeftButtonUp")

startButton6:SetPoint("TOPRIGHT",text6, "TOPLEFT",-2,0)
startButton6:SetWidth(timer:GetStringWidth()/1.5)
startButton6:SetHeight(text6:GetStringHeight())
startButton6:SetText("Start")
startButton6:RegisterForClicks("LeftButtonUp")

syncButton:SetPoint("TOP",text6, "BOTTOM",0,-5)
syncButton:SetWidth(timer:GetStringWidth()*2)
syncButton:SetHeight(text6:GetStringHeight()*2)
syncButton:SetText("Connect")
syncButton:RegisterForClicks("LeftButtonUp")
end

backdropDefault = function()

background = "Interface\\TutorialFrame\\TutorialFrameBackground"
edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border"
backdrop =
{
    bgFile = background,
    edgeFile = edge,
    tile = false, tileSize = 16, edgeSize = 16,
    insets = { left = 0, right = 0, top = 0, bottom = -10 }
}

end

adjustSize = function()
	
	text:SetFont(DinoTimersFont, fontSize, fontFlags)
	
	text1:SetFont(DinoTimersFont, fontSize, fontFlags)

	text2:SetFont(DinoTimersFont, fontSize, fontFlags)

	text3:SetFont(DinoTimersFont, fontSize, fontFlags)

	text4:SetFont(DinoTimersFont, fontSize, fontFlags)

	text5:SetFont(DinoTimersFont, fontSize, fontFlags)

	text6:SetFont(DinoTimersFont, fontSize, fontFlags)

	timer:SetFont(DinoTimersFont, fontSize, fontFlags)

	timer1:SetFont(DinoTimersFont, fontSize, fontFlags)

	timer2:SetFont(DinoTimersFont, fontSize, fontFlags)

	timer3:SetFont(DinoTimersFont, fontSize, fontFlags)

	timer4:SetFont(DinoTimersFont, fontSize, fontFlags)

	timer5:SetFont(DinoTimersFont, fontSize, fontFlags)

	timer6:SetFont(DinoTimersFont, fontSize, fontFlags)
	
	width = text:GetStringWidth() + timer:GetStringWidth()
	height = text:GetStringHeight() + (text1:GetStringHeight() * 6) + 12
	MainFrame:SetSize(width,height)
	
	resetButton:SetWidth(timer:GetStringWidth()/1.5)
	resetButton:SetHeight(text:GetStringHeight()/2)

	startButton1:SetWidth(timer:GetStringWidth()/1.5)
	startButton1:SetHeight(text1:GetStringHeight())

	startButton2:SetWidth(timer:GetStringWidth()/1.5)
	startButton2:SetHeight(text2:GetStringHeight())

	startButton3:SetWidth(timer:GetStringWidth()/1.5)
	startButton3:SetHeight(text3:GetStringHeight())

	startButton4:SetWidth(timer:GetStringWidth()/1.5)
	startButton4:SetHeight(text4:GetStringHeight())

	startButton5:SetWidth(timer:GetStringWidth()/1.5)
	startButton5:SetHeight(text5:GetStringHeight())

	startButton6:SetWidth(timer:GetStringWidth()/1.5)
	startButton6:SetHeight(text6:GetStringHeight())

	syncButton:SetWidth(timer:GetStringWidth()*2)
	syncButton:SetHeight(text6:GetStringHeight()*2)
	
	
end

createOptionsPannel = function()
	panel = CreateFrame("Frame")
	panel.name = "DinoTimers"
	InterfaceOptions_AddCategory(panel)
	
	panel.title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	panel.title:SetPoint("TOP",0,-10)
	panel.title:SetFont(DinoTimersFont, 30, fontFlags)
	panel.title:SetText(dtClr .. "DinoTimers")
	
	panel.subtext = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	panel.subtext:SetPoint("TOP", panel.title, "BOTTOM",0,-5)
	panel.subtext:SetFont(DinoTimersFont, 12, fontFlags)
	panel.subtext:SetText(dtClr .. "Created by Vanishd")
	
	panel.FontSlider = CreateFrame("Slider", "DinoTimersFontSlider", panel, "OptionsSliderTemplate")
	panel.FontSlider:SetOrientation('HORIZONTAL')
	panel.FontSlider.tooltopText = 'Text Size'
	_G["DinoTimersFontSliderLow"]:SetText("10")
	_G["DinoTimersFontSliderHigh"]:SetText("40")
	_G["DinoTimersFontSliderText"]:SetText("Font Size ("..fontSize..")");
	panel.FontSlider:SetPoint("TOPRIGHT", panel.subtext, "BOTTOMLEFT", -30, -30)
	panel.FontSlider:SetMinMaxValues(10,40)
	panel.FontSlider:SetValueStep(1)
	panel.FontSlider:SetValue(fontSize)
	panel.FontSlider:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
end

resetNW = function()
	NW = 0;
	text1:SetPoint("TOPLEFT",text,"BOTTOMLEFT",0,0)
	text1:SetText(gryClr .. "North West:")

	timer1:SetPoint("TOPLEFT",text,"BOTTOMRIGHT",0,0)
	timer1:SetText(gryClr .. "00:00")
	
	startButton1:SetText("Start")
end

resetN = function()
	N = 0;
	text2:SetPoint("TOPLEFT",text1,"BOTTOMLEFT",0,-3)
	text2:SetText(gryClr .. "North:")

	timer2:SetPoint("TOPLEFT",timer1,"BOTTOMLEFT",0,-3)
	timer2:SetText(gryClr .. "00:00")
	
	startButton2:SetText("Start")
end

resetE = function()
	E = 0
	text3:SetPoint("TOPLEFT",text2,"BOTTOMLEFT",0,-3)
	text3:SetText(gryClr .. "East:")

	timer3:SetPoint("TOPLEFT",timer2,"BOTTOMLEFT",0,-3)
	timer3:SetText(gryClr .. "00:00")
	
	startButton3:SetText("Start")
end

resetW = function()
	W = 0
	text4:SetPoint("TOPLEFT",text3,"BOTTOMLEFT",0,-3)
	text4:SetText(gryClr .. "West:")

	timer4:SetPoint("TOPLEFT",timer3,"BOTTOMLEFT",0,-3)
	timer4:SetText(gryClr .. "00:00")
	
	startButton4:SetText("Start")
end

resetSW = function()
	SW = 0
	text5:SetPoint("TOPLEFT",text4,"BOTTOMLEFT",0,-3)
	text5:SetText(gryClr .. "South West:")

	timer5:SetPoint("TOPLEFT",timer4,"BOTTOMLEFT",0,-3)
	timer5:SetText(gryClr .. "00:00")
	
	startButton5:SetText("Start")
end

resetSE = function()
	SE = 0
	text6:SetPoint("TOPLEFT",text5,"BOTTOMLEFT",0,-3)
	text6:SetText(gryClr .. "South East:")
	
	timer6:SetPoint("TOPLEFT",timer5,"BOTTOMLEFT",0,-3)
	timer6:SetText(gryClr .. "00:00")
	
	startButton6:SetText("Start")
end

reset = function()

resetNW()
resetN()
resetE()
resetW()
resetSW()
resetSE()

tStart = time()
updateCurrentTime()

end


createFrames()
backdropDefault()
setDefaults()
setButtonDefaults()
adjustSize()
createOptionsPannel()

function MainFrame:OnUpdate(arg1) -- MAIN UPDATE FUNCTION!
	timeSinceUpdate = timeSinceUpdate + arg1
	if(updateInterval<timeSinceUpdate or updateNow == true) then
-- actual code on update here
		updateCurrentTime()
		timer:SetText(dtClr .. secondsFormat(sessionTime))
		
		printController(NW)
		printController(N)
		printController(E)
		printController(W)
		printController(SW)
		printController(SE)
		
		if(addonSync) then
			addonSyncFunc()
		end
		
		updateSyncButton()
		
-- actual code end
		if(updateNow == false) then
			timeSinceUpdate = 0
		else
			updateNow = false
		end

	end
end

MainFrame:SetScript('OnEnter', function() 
	MainFrame:SetBackdrop(backdrop)
end)

MainFrame:SetScript('OnLeave', function()
	MainFrame:SetBackdropColor(1,1,1,0)
end)

resetButton:SetScript("OnMouseUp", function(self, button)
	resetButton:SetText("Reset")
	reset()
	updateNow = true
end)

startButton1:SetScript("OnMouseUp", function(self, button)	
	if(startButton1:GetText() ==  "Start") then
		diedAt("NW")
	elseif(startButton1:GetText() == "Reset") then
		resetNW()
		end
end)

startButton2:SetScript("OnMouseUp", function(self, button)
	if(startButton2:GetText() ==  "Start") then
		diedAt("N")
	elseif(startButton2:GetText() == "Reset") then
		resetN()
		end
end)

startButton3:SetScript("OnMouseUp", function(self, button)
	if(startButton3:GetText() ==  "Start") then
		diedAt("E")
	elseif(startButton3:GetText() == "Reset") then
		resetE()
		end
end)

startButton4:SetScript("OnMouseUp", function(self, button)
	if(startButton4:GetText() ==  "Start") then
		diedAt("W")
	elseif(startButton4:GetText() == "Reset") then
		resetW()
		end
end)

startButton5:SetScript("OnMouseUp", function(self, button)
	if(startButton5:GetText() ==  "Start") then
		diedAt("SW")
	elseif(startButton5:GetText() == "Reset") then
		resetSW()
		end
end)

startButton6:SetScript("OnMouseUp", function(self, button)
	if(startButton6:GetText() ==  "Start") then
		diedAt("SE")
	elseif(startButton6:GetText() == "Reset") then
		resetSE()
		end
end)

syncButton:SetScript("OnMouseUp", function(self, button)
	if(syncButton:GetText() == "Connect") then
		addonSync = true
		syncButton:SetText("|cffffff00Connecting..")
	elseif(syncButton:GetText()) == "|cffff0000Disconnect" then
		DEFAULT_CHAT_FRAME.editBox:SetText("/leave DinoTimers") ChatEdit_SendText(DEFAULT_CHAT_FRAME.editBox, 0)
		channelNumber = 0
		syncButton:SetText("Connect")
	end
end)

syncButton:SetScript('OnEnter', function()
	if(syncButton:GetText() == "|cff00ff00Connected") then
		syncButton:SetText("|cffff0000Disconnect")
	end
end)

syncButton:SetScript('OnLeave', function()
	if(syncButton:GetText() == "|cffff0000Disconnect") then
		syncButton:SetText("|cff00ff00Connected")
	end
end)

MainFrame:SetScript("OnMouseDown", function(self, button)
	if button == "LeftButton" and not self.isMoving then
		_, _, _, xpos1, ypos1 = MainFrame:GetPoint(1)
		self:StartMoving();
		_, _, _, xpos2, ypos2 = MainFrame:GetPoint(1)
		self.isMoving = true;
	end
end)

MainFrame:SetScript("OnMouseUp", function(self, button)
	if button == "LeftButton" and self.isMoving then
		_, _, _, xpos3, ypos3 = MainFrame:GetPoint(1)
		self:StopMovingOrSizing()
		self.isMoving = false;
	end
end)

MainFrame:SetScript("OnEvent", -- THE GOOD SHIT - The call that starts the entire thing. detects dinos death and calculates location
	function(self, event, ...)
	if(event == "COMBAT_LOG_EVENT_UNFILTERED") then
		local _, eventType, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellID = CombatLogGetCurrentEventInfo()

			if(eventType == "UNIT_DIED" and string.find(destName, mobName)) then
				if(not connected) then
					diedAt(getPlayerArea(getPlayerPosition()))
				else
					sendDiedAtMessage(getPlayerArea(getPlayerPosition()))
				end
			end
	elseif(event == "PLAYER_TARGET_CHANGED") then
		local arg1 = ...
		
		if(sessionTime - dinoFoundTime > dinoFoundSoundInterval) then
			getTargetName()
		end
	elseif(event == "UPDATE_MOUSEOVER_UNIT") then
		if(sessionTime - dinoFoundTime > dinoFoundSoundInterval) then
			getMouseOverName()
		end	
	end		
end)

ChatFrame:SetScript("OnEvent",
	function(self, event, ...)
	local chatMessage, arg2, arg3, channelName, arg5, arg6, arg7, arg8, arg9 = ...
		if(string.find(channelName, "DinoTimers")) then
			if(string.find(chatMessage,"DinoTimers:")) then
				local temp = chatMessage:gsub('%DinoTimers:','')
				diedAt(temp)
				--print(string.sub('ITS WORKING', -7))
			end
		end
end)

panel.FontSlider:SetScript("OnValueChanged", function(self, newValue)
	newValue = floor(newValue+0.5)
	fontSize = newValue
	_G["DinoTimersFontSliderText"]:SetText("Font Size ("..fontSize..")");
	panel.FontSlider:SetValue(newValue)
	adjustSize()	
end)

StaticPopupDialogs["AskToHide"] = {
	text = "Do you want to hide DinoTimers?",
	button1 = "Yes",
	button2 = "No",
	OnAccept = function()
		hideMainFrame()
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
}

StaticPopupDialogs["AskToReset"] = {
	text = "Reset DinoTimers?",
	button1 = "Yes",
	button2 = "No",
	OnAccept = function()
		reset()
		updateNow = true
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
}

getPlayerPosition = function()
	local mapID
	mapID = C_Map.GetBestMapForUnit("player")
	if (mapID) then
		playerPosition = C_Map.GetPlayerMapPosition(mapID,"player")
		playerPosition.x = playerPosition.x*100
		playerPosition.y = playerPosition.y*100
		return playerPosition
	end
end

getPlayerArea = function(pos)
	if( pos.x > 29 and pos.x < 40 and pos.y > 15 and pos.y < 30) then
		return "NW"
	elseif( pos.x > 53 and pos.x < 70 and pos.y > 18 and pos.y < 38) then
		return "N"
	elseif(pos.x > 65 and pos.x < 80 and pos.y > 25 and pos.y <60) then
		return "E"
	elseif(pos.x > 25 and pos.x < 41 and pos.y > 30 and pos.y < 60) then
		return "W"
	elseif( pos.x > 40 and pos.x < 50 and pos.y < 90 and pos.y > 55) then
		return "SW"
	elseif( pos.x >= 50 and pos.x < 62 and pos.y < 85 and pos.y > 40) then
		return "SE"
	else
		print("Dino died in no specific zone - Manually start timer.")
	end
		
end

getTargetName = function()
	local name = UnitName("target")
	if(name ~= nil) then
		if(string.find(name, mobName)) then
			PlaySoundFile("Interface\\AddOns\\DinoTimers\\Sounds\\Walking.ogg", "Master")
			dinoFoundTime = sessionTime
		end
	end
end

getMouseOverName = function()
	local name = GameTooltipTextLeft1:GetText()
	if(name ~= nil) then
		if(string.find(name, mobName)) then
			PlaySoundFile("Interface\\AddOns\\DinoTimers\\Sounds\\Walking.ogg", "Master")
			dinoFoundTime = sessionTime
		end
	end
end

updateCurrentTime = function()
	sessionTime = time() - tStart
end

addonSyncFunc = function()
	local count = 1
	local zeroCount = 0
	while(true) do
		local id, name = GetChannelName(count)
		if(name ~= nil) then
			if(string.find(name, "DinoTimers")) then 
				channelNumber = id
				print("DinoTimers Channel Number: " .. channelNumber)
				syncButton:SetText("|cff00ff00Connected")
				addonSync = false
				return true
			end
		else
			zeroCount = zeroCount +1
		end
		count = count + 1
		if(zeroCount > 5) then
			print('Not in DinoTimers Channel.. Joining Channel..')
			DEFAULT_CHAT_FRAME.editBox:SetText("/join DinoTimers") ChatEdit_SendText(DEFAULT_CHAT_FRAME.editBox, 0)
			return true
		end
	end
		
end

checkConnection = function()
	local zeroCount = 0
	local count = 1
	while(true) do
		local id, name = GetChannelName(count)
		if(name ~= nil) then
			if(string.find(name, "DinoTimers")) then 
				connected = true
				return true
			end
		else
			zeroCount = zeroCount + 1
		end
		count = count + 1
		if(zeroCount > 5) then
		connected = false
			return false
		end
	end
		
end

updateLocation = function()
	if(GetZoneText() == goalZone) then
		MainFrame:Show()
		if(goalZone ~= previousZone and GetZoneText() == goalZone) then
			StaticPopup_Show ("AskToReset")	
		end	
	elseif(previousZone == goalZone and GetZoneText() ~= goalZone) then
		StaticPopup_Show ("AskToHide")	
	else
		hideMainFrame()
	end
	previousZone = GetZoneText()
end

hideMainFrame = function()
	MainFrame:Hide()
	DEFAULT_CHAT_FRAME.editBox:SetText("/leave DinoTimers") ChatEdit_SendText(DEFAULT_CHAT_FRAME.editBox, 0)
	channelNumber = 0
end

updateSyncButton = function()
	if(syncButton:GetText() == "Connect" and checkConnection()) then
		addonSyncFunc()
	elseif(not checkConnection() and syncButton:GetText() == "|cff00ff00Connected") then
		syncButton:SetText("Connect")			
	end
end

sendDiedAtMessage = function(dino)
	DEFAULT_CHAT_FRAME.editBox:SetText("/" .. channelNumber .. " DinoTimers:" .. dino) 
	ChatEdit_SendText(DEFAULT_CHAT_FRAME.editBox)
	DEFAULT_CHAT_FRAME.editBox:SetText("") 
end

secondsFormat = function(t)
	local days = floor(t/86400)
	local hours = floor(mod(t, 86400)/3600)
	local minutes = floor(mod(t,3600)/60)
	local seconds = floor(mod(t,60))
	return format("%02d:%02d",minutes,seconds)
end

diedAt = function(dino)
	if(dino == "NW") then
		NW = sessionTime
		startButton1:SetText("Reset")
		updateNow = true
	end
	if(dino == "N") then
		N = sessionTime
		startButton2:SetText("Reset")
		updateNow = true
	end
	if(dino == "E") then
		E = sessionTime
		startButton3:SetText("Reset")
		updateNow = true
	end
	if(dino == "W") then
		W = sessionTime
		startButton4:SetText("Reset")
		updateNow = true
	end
	if(dino == "SW") then
		SW = sessionTime
		startButton5:SetText("Reset")
		updateNow = true
	end
	if(dino == "SE") then
		SE = sessionTime
		startButton6:SetText("Reset")
		updateNow = true
	end

end

timeDead = function(dino)
	return sessionTime - dino
end

printController = function(dino)
	-- set color of text
	local clr = ""
	if(timeDead(dino) >= 600 and timeDead(dino) <960 ) then
		clr = "|cff00ff00"
	elseif(timeDead(dino)>=960) then
		clr = "|cffff0000"
	end
	
	
	if(dino > 0 and dino == NW) then
		text1:SetText(clr .. "North West:")
		timer1:SetText(clr .. secondsFormat(timeDead(NW)))
	end
	if(dino > 0 and dino == N) then
		text2:SetText(clr .. "North:")
		timer2:SetText(clr .. secondsFormat(timeDead(N)))
	end
	if(dino > 0 and dino == E) then
		text3:SetText(clr .. "East:")
		timer3:SetText(clr .. secondsFormat(timeDead(E)))
	end
	if(dino > 0 and dino == W) then
		text4:SetText(clr .. "West:")
		timer4:SetText(clr .. secondsFormat(timeDead(W)))
	end
	if(dino > 0 and dino == SW) then
		text5:SetText(clr .. "South West:")
		timer5:SetText(clr .. secondsFormat(timeDead(SW)))
	end
	if(dino > 0 and dino == SE) then
		text6:SetText(clr .. "South East:")
		timer6:SetText(clr .. secondsFormat(timeDead(SE)))
	end	
	
	
end

MainFrame:SetScript("OnUpdate", MainFrame.OnUpdate)


















