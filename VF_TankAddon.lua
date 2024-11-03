--VF_TankAddon 
--Written by Dilatazu @ EmeraldDream @ www.EmeraldDream.com / www.wow-one.com
--Updated by Otari98 @https://github.com/Otari98/VF_WarriorAddon
--Updated by Krautchanpro "Dirtyclaws" for all tanks and TurtleWoW support @https://github.com/krautchanpro/VF_TankAddon

VF_TA_Version = "1.0";

function VF_TA_OnLoad()
	--this:RegisterEvent("CHAT_MSG_SPELL_SELF_BUFF");
	this:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE");
end

g_DebugMode = false;

function VF_TA_DebugPrint(theText)
	if(g_DebugMode == true) then
		DEFAULT_CHAT_FRAME:AddMessage(theText, 1, 1, 0);
	end
end

g_CurrTime = 0;

VF_ShieldWallTime = 15;

function VF_GetBuffCount(unitID, buffIcon)
	for u = 1, 16 do
		local buffIconPath, buffCount = UnitBuff(unitID, u);
		if(buffIconPath) then
			if(strfind(buffIconPath, buffIcon) ~= nil) then
				return buffCount;
			end
		end
	end
	return 0;
end

function VF_TA_OnEvent()
	if(event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS") then
		local _, _, gainWhat = string.find(arg1, "You gain (.*).");
		if(gainWhat ~= nil) then
			if(gainWhat == "Last Stand") then
				SendChatMessage("Last Stand is activated for 20 seconds!", "RAID");
				SendChatMessage("Last Stand is activated for 20 seconds!", "PARTY");
			elseif(gainWhat == "Shield Wall") then
				SendChatMessage("Shield Wall is activated for "..VF_ShieldWallTime.." seconds!", "RAID");
				SendChatMessage("Shield Wall is activated for "..VF_ShieldWallTime.." seconds!", "PARTY");
                        elseif(gainWhat == "Berserk") then
				SendChatMessage("Berserk is activated for 20 seconds!", "RAID");
				SendChatMessage("Berserk is activated for 20 seconds!", "PARTY");
			elseif(gainWhat == "Frenzied Regeneration") then
				SendChatMessage("Frenzied Regeneration is activated for 10 seconds!", "RAID");
				SendChatMessage("Frenzied Regeneration is activated for 10 seconds!", "PARTY");
			elseif(gainWhat == "Barkskin (Feral)") then
				SendChatMessage("Barkskin(Feral) is activated for 12 seconds!", "RAID");
				SendChatMessage("Barkskin(Feral) is activated for 12 seconds!", "PARTY");
			elseif(gainWhat == "Bulwark of the Righteous") then
				SendChatMessage("Bulwark of the Righteous is activated for 12 seconds!", "RAID");
				SendChatMessage("Bulwark of the Righteous is activated for 12 seconds!", "PARTY");
			else
				VF_TA_DebugPrint("I gained "..gainWhat);
			end
		else
			VF_TA_DebugPrint("UNPARSED1: "..arg1);
		end
	elseif(event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE") then
		--[[local _, _, creature, spellEffect = string.find(arg1, "(.*) is afflicted by (.*).");
		if(creature ~= nil and spellEffect ~= nil) then
			if(spellEffect == "Taunt") then
				g_TauntCastTime = -1;
			elseif(spellEffect == "Challenging Shout") then
				g_ChallengingShoutCastTime = -1;
			elseif(spellEffect == "Mocking Blow") then
				VF_TA_DebugPrint("This message should never be shown!");
                        elseif(spellEffect == "Growl") then
				g_GrowlCastTime = -1;
                        elseif(spellEffect == "Challenging Roar") then
				g_ChallengingRoarCastTime = -1;
		                SendChatMessage("Challenging Roar Activated!", "RAID");
			        SendChatMessage("Challenging Roar Activated!", "PARTY");
                        elseif(spellEffect == "Hand of Reckoning") then
				g_HandofReckoningCastTime = -1;
		        elseif(spellEffect == "Earthshaker Slam") then
				g_EarthshakerSlamCastTime = -1;
			else
				VF_TA_DebugPrint(spellEffect.." on "..creature.." was successful!");
			end
		else
			VF_TA_DebugPrint("UNPARSED2: "..arg1);
		end--]]
	elseif(event == "CHAT_MSG_SPELL_SELF_DAMAGE") then
		local actionStatus = "Hit";
		local _, _, spellEffect, creature, dmg = string.find(arg1, "Your (.*) hits (.*) for (.*).");
		
		if(spellEffect == nil or creature == nil or dmg == nil) then
			_, _, spellEffect, creature, dmg = string.find(arg1, "Your (.*) crits (.*) for (.*).");
			actionStatus = "Crit";
		end
		
		if(spellEffect == nil or creature == nil or dmg == nil) then
			_, _, spellEffect, creature = string.find(arg1, "Your (.*) was resisted by (.*).");
			dmg = 0;
			actionStatus = "Resist";
		end
		
		if(spellEffect == nil or creature == nil or dmg == nil) then
			_, _, spellEffect, creature = string.find(arg1, "Your (.*) missed (.*).");
			dmg = 0;
			actionStatus = "Miss";
		end
		
		if(spellEffect == nil or creature == nil or dmg == nil) then
			_, _, spellEffect, creature = string.find(arg1, "Your (.*) was dodged by (.*).");
			dmg = 0;
			actionStatus = "Dodge";
		end

		if(spellEffect == nil or creature == nil or dmg == nil) then
			_, _, spellEffect, creature = string.find(arg1, "Your (.*) is parried by (.*).");
			dmg = 0;
			actionStatus = "Parry";
		end

		if(spellEffect == nil or creature == nil or dmg == nil) then
			_, _, spellEffect, creature = string.find(arg1, "Your (.*) was blocked by (.*).");
			dmg = 0;
			actionStatus = "Block";
		end
		
		if(spellEffect == nil or creature == nil or dmg == nil) then
			actionStatus = "Unknown";
		end
		if((actionStatus == "Miss" 
			or actionStatus == "Resist"
			or actionStatus == "Dodge"
			or actionStatus == "Parry"
			or actionStatus == "Block")
			and spellEffect == "Mocking Blow")
		then
			SendChatMessage("Mocking Blow Failed!", "RAID");
			SendChatMessage("Mocking Blow Failed!", "PARTY");
		elseif(actionStatus == "Resist" and spellEffect == "Taunt") then
			SendChatMessage("Taunt Resisted!", "RAID");
			SendChatMessage("Taunt Resisted!", "PARTY");
		elseif(actionStatus == "Resist" and spellEffect == "Challenging Shout") then
			SendChatMessage("Challenging Shout Resisted!", "RAID");
			SendChatMessage("Challenging Shout Resisted!", "PARTY");
                elseif(actionStatus == "Resist" and spellEffect == "Growl") then
			SendChatMessage("Growl Resisted!", "RAID");
			SendChatMessage("Growl Resisted!", "PARTY");
		elseif(actionStatus == "Resist" and spellEffect == "Challenging Roar") then
			SendChatMessage("Challenging Roar Resisted!", "RAID");
			SendChatMessage("Challenging Roar Resisted!", "PARTY");
                elseif(actionStatus == "Resist" and spellEffect == "Hand of Reckoning") then
			SendChatMessage("Hand of Reckoning Resisted!", "RAID");
			SendChatMessage("Hand of Reckoning Resisted!", "PARTY");
		elseif(actionStatus == "Resist" and spellEffect == "Earthshaker Slam") then
			SendChatMessage("Earthshaker Slam Resisted!", "RAID");
			SendChatMessage("Earthshaker Slam Resisted!", "PARTY");
		elseif(actionStatus == "Unknown") then
			VF_TA_DebugPrint("UNPARSED3: "..arg1);
		end
	elseif(event == "VF_INSTANT_SUCCESSFULL_SPELLCAST") then
		VF_TA_DebugPrint("Instant Cast Spell: "..arg1);
	else
		if(arg1 == nil) then
			VF_TA_DebugPrint("UNPARSED4: "..event);
		else
			VF_TA_DebugPrint("UNPARSED4: "..event..arg1);
		end
	end
	--AURAADDEDOTHERHARMFUL == %s is afflicted by %s.
end

function VF_TA_OnUpdate()
	g_CurrTime = GetTime();
end
