ncSpellalertDB = {}
ncSpellalertDB.CONFIG = {
	pvponly = true, -- set to false to always enable this addon, to true if you only want it in PvP enabled zones
	allunits = true, -- enable for all units, set to false to define your own units in the "units" table
	units = {
		"target",
		"focus",
	},
}
ncSpellalertDB.HARMFUL_SPELLS = {
	-- Priest
	[GetSpellInfo(605)] = 1, -- Mind Control
	[GetSpellInfo(13860)] = 1, -- Mind Blast
	[GetSpellInfo(7140)] = 1, -- Holy Fire
	[GetSpellInfo(13704)] = 1, -- Psychic Scream
	[GetSpellInfo(11444)] = 1, -- Shackle Undead
	[GetSpellInfo(64044)] = 1, -- Psychic Horror
	[GetSpellInfo(8129)] = 1, -- Mana Burn
	[GetSpellInfo(35155)] = 1, -- Smite
	[GetSpellInfo(34919)] = 1, -- Vampiric Touch
	[GetSpellInfo(32000)] = 1, -- Mind Sear

	-- Druid
	[GetSpellInfo(11922)] = 1, -- Entangling Roots
	[GetSpellInfo(33786)] = 1, -- Cyclone
	[GetSpellInfo(9739)] = 1, -- Wrath
	[GetSpellInfo(21668)] = 1, -- Starfire

	-- Deathknight
	[GetSpellInfo(47528)] = 1, -- Mind Freeze
	[GetSpellInfo(42650)] = 1, -- Army of the Dead
	[GetSpellInfo(47476)] = 1, -- Strangulate
	[GetSpellInfo(53570)] = 1, -- Hungering Cold
	
	-- Hunter
	[GetSpellInfo(3034)] = 1, -- Viper Sting
	[GetSpellInfo(24335)] = 1, -- Wyvern Sting
	[GetSpellInfo(34490)] = 1, -- Silencing Shot
	[GetSpellInfo(19503)] = 1, -- Scatter Shot
	
	-- Mage
	[GetSpellInfo(28285)] = 1, -- Polymorph
	[GetSpellInfo(29457)] = 1, -- Frostbolt
	[GetSpellInfo(20797)] = 1, -- Fireball
	[GetSpellInfo(58462)] = 1, -- Arcane Blast
	[GetSpellInfo(24995)] = 1, -- Pyroblast
	[GetSpellInfo(72169)] = 1, -- Flamestrike
	[GetSpellInfo(69570)] = 1, -- Frostfire Bolt
	[GetSpellInfo(11436)] = 1, -- Slow
	[GetSpellInfo(31687)] = 1, -- Summon Water Elemental
	[GetSpellInfo(10206)] = 1, -- Scorch
	[GetSpellInfo(36848)] = 1, -- Mirror Image

	-- Shaman
	[GetSpellInfo(15207)] = 1, -- Lightning Bolt
	[GetSpellInfo(25021)] = 1, -- Chain Lightning	
	[GetSpellInfo(53788)] = 1, -- Lava Burst
	[GetSpellInfo(39609)] = 1, -- Mana Tide Totem
	[GetSpellInfo(1350)] = 1, -- Feral Spirit

	-- Warlock
	[GetSpellInfo(30002)] = 1, -- Fear
	[GetSpellInfo(5484)] = 1, -- Howl of Terror
	[GetSpellInfo(6359)] = 1, -- Seduction
	[GetSpellInfo(22336)] = 1, -- Shadow Bolt
	[GetSpellInfo(32865)] = 1, -- Seed of Corruption
	[GetSpellInfo(7720)] = 1, -- Ritual of Summoning
	[GetSpellInfo(17924)] = 1, -- Soul Fire
	[GetSpellInfo(48210)] = 1, -- Haunt
	[GetSpellInfo(30358)] = 1, -- Searing Pain
	[GetSpellInfo(24466)] = 1, -- Banish
	[GetSpellInfo(69576)] = 1, -- Chaos Bolt
	[GetSpellInfo(348)] = 1, -- Immolate
	[GetSpellInfo(67931)] = 1, -- Death Coil
	[GetSpellInfo(48018)] = 1, -- Demonic Circle: Summon
	[GetSpellInfo(34438)] = 1, -- Unstable Affliction
	[GetSpellInfo(23308)] = 1, -- Incinerate
	[GetSpellInfo(39082)] = 1, -- Shadowfury

	-- Paladin
	[GetSpellInfo(17149)] = 1, -- Exorcism
}

ncSpellalertDB.HEALING_SPELLS = {
	-- Priest
	[GetSpellInfo(48119)] = 1, -- Binding Heal
	[GetSpellInfo(61964)] = 1, -- Circle of Healing
	[GetSpellInfo(27870)] = 1, -- Lightwell
	[GetSpellInfo(32375)] = 1, -- Mass Dispel
	[GetSpellInfo(17138)] = 1, -- Flash Heal
	[GetSpellInfo(60003)] = 1, -- Greater Heal
	[GetSpellInfo(59195)] = 1, -- Heal
	[GetSpellInfo(29170)] = 1, -- Lesser Heal
	[GetSpellInfo(15585)] = 1, -- Prayer of Healing
	[GetSpellInfo(35599)] = 1, -- Resurrection
	[GetSpellInfo(70619)] = 1, -- Divine Hymn
	[GetSpellInfo(64904)] = 1, -- Hymn of Hope
	[GetSpellInfo(52984)] = 1, -- Penance
	[GetSpellInfo(19238)] = 1, -- Desperate Prayer

	-- Druid
	[GetSpellInfo(23381)] = 1, -- Healing Touch
	[GetSpellInfo(34361)] = 1, -- Regrowth
	[GetSpellInfo(51918)] = 1, -- Revive
	[GetSpellInfo(35369)] = 1, -- Rebirth
	[GetSpellInfo(57765)] = 1, -- Nourish

	-- Paladin
	[GetSpellInfo(33641)] = 1, -- Flash of Light
	[GetSpellInfo(647)] = 1, -- Holy Light
	[GetSpellInfo(7328)] = 1, -- Redemption
	[GetSpellInfo(633)] = 1, -- Lay on Hands

	-- Shaman
	[GetSpellInfo(15799)] = 1, -- Chain Heal
	[GetSpellInfo(547)] = 1, -- Healing Wave
	[GetSpellInfo(28850)] = 1, -- Lesser Healing Wave
	[GetSpellInfo(20609)] = 1, -- Ancestral Spirit

	-- Rogue
	[GetSpellInfo(21060)] = 1, -- Blind
	[GetSpellInfo(36563)] = 1, -- Shadowstep
	[GetSpellInfo(44521)] = 1, -- Preparation
}

ncSpellalertDB.BUFF_SPELLS = {
	-- Druid
	[GetSpellInfo(16810)] = 1, -- Nature's Grasp,
	[GetSpellInfo(17116)] = 1, -- Nature's Swiftness,
	[GetSpellInfo(22842)] = 1, -- Frenzied Regeneration,
	[GetSpellInfo(29166)] = 1, -- Innervate,
	[GetSpellInfo(53191)] = 1, -- Starfall,
	[GetSpellInfo(43317)] = 1, -- Dash,
	
	-- Death Knight
	[GetSpellInfo(50514)] = 1, -- Summon Gargoyle,
	[GetSpellInfo(58130)] = 1, -- Icebound Fortitude,
	[GetSpellInfo(49028)] = 1, -- Dancing Rune Weapon,
	[GetSpellInfo(55213)] = 1, -- Hysteria,
	
	-- Mage
	[GetSpellInfo(29976)] = 1, -- Presence of Mind,
	[GetSpellInfo(36911)] = 1, -- Ice Block,
	[GetSpellInfo(25641)] = 1, -- Frost Ward,
	[GetSpellInfo(37844)] = 1, -- Fire Ward,
	[GetSpellInfo(54160)] = 1, -- Arcane Power,
	[GetSpellInfo(11392)] = 1, -- Invisibility,
	[GetSpellInfo(49264)] = 1, -- Blazing Speed,
	[GetSpellInfo(57761)] = 1, -- Fireball!,
	[GetSpellInfo(28682)] = 1, -- Combustion,
	[GetSpellInfo(12472)] = 1, -- Icy Veins,
	
	-- Shaman
	[GetSpellInfo(6742)] = 1, -- Bloodlust,
	[GetSpellInfo(64701)] = 1, -- Elemental Mastery,
	[GetSpellInfo(23689)] = 1, -- Heroism,
	
	-- Warlock
	[GetSpellInfo(17941)] = 1, -- Shadow Trance,
	[GetSpellInfo(37673)] = 1, -- Metamorphosis,
	
	-- Rogue
	[GetSpellInfo(57840)] = 1, -- Killing Spree,
	[GetSpellInfo(28752)] = 1, -- Adrenaline Rush,
	[GetSpellInfo(33735)] = 1, -- Blade Flurry,
	[GetSpellInfo(51713)] = 1, -- Shadow Dance,
	[GetSpellInfo(61922)] = 1, -- Sprint,
	[GetSpellInfo(8822)] = 1, -- Stealth,
	[GetSpellInfo(15087)] = 1, -- Evasion,
	[GetSpellInfo(39666)] = 1, -- Cloak of Shadows,
	
	-- Warrior
	[GetSpellInfo(46924)] = 1, -- Bladestorm
	[GetSpellInfo(12976)] = 1, -- Last Stand
	[GetSpellInfo(13847)] = 1, -- Recklessness
	[GetSpellInfo(20240)] = 1, -- Retaliation
	[GetSpellInfo(15062)] = 1, -- Shield Wall
	[GetSpellInfo(12292)] = 1, -- Death Wish
	[GetSpellInfo(9943)] = 1, -- Spell Reflection

	-- Paladin
	[GetSpellInfo(43430)] = 1, -- Avenging Wrath
	[GetSpellInfo(66115)] = 1, -- Hand of Freedom
	[GetSpellInfo(41450)] = 1, -- Blessing of Protection
	[GetSpellInfo(13874)] = 1, -- Divine Shield
	[GetSpellInfo(13007)] = 1, -- Divine Protection
	[GetSpellInfo(6940)] = 1, -- Hand of Sacrifice
	[GetSpellInfo(53601)] = 1, -- Sacred Shield
	[GetSpellInfo(54428)] = 1, -- Divine Plea

	-- Hunter
	[GetSpellInfo(31567)] = 1, -- Deterrence	
	[GetSpellInfo(34692)] = 1, -- The Beast Within

	-- Priest
	[GetSpellInfo(44416)] = 1, -- Pain Suppression
	[GetSpellInfo(37274)] = 1, -- Power Infusion
	[GetSpellInfo(47585)] = 1, -- Dispersion

	-- Racial
	[GetSpellInfo(69575)] = 1, -- Stoneform
	[GetSpellInfo(24378)] = 1, -- Berserking
}