

TukuiDB["general"] = {
	["autoscale"] = true, -- mainly enabled for users that don't want to mess with the config file
	["uiscale"] = 1, -- set your value (between 0.64 and 1) of your uiscale if autoscale is off
	["overridelowtohigh"] = false, -- EXPERIMENTAL ONLY! override lower version to higher version on a lower reso.
	["multisampleprotect"] = true, -- i don't recommend this because of shitty border but, voila!
}

TukuiDB["media"] = {
	["uffont"] = [[Interface\Addons\Tukui\media\mungcomic2.ttf]], -- general font of unitframes----------------
	["font"] = [[Interface\AddOns\Tukui\media\mungfont3.ttf]], -- general font of general-ness---------------
	["superfont"] = [[Interface\AddOns\Tukui\media\mungfont.ttf]], -- super neat-o font----------------------
	["dmgfont"] = [[Interface\AddOns\Tukui\media\mungfont.ttf]], -- general font for sct------------------
	["pixelfont"] = [[Interface\AddOns\Tukui\media\micromung.ttf]], -- teeny-tiny font-----------------------
	["pixelfont2"] = [[Interface\AddOns\Tukui\media\micromung2.ttf]], -- teeny-tiny font---------------------
	["clockfont"] = [[Interface\Addons\Tukui\media\clockfont.ttf]], -- font for the clock (duh dude....)-----
	["normTex"] = [[Interface\Addons\Tukui\media\normTex]], -- texture used for tukui healthbar/powerbar/etc-
	["normTex2"] = [[Interface\AddOns\Tukui\media\normTex2]],
	["barTex1"] = [[Interface\AddOns\Tukui\media\barTex1]],
	["barTex2"] = [[Interface\AddOns\Tukui\media\barTex2]],
	["barTex3"] = [[Interface\AddOns\Tukui\media\barTex3]],
	["glowTex"] = [[Interface\Addons\Tukui\media\glowTex]], -- the glow text around some frame.
	["bubbleTex"] = [[Interface\Addons\Tukui\media\bubbleTex]], -- unitframes combo points
	["blank"] = [[Interface\AddOns\Tukui\media\blank]], -- the main texture for all borders/panels
	["bordercolor"] = { 0,0,0,0.4 }, -- border color of tukui panels
	["altbordercolor"] = { 0,0,0,0.4 }, -- alternative border color, mainly for unitframes text panels.
	["backdropcolor"] = { 0.25,0.25,0.25,1 }, -- background color of tukui panels
	["unitcolor"] = { 0.25,0.25,0.25,1 }, -- background color of tukui panels
	["unitshadowcolor"] = { 0,0,0,0.4 }, -- background color of tukui panels
	["buttonhover"] = [[Interface\AddOns\Tukui\media\button_hover]],
	["buttonFlash"] = [[Interface\AddOns\Tukui\media\flash]],
	["buttonTex"] = [[Interface\AddOns\Tukui\media\gloss]],
	["castb"] = [[Interface\AddOns\Tukui\media\cast1]],
	["castb2"] = [[Interface\AddOns\Tukui\media\cast2]],
	["deadwall"] = [[Interface\AddOns\Tukui\media\evilBG]],
	["unitwall"] = [[Interface\AddOns\Tukui\media\goodBG]],
	["alert"] = [[Interface\AddOns\Tukui\media\ohshit]],
	["deadman"] = [[Interface\AddOns\Tukui\media\fukimdead]],
}

TukuiDB["unitframes"] = {
	-- general options
	["enable"] = true, -- -- can i really need to explain this?
	["unitcastbar"] = true, -- enable tukui castbar
	["cblatency"] = false, -- enable castbar latency
	["cbicons"] = true, -- enable icons on castbar
	["auratimer"] = true, -- enable timers on buffs/debuffs
	["auraspiral"] = true, -- enable spiral timer on auras.
	["auratextscale"] = 11, -- the font size of buffs/debuffs timers
	["playerauras"] = true, -- enable auras on player unit frame
	["targetauras"] = true, -- enable auras on target unit frame
	["highThreshold"] = 80, -- hunter high threshold
	["lowThreshold"] = 20, -- global low threshold, for low mana warning.
	["targetpowerpvponly"] = true, -- enable power text on pvp target only
	["totdebuffs"] = false, -- enable tot debuffs (high reso only)
	["focusdebuffs"] = false, -- enable focus debuffs 
	["playerdebuffsonly"] = true, -- enable our debuff only on our current target
	["showfocustarget"] = false, -- show focus target
	["showtotalhpmp"] = true, -- change the display of info text on player and target with XXXX/Total.
	["showsmooth"] = true, -- enable smooth bar
	["showthreat"] = false, -- enable the threat bar anchored to info left panel.
	["charportrait"] = true, -- can i really need to explain this?
	["t_mt"] = false, -- enable maintank and mainassist
	["t_mt_power"] = false, -- enable power bar on maintank and mainassist because it's not show by default.
	["combatfeedback"] = false, -- enable combattext on player and target.
	["classcolor"] = true, -- if set to false, use foof color theme. 
	["playeraggro"] = true, -- glow border of player frame change color according to your current aggro.

	-- raid layout
	["showrange"] = true, -- show range opacity on raidframes
	["raidalphaoor"] = 0.2, -- alpha of unitframes when unit is out of range
	["gridposX"] = 18, -- horizontal position starting from left
	["gridposY"] = -250, -- vertical position starting from top
	["gridposZ"] = "TOPLEFT", -- if we want to change the starting position zone
	["gridonly"] = true, -- enable grid only mode for all healer mode raid layout.
	["showsymbols"] = true,	-- show symbol.
	["aggro"] = true, -- show aggro on all raids layouts
	["raidunitdebuffwatch"] = true, -- track important spell to watch in pve for healing mode.
	["gridhealthvertical"] = false, -- enable vertical grow on health bar
	["showplayerinparty"] = true, -- show my player frame in party
	["gridscale"] = 1, -- set the healing grid scaling
	["gridmaxgroup"] = 8, -- max # of group you want to show on grid layout, between 1 and 8

	-- priest only plugin
	["ws_show_time"] = false, -- show time on weakened soul bar
	["ws_show_player"] = false, -- show weakened soul bar on player unit
	["ws_show_target"] = false, -- show weakened soul bar on target unit
	["if_ve_warning"] = true, -- show innerfire/vampiric embrace warnings when in combat and not active.
	
	-- death knight only plugin
	["runebar"] = true, -- enable tukui runebar plugin
	
	-- shaman only plugin
	["totembar"] = true, -- enable tukui totem bar plugin
	
	-- general uf extra, mostly experimental
	["fadeufooc"] = false, -- fade unitframe when out of combat
	["fadeufoocalpha"] = 0, -- alpha you want out of combat between 0 and 1.
}

TukuiDB["arena"] = {
	["unitframes"] = true, -- enable tukz arena unitframes (requirement : tukui unitframes enabled)
	["spelltracker"] = false, -- enable tukz enemy spell tracker	
}

TukuiDB["actionbar"] = {
	["enable"] = true, -- enable tukz action bars
	["hotkey"] = false, -- enable hotkey display because it was a lot requested
	["rightbarmouseover"] = true, -- enable right bars on mouse over
	["shapeshiftmouseover"] = false, -- enable shapeshift or totembar on mouseover
	["hideshapeshift"] = false, -- hide shapeshift or totembar because it was a lot requested.
	["bottomrows"] = 2, -- numbers of row you want to show at the bottom (select between 1 and 3)
	["rightbars"] = 1, -- numbers of right bar you want
	["verticalshapeshift"] = true, -- Orient the shapeshift or totem bar vertically
    ["flipshapeshift"] = true, -- Expand shapeshift or totem bar down/left instead of up/right
}

TukuiDB["nameplate"] = {
	["enable"] = true, -- enable nice skinned nameplates that fit into tukui
}

TukuiDB["bags"] = {
	["enable"] = true, -- enable an all in one bag mod that fit tukui perfectly
}

TukuiDB["map"] = {
	["enable"] = true, -- reskin the map to fit tukui
}

TukuiDB["loot"] = {
	["lootframe"] = true, -- reskin the loot frame to fit tukui
	["rolllootframe"] = true, -- reskin the roll frame to fit tukui
}

TukuiDB["cooldown"] = {
	["enable"] = true, -- can i really need to explain this?
	["treshold"] = 8, -- show decimal under X seconds and text turn red
}

TukuiDB["datatext"] = {
	["fps_ms"] = 9, -- show fps and ms on panels
	["mem"] = 10, -- show total memory on panels
	["wowtime"] = 8, -- show time on panels
	["guild"] = 0, -- show number on guildmate connected on panels
	["friends"] = 0, -- show number of friends connected.
	["dps_text"] = 0, -- show a dps meter on panels
	["hps_text"] = 0, -- show a heal meter on panels
	["zone"] = 7, -- show current player zone text !!SHOULD ALWAYS BE 9!!!!!
	
	["battleground"] = true, -- enable 3 stats in battleground only that replace stat1,stat2,stat3.
	["time24"] = false, -- set time to 24h format.
	["localtime"] = true, -- set time to local time instead of server time.
	["font"] = [[fonts\ARIALN.ttf]], -- font used for panels.
	["fontsize"] = 10, -- font size for panels.
}

TukuiDB["chat"] = {
	["enable"] = true, -- blah
	["font"] = [[fonts\ARIALN.ttf]], -- font for chat
	["fontsize"] = 10, -- font size for chat
	["fontsize2"] = 12, -- font size for alert chat
	["chattime"] = true, -- enable chat time on chat
}

TukuiDB["panels"] = { 
	["tinfowidth"] = 300, -- the width of left and right stat panels.
}

TukuiDB["tooltip"] = {
	["enable"] = true, -- true to enable this mod, false to disable
	["cursor"] = false, -- enable units tooltip on cursor
}

TukuiDB["combatfont"] = {
	["enable"] = true, -- true to enable this mod, false to disable
}

TukuiDB["merchant"] = {
	["enable"] = true, -- true to enable this mod, false to disable
	["sellgrays"] = true, -- automaticly sell grays?
	["autorepair"] = true, -- automaticly repair?
}

TukuiDB["error"] = {
	["enable"] = true, -- true to enable this mod, false to disable
	filter = { -- what messages to not hide
		["Inventory is full."] = true, -- inventory is full will not be hidden by default
	},
}

TukuiDB["invite"] = { 
	["autoaccept"] = true, -- auto-accept invite from guildmate and friends.
}

TukuiDB["combo"] = { 
	["enable"] = true, -- enable middle screen combo text pts.
}

TukuiDB["watchframe"] = { 
	["movable"] = true, -- disable this if you run "Who Framed Watcher Wabbit" from seerah.
}

if not TukuiDB.skins then TukuiDB.skins = {} end
TukuiDB.skins.SexyCooldown = {
	["Bar 0"] = { noborder = true, noiconborder = false},
	actionbar = "Bar 0"
}
--CUSTOM class colors
TukuiDB["classy"] = {
	["DEATHKNIGHT"] = { 236/255,  50/255,  80/255 },
	["DRUID"]       = { 255/255, 125/255,  30/255 },
	["HUNTER"]      = {  90/255, 255/255,  90/255 },
	["MAGE"]        = {  20/255, 191/255, 255/255 },
	["PALADIN"]     = { 245/255,  40/255, 146/255 },
	["PRIEST"]      = { 248/255, 248/255, 255/255 },
	["ROGUE"]       = { 255/255, 243/255,  32/255 },
	["SHAMAN"]      = {  81/255,  81/255, 255/255 },
	["WARLOCK"]     = { 208/255,  93/255, 246/255 },
	["WARRIOR"]     = { 172/255,  102/255,  29/255 },
}
--CUSTOM Health gradient for colorSmooth
TukuiDB["LIFE"] = {0.99, 0.01, 0.01, 0.95, 0.95, 0.10, 0.25, 0.25, 0.25}

--CUSTOM Power gradient for colorSmooth
TukuiDB["POW"] = {0.01, 0.31, 0.91, 0.15, 0.93, 0.95, 0.15, 0.15, 0.15}

-- an example if you want multiple config
if TukuiDB.myname == "Tùkz" or TukuiDB.myname == "Tukz" then
	TukuiDB["focus"] = { 
		["enable"] = true, -- enable mouseover focus key
		["arenamodifier"] = "shift", -- modifier to use
		["arenamouseButton"] = "3", -- mouse button to use
	}
else
	TukuiDB["focus"] = { 
		["enable"] = false, -- enable mouseover focus key
		["arenamodifier"] = "shift", -- modifier to use
		["arenamouseButton"] = "3", -- mouse button to use
	}
end