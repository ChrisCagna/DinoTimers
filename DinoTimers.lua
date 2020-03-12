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
local sessionTimeOffset = 3600 -- pushes session time 1 hr ahead to avoid -dino death times
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
local currentChannelName = "dinotimers"
local addonSync = false
local connected = false
local channelNumber = 0

local radarOn = false


local previousZone = ""
local goalZone = "Un'Goro Crater"

local currentShareButton;

SLASH_DINOTIMERS1 = "/dt"
-- SLASH_DINOTIMERS2 = "/DT"
-- SLASH_DINOTIMERS3 = "/Dt"
local function handler(msg, editBox)
	if(msg == "test") then
		--diedAt("E","5")
		-- local chatMessage = "DinoTimers:E,65"
		-- local temp = string.match(chatMessage, ':(.*),')
		-- local temp2 = string.match(chatMessage, ',(.*)')
			-- if(temp2 == "") then
				-- temp2 = 0
			-- end
		-- print(temp)
		-- print(temp2)
		-- diedAt(temp, temp2)
		ScanForDinos()
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
			adjustSize()
		end
end)

backdropDefault = function()

background = "Interface\\TutorialFrame\\TutorialFrameBackground"
edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border"
backdrop =
{
    bgFile = background,
    edgeFile = edge,
    tile = false, tileSize = 16, edgeSize = 16,
    insets = { left = 0, right = 0, top = 0, bottom = 0 }
}

end

createFrames = function()
MainFrame=CreateFrame("Frame","MainFrame",UIParent)
ChatFrame=CreateFrame("Frame","ChatFrame",UIParent)
MyMapFrame = CreateFrame("Frame", "MyMapFrame", WorldMapFrame)

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
startButton2 = CreateFrame("Button","startButton2",MainFrame,"UIPanelButtonGrayTemplate")
startButton3 = CreateFrame("Button","startButton3",MainFrame,"UIPanelButtonGrayTemplate")
startButton4 = CreateFrame("Button","startButton4",MainFrame,"UIPanelButtonGrayTemplate")
startButton5 = CreateFrame("Button","startButton5",MainFrame,"UIPanelButtonGrayTemplate")
startButton6 = CreateFrame("Button","startButton6",MainFrame,"UIPanelButtonGrayTemplate")
syncButton = CreateFrame("Button","startButton1",MainFrame,"UIPanelButtonGrayTemplate")

shareButton = CreateFrame("Button","shareButton",MainFrame,"UIPanelButtonGrayTemplate")
shareButton1 = CreateFrame("Button","shareButton1",MainFrame,"UIPanelButtonGrayTemplate")
shareButton2 = CreateFrame("Button","shareButton2",MainFrame,"UIPanelButtonGrayTemplate")
shareButton3 = CreateFrame("Button","shareButton3",MainFrame,"UIPanelButtonGrayTemplate")
shareButton4 = CreateFrame("Button","shareButton4",MainFrame,"UIPanelButtonGrayTemplate")
shareButton5 = CreateFrame("Button","shareButton5",MainFrame,"UIPanelButtonGrayTemplate")
shareButton6 = CreateFrame("Button","shareButton6",MainFrame,"UIPanelButtonGrayTemplate")

radarButton = CreateFrame("Button","radarButton",MainFrame,"UIPanelButtonGrayTemplate")

MainFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
MainFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
MainFrame:RegisterEvent("UPDATE_MOUSEOVER_UNIT")

ChatFrame:RegisterEvent("CHAT_MSG_CHANNEL")

end

setDefaults = function()
	MainFrame:SetPoint("CENTER")
	--MainFrame:SetSize(200,200)
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

	timer:SetPoint("TOPRIGHT",MainFrame,"TOPRIGHT")
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
	
	MyMapFrame:SetPoint("TOPLEFT", WorldMapFrame.ScrollContainer, "TOPLEFT",0,0)
	MyMapFrame:SetWidth(50)
	MyMapFrame:SetHeight(50)
	MyMapFrame:SetAlpha(0.5)
	MyMapFrame:SetFrameLevel(3)
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

radarButton:SetPoint("TOP",timer6, "BOTTOM",0,-5)
radarButton:SetWidth(timer:GetStringWidth()*2)
radarButton:SetHeight(text6:GetStringHeight()*2)
radarButton:SetText("Radar")
radarButton:RegisterForClicks("LeftButtonUp")

shareButton:SetPoint("TOPLEFT",timer, "TOPRIGHT",-2,0)
shareButton:SetWidth(timer:GetStringWidth()/1.5)
shareButton:SetHeight(text:GetStringHeight()/2)
shareButton:SetText("Share")
shareButton:RegisterForClicks("LeftButtonUp")

shareButton1:SetPoint("TOPLEFT",timer1, "TOPRIGHT",-2,0)
shareButton1:SetWidth(timer:GetStringWidth()/1.5)
shareButton1:SetHeight(text1:GetStringHeight())
shareButton1:SetText("Share")
shareButton1:RegisterForClicks("LeftButtonUp")

shareButton2:SetPoint("TOPLEFT",timer2, "TOPRIGHT",-2,0)
shareButton2:SetWidth(timer:GetStringWidth()/1.5)
shareButton2:SetHeight(text2:GetStringHeight())
shareButton2:SetText("Share")
shareButton2:RegisterForClicks("LeftButtonUp")

shareButton3:SetPoint("TOPLEFT",timer3, "TOPRIGHT",-2,0)
shareButton3:SetWidth(timer:GetStringWidth()/1.5)
shareButton3:SetHeight(text3:GetStringHeight())
shareButton3:SetText("Share")
shareButton3:RegisterForClicks("LeftButtonUp")

shareButton4:SetPoint("TOPLEFT",timer4, "TOPRIGHT",-2,0)
shareButton4:SetWidth(timer:GetStringWidth()/1.5)
shareButton4:SetHeight(text4:GetStringHeight())
shareButton4:SetText("Share")
shareButton4:RegisterForClicks("LeftButtonUp")

shareButton5:SetPoint("TOPLEFT",timer5, "TOPRIGHT",-2,0)
shareButton5:SetWidth(timer:GetStringWidth()/1.5)
shareButton5:SetHeight(text5:GetStringHeight())
shareButton5:SetText("Share")
shareButton5:RegisterForClicks("LeftButtonUp")

shareButton6:SetPoint("TOPLEFT",timer6, "TOPRIGHT",-2,0)
shareButton6:SetWidth(timer:GetStringWidth()/1.5)
shareButton6:SetHeight(text6:GetStringHeight())
shareButton6:SetText("Share")
shareButton6:RegisterForClicks("LeftButtonUp")
end

createMenuFrame = function()
	ReportOptions = CreateFrame("Frame","ReportOptions",UIParent)
	ReportOptions:SetPoint("LEFT", shareButton, "RIGHT")
	ReportOptions:EnableMouse()
	--ReportOptions:SetBackdrop(backdrop)
	ReportOptions:SetAlpha(1)
	
	ReportOption1 = CreateFrame("Frame","ReportOption1", ReportOptions)
	--ReportOption1:SetBackdrop(backdrop)
	ReportOption1Text = ReportOption1:CreateFontString(nil,"OVERLAY","GameFontNormal")
	ReportOption1Text:SetPoint("CENTER")
	ReportOption1Text:SetText("DinoChannel")
	ReportOption1Text:SetFont(DinoTimersFont, fontSize/1.5, fontFlags)
	ReportOption1:SetSize(ReportOption1Text:GetStringWidth(),ReportOption1Text:GetStringHeight())
	ReportOption1:SetPoint("TOPLEFT", ReportOptions, "TOPLEFT")
	
	ReportOption2 = CreateFrame("Frame","ReportOption2", ReportOptions)
	--ReportOption2:SetBackdrop(backdrop)
	ReportOption2Text = ReportOption2:CreateFontString(nil,"OVERLAY","GameFontNormal")
	ReportOption2Text:SetPoint("CENTER")
	ReportOption2Text:SetText("Whisper")
	ReportOption2Text:SetFont(DinoTimersFont, fontSize/1.5, fontFlags)
	ReportOption2:SetSize(ReportOption1Text:GetStringWidth(),ReportOption1Text:GetStringHeight())
	ReportOption2:SetPoint("TOPLEFT", ReportOption1, "BOTTOMLEFT")

	ReportOption3 = CreateFrame("Frame","ReportOption3", ReportOptions)
	--ReportOption3:SetBackdrop(backdrop)
	ReportOption3Text = ReportOption3:CreateFontString(nil,"OVERLAY","GameFontNormal")
	ReportOption3Text:SetPoint("BOTTOM")
	ReportOption3Text:SetText("Party")
	ReportOption3Text:SetFont(DinoTimersFont, fontSize/1.5, fontFlags)
	ReportOption3:SetSize(ReportOption1Text:GetStringWidth(),ReportOption1Text:GetStringHeight())
	ReportOption3:SetPoint("TOPLEFT", ReportOption2, "BOTTOMLEFT")
	
	ReportOptions:SetSize(ReportOption1Text:GetStringWidth(),ReportOption1Text:GetStringHeight()*3)
	ReportOptions:Hide()
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
	
	radarButton:SetWidth(timer:GetStringWidth()*2)
	radarButton:SetHeight(text6:GetStringHeight()*2)
	
	shareButton:SetWidth(timer:GetStringWidth()/1.5)
	shareButton:SetHeight(text:GetStringHeight()/2)

	shareButton1:SetWidth(timer:GetStringWidth()/1.5)
	shareButton1:SetHeight(text1:GetStringHeight())

	shareButton2:SetWidth(timer:GetStringWidth()/1.5)
	shareButton2:SetHeight(text2:GetStringHeight())

	shareButton3:SetWidth(timer:GetStringWidth()/1.5)
	shareButton3:SetHeight(text3:GetStringHeight())

	shareButton4:SetWidth(timer:GetStringWidth()/1.5)
	shareButton4:SetHeight(text4:GetStringHeight())

	shareButton5:SetWidth(timer:GetStringWidth()/1.5)
	shareButton5:SetHeight(text5:GetStringHeight())

	shareButton6:SetWidth(timer:GetStringWidth()/1.5)
	shareButton6:SetHeight(text6:GetStringHeight())
	
	ReportOption1:SetSize(ReportOption1Text:GetStringWidth(),ReportOption1Text:GetStringHeight())
	ReportOption1Text:SetFont(DinoTimersFont, fontSize/1.5, fontFlags)

	ReportOption2:SetSize(ReportOption1Text:GetStringWidth(),ReportOption1Text:GetStringHeight())
	ReportOption2Text:SetFont(DinoTimersFont, fontSize/1.5, fontFlags)
	
	ReportOption3:SetSize(ReportOption1Text:GetStringWidth(),ReportOption1Text:GetStringHeight())
	ReportOption3Text:SetFont(DinoTimersFont, fontSize/1.5, fontFlags)
	ReportOptions:SetSize(ReportOption1Text:GetStringWidth(),ReportOption1Text:GetStringHeight()*3)
	
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

shareAll = function()
		if(NW == 0) then
			shareTimer("NW", "reset")
		else
			shareTimer("NW", timeDead(NW))
		end
		
		if(N == 0) then
			shareTimer("N", "reset")
		else
			shareTimer("N", timeDead(N))
		end
		
		if(E == 0) then
			shareTimer("E", "reset")
		else
			shareTimer("E", timeDead(E))
		end
		
		if(W == 0) then
			shareTimer("W", "reset")
		else
			shareTimer("W", timeDead(W))
		end
		
		if(SW == 0) then
			shareTimer("SW", "reset")
		else
			shareTimer("SW", timeDead(SW))
		end
		
		if(SE == 0) then
			shareTimer("SE", "reset")
		else
			shareTimer("SE", timeDead(SE))
		end
end

share = function(self)
	if(self == shareButton) then
		shareAll()
		
	elseif(self == shareButton1) then
		if(NW == 0) then
			shareTimer("NW", "reset")
		else
			shareTimer("NW", timeDead(NW))
		end
	elseif(self == shareButton2) then
		if(N == 0) then
			shareTimer("N", "reset")
		else
			shareTimer("N", timeDead(N))
		end
	elseif(self == shareButton3) then
		if(E == 0) then
			shareTimer("E", "reset")
		else
			shareTimer("E", timeDead(E))
		end
	elseif(self == shareButton4) then
		if(W == 0) then
			shareTimer("W", "reset")
		else
			shareTimer("W", timeDead(W))
		end
	elseif(self == shareButton5) then
		if(SW == 0) then
			shareTimer("SW", "reset")
		else
			shareTimer("SW", timeDead(SW))
		end
	elseif(self == shareButton6) then
		if(SE == 0) then
			shareTimer("SE", "reset")
		else
			shareTimer("SE", timeDead(SE))
		end
	end
	ReportOptions:Hide()
end

dinorouteTexture = function()
	local width = WorldMapFrame.ScrollContainer:GetWidth()
	local height = WorldMapFrame.ScrollContainer:GetHeight()
	local dinoMapTexture = MyMapFrame:CreateTexture("$parentGlow", "OVERLAY")
	WorldMapFrame:SetAlpha(0.9)
	dinoMapTexture:SetTexture("Interface\\AddOns\\DinoTimers\\Textures\\dinoroute.tga")
	dinoMapTexture:SetPoint("TOPLEFT")	
	dinoMapTexture:SetSize(width,height)
	WorldMapFrame.BlackoutFrame:SetScript("OnShow", function(self) self:Hide() end)
end

createFrames()
backdropDefault()
setDefaults()
setButtonDefaults()
createOptionsPannel()
createMenuFrame()
adjustSize()
dinorouteTexture()

ReportOption1:SetScript("OnEnter", function()
	ReportOption1:SetBackdrop(backdrop)
end)

ReportOption2:SetScript("OnEnter", function()
	ReportOption2:SetBackdrop(backdrop)
end)

ReportOption3:SetScript("OnEnter", function()
	ReportOption3:SetBackdrop(backdrop)
end)

ReportOption1:SetScript("OnLeave", function()
	ReportOption1:SetBackdropColor(1,1,1,0)
end)

ReportOption2:SetScript("OnLeave", function()
	ReportOption2:SetBackdropColor(1,1,1,0)
end)

ReportOption3:SetScript("OnLeave", function()
	ReportOption3:SetBackdropColor(1,1,1,0)
end)

ReportOption1:SetScript("OnMouseDown", function(self, button)
	ReportOption1Text:SetFont(DinoTimersFont, fontSize/2, fontFlags)
end)

ReportOption2:SetScript("OnMouseDown", function(self, button)
	ReportOption2Text:SetFont(DinoTimersFont, fontSize/2, fontFlags)
end)

ReportOption3:SetScript("OnMouseDown", function(self, button)
	ReportOption3Text:SetFont(DinoTimersFont, fontSize/2, fontFlags)
end)

ReportOption1:SetScript("OnMouseUp", function(self, button)
	ReportOption1Text:SetFont(DinoTimersFont, fontSize/1.5, fontFlags)
	share(currentShareButton)
end)

ReportOption2:SetScript("OnMouseUp", function(self, button)
	ReportOption2Text:SetFont(DinoTimersFont, fontSize/1.5, fontFlags)
	StaticPopup_Show ("GetWhisperName")	
	ReportOptions:Hide()
end)

ReportOption3:SetScript("OnMouseUp", function(self, button)
	ReportOption3Text:SetFont(DinoTimersFont, fontSize/1.5, fontFlags)
end)

function MainFrame:OnUpdate(arg1) -- MAIN UPDATE FUNCTION!
	timeSinceUpdate = timeSinceUpdate + arg1
	if(updateInterval<timeSinceUpdate or updateNow == true) then
-- actual code on update here
		updateCurrentTime()
		timer:SetText(dtClr .. secondsFormat(sessionTime - sessionTimeOffset))
		
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
		if((sessionTime - dinoFoundTime > dinoFoundSoundInterval) and radarOn) then
			ScanForDinos()
		end	

-- actual code end
		if(updateNow == false) then
			timeSinceUpdate = 0
		else
			updateNow = false
		end

		IsMapOpenOnCratar()

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

radarButton:SetScript("OnMouseUp", function(self, button)
	if(radarButton:GetText() == "Radar") then
		radarButton:SetText("|cff00ff00Radar")
		radarOn = true
	elseif(radarButton:GetText()) == "|cffff0000Disconnect" then
		radarOn = false
		radarButton:SetText("Radar")
	end
end)

radarButton:SetScript('OnEnter', function()
	if(radarButton:GetText() == "|cff00ff00Radar") then
		radarButton:SetText("|cffff0000Disconnect")
	end
end)

radarButton:SetScript('OnLeave', function()
	if(radarButton:GetText() == "|cffff0000Disconnect") then
		radarButton:SetText("|cff00ff00Radar")
	end
end)

shareButton:SetScript("OnMouseUp", function(self, button)
	ReportOptions:Show()
	ReportOptions:SetPoint("LEFT", self, "RIGHT")
	currentShareButton = self
end)

shareButton1:SetScript("OnMouseUp", function(self, button)
	ReportOptions:Show()
	ReportOptions:SetPoint("LEFT", self, "RIGHT")
	currentShareButton = self
end)

shareButton2:SetScript("OnMouseUp", function(self, button)
	ReportOptions:Show()
	ReportOptions:SetPoint("LEFT", self, "RIGHT")
	currentShareButton = self
end)

shareButton3:SetScript("OnMouseUp", function(self, button)
	ReportOptions:Show()
	ReportOptions:SetPoint("LEFT", self, "RIGHT")
	currentShareButton = self
end)

shareButton4:SetScript("OnMouseUp", function(self, button)
	ReportOptions:Show()
	ReportOptions:SetPoint("LEFT", self, "RIGHT")
	currentShareButton = self
end)

shareButton5:SetScript("OnMouseUp", function(self, button)
	ReportOptions:Show()
	ReportOptions:SetPoint("LEFT", self, "RIGHT")
	currentShareButton = self
end)

shareButton6:SetScript("OnMouseUp", function(self, button)
	ReportOptions:Show()
	ReportOptions:SetPoint("LEFT", self, "RIGHT")
	currentShareButton = self
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

ChatFrame:SetScript("OnEvent", -- CHAT SCANNER!
	function(self, event, ...)
	local chatMessage, arg2, arg3, channelName, arg5, arg6, arg7, arg8, arg9 = ...
		if(string.find(string.lower(channelName), currentChannelName)) then
			if(string.find(chatMessage,"DinoTimers:")) then
				--local temp = chatMessage:gsub('%DinoTimers:','')
				local temp = string.match(chatMessage, ':(.*),')
				local temp2 = string.match(chatMessage, ',(.*)')
					if(temp2 == "") then
						temp2 = 0
					end
						diedAt(temp,temp2)
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

StaticPopupDialogs["GetWhisperName"] = {
	text = "Whisper Target's Name",
	button1 = "Send",
	button2 = "No",
	OnAccept = function(self)
		local text = self.editBox:GetText()
		whisperTimer(currentShareButton, text)
	end,
	hasEditBox = true,
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
	sessionTime = time() - tStart + sessionTimeOffset
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
	print(GetZoneText());
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
	DEFAULT_CHAT_FRAME.editBox:SetText("/" .. channelNumber .. " DinoTimers:" .. dino
	.. ",") 
	ChatEdit_SendText(DEFAULT_CHAT_FRAME.editBox)
	DEFAULT_CHAT_FRAME.editBox:SetText("") 
end

shareTimer = function(dino, offset)
	DEFAULT_CHAT_FRAME.editBox:SetText("/" .. channelNumber .. " DinoTimers:" .. dino
	.. "," .. offset) 
	ChatEdit_SendText(DEFAULT_CHAT_FRAME.editBox)
	DEFAULT_CHAT_FRAME.editBox:SetText("") 
end

whisperTimer = function(self, playerName)
	local currentDino = ""
	if(self == shareButton) then
		--shareAll()	
	elseif(self == shareButton1) then
		currentDino = "NW"
		currentDinoTimer = NW
	elseif(self == shareButton2) then
		currentDino = "N"
		currentDinoTimer = N
	elseif(self == shareButton3) then
		currentDino = "E"
		currentDinoTimer = E
	elseif(self == shareButton4) then
		currentDino = "W"
		currentDinoTimer = W
	elseif(self == shareButton5) then
		currentDino = "SW"
		currentDinoTimer = SW
	elseif(self == shareButton6) then
		currentDino = "SE"
		currentDinoTimer = SE
	end
	
	if(currentDino ~= "" and currentDinoTimer ~= 0) then
		DEFAULT_CHAT_FRAME.editBox:SetText("/w " .. playerName .. " " .. currentDino .. " Has been dead for: " .. secondsFormat(timeDead(currentDinoTimer))) 
		ChatEdit_SendText(DEFAULT_CHAT_FRAME.editBox)
		DEFAULT_CHAT_FRAME.editBox:SetText("") 
	end

end

secondsFormat = function(t)
	local days = floor(t/86400)
	local hours = floor(mod(t, 86400)/3600)
	local minutes = floor(mod(t,3600)/60)
	local seconds = floor(mod(t,60))
	if(t>3599) then 
		return format("%01d:%02d:%02d",hours,minutes,seconds)
	else
		return format("%02d:%02d",minutes,seconds)
	end
end

diedAt = function(dino, offset)
	if(offset == nil) then
		offset = 0
	end
	if(dino == "NW") then
		if(offset == "reset") then
			resetNW()
		else
			NW = sessionTime - offset
			startButton1:SetText("Reset")
			updateNow = true
		end
	end
	if(dino == "N") then
		if(offset == "reset") then
			resetN()
		else
			N = sessionTime - offset
			startButton2:SetText("Reset")
			updateNow = true
		end
	end
	if(dino == "E") then
		if(offset == "reset") then
			resetE()
		else
			E = sessionTime - offset
			startButton3:SetText("Reset")
			updateNow = true
		end
	end
	if(dino == "W") then
		if(offset == "reset") then
			resetW()
		else
			W = sessionTime - offset
			startButton4:SetText("Reset")
			updateNow = true
		end
	end
	if(dino == "SW") then
		if(offset == "reset") then
			resetSW()
		else
			SW = sessionTime - offset
			startButton5:SetText("Reset")
			updateNow = true
		end
	end
	if(dino == "SE") then
		if(offset == "reset") then
			resetSE()
		else
			SE = sessionTime - offset
			startButton6:SetText("Reset")
			updateNow = true
		end
	end

end

timeDead = function(dino)
	return sessionTime - dino
end

printController = function(dino)
	-- set color of text
	local clr = ""
	if(timeDead(dino) >= 300 and timeDead(dino) <480 ) then
		clr = "|cff00ff00"
	elseif(timeDead(dino)>=480) then
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

IsMapOpenOnCratar = function()
if (WorldMapFrame:IsVisible()) then
	if(WorldMapFrame:GetMapID() == 1449) then
			MyMapFrame:Show()
		else
			MyMapFrame:Hide()
		end
	end
end

ScanForDinos = function()
	ScanForD()
	ScanForT()
	ScanForI()
end

ScanForD = function()
	if(DEFAULT_CHAT_FRAME.editBox:GetText() == "") then
	print("searching..")
	DEFAULT_CHAT_FRAME.editBox:SetText("/target Devilsaur") 
	ChatEdit_SendText(DEFAULT_CHAT_FRAME.editBox)
	DEFAULT_CHAT_FRAME.editBox:SetText("") 
	local temp = StaticPopup1Text:GetText()
	if(temp ~= nil) then 
		if(string.find(temp, "DinoTimers")) then
			print("DINO FOUND")
			PlaySoundFile("Interface\\AddOns\\DinoTimers\\Sounds\\Walking.ogg", "Master")
			dinoFoundTime = sessionTime
		
			DEFAULT_CHAT_FRAME.editBox:SetText("/click StaticPopup1Button2")
			ChatEdit_SendText(DEFAULT_CHAT_FRAME.editBox)
			DEFAULT_CHAT_FRAME.editBox:SetText("")
			StaticPopup1Text:SetText(nil)
		end
	end
	end
end

ScanForT = function()
	if(DEFAULT_CHAT_FRAME.editBox:GetText() == "") then
	print("searching..")
	DEFAULT_CHAT_FRAME.editBox:SetText("/target Tyrant Devilsaur")
	ChatEdit_SendText(DEFAULT_CHAT_FRAME.editBox)
	DEFAULT_CHAT_FRAME.editBox:SetText("") 
	local temp = StaticPopup1Text:GetText()
	if(temp ~= nil) then 
		if(string.find(temp, "DinoTimers")) then
			print("DINO FOUND")
			PlaySoundFile("Interface\\AddOns\\DinoTimers\\Sounds\\Walking.ogg", "Master")
			dinoFoundTime = sessionTime
		
			DEFAULT_CHAT_FRAME.editBox:SetText("/click StaticPopup1Button2")
			ChatEdit_SendText(DEFAULT_CHAT_FRAME.editBox)
			DEFAULT_CHAT_FRAME.editBox:SetText("") 
			StaticPopup1Text:SetText(nil)
		end
	end
	end
end

ScanForI = function()
	if(DEFAULT_CHAT_FRAME.editBox:GetText() == "") then
	print("searching..")
	DEFAULT_CHAT_FRAME.editBox:SetText("/target Ironhide Devilsaur")
	ChatEdit_SendText(DEFAULT_CHAT_FRAME.editBox)
	DEFAULT_CHAT_FRAME.editBox:SetText("") 
	local temp = StaticPopup1Text:GetText()
	if(temp ~= nil) then 
		if(string.find(temp, "DinoTimers")) then
			print("DINO FOUND")
			PlaySoundFile("Interface\\AddOns\\DinoTimers\\Sounds\\Walking.ogg", "Master")
			dinoFoundTime = sessionTime
		
			DEFAULT_CHAT_FRAME.editBox:SetText("/click StaticPopup1Button2")
			ChatEdit_SendText(DEFAULT_CHAT_FRAME.editBox)
			DEFAULT_CHAT_FRAME.editBox:SetText("")
			StaticPopup1Text:SetText(nil)
		end
	end
	end
end

MainFrame:SetScript("OnUpdate", MainFrame.OnUpdate)

















