#include <sourcemod>
#include <sdktools>

#pragma semicolon 1
#pragma newdecls required

public Plugin plugin =
{
    name = "[TF2] Undertale Speaker",
    author = "2010kohtep",
    description = "",
    version = "1.1.0",
    url = ""
};

bool IsUndyne(int entity)
{
	char m_ModelName[PLATFORM_MAX_PATH];
	GetEntPropString(entity, Prop_Data, "m_ModelName", m_ModelName, sizeof(m_ModelName));		
	
	return strcmp(m_ModelName, "models/nexuselite/undertale/undyne.mdl", false) == 0;
}

bool IsPapyrus(int entity)
{
	char m_ModelName[PLATFORM_MAX_PATH];
	GetEntPropString(entity, Prop_Data, "m_ModelName", m_ModelName, sizeof(m_ModelName));		
	
	return strcmp(m_ModelName, "models/freak_fortress_2/papyrus/papyrusv2.mdl", false) == 0;
}

public Action SoundHook(int clients[MAXPLAYERS], int &numClients, char sample[PLATFORM_MAX_PATH], 
	int &entity, int &channel, float &volume, int &level, int &pitch, 
	int &flags, char soundEntry[PLATFORM_MAX_PATH], int &seed)
{
	if (!IsValidClient(entity) || channel < 1)
	{
		return Plugin_Continue;
	}	
	
	if (IsUndyne(entity))
	{
		/* Sniper's laugh is pretty long, needs to emit long Undyne speak */
		if (strcmp(sample, "vo/sniper_LaughLong02.mp3", false) == 0)
		{
			Format(sample, sizeof(sample), "undertale/talk_undyne04.mp3");			
		}		
		else if (strncmp(sample, "vo/sniper_", 9, false) == 0 || 
				strncmp(sample, "vo/taunts/sniper/", 17, false) == 0 ||
				strncmp(sample, "vo/taunts/sniper_", 17, false) == 0)
		{		
			Format(sample, sizeof(sample), "undertale/talk_undyne0%d.mp3", GetRandomInt(1, 3));	
		}
		
		PrecacheSound(sample);	
	}
	else if (IsPapyrus(entity))
	{
		if (strncmp(sample, "vo/sniper_", 9, false) == 0 || 
				strncmp(sample, "vo/taunts/sniper/", 17, false) == 0 ||
				strncmp(sample, "vo/taunts/sniper_", 17, false) == 0)
		{		
			Format(sample, sizeof(sample), "undertale/talk_papyrus0%d.mp3", GetRandomInt(1, 3));	
		}		
	}
	
	return Plugin_Changed;
}

stock bool IsValidClient(int client)
{
	if (client <= 0 || client > MaxClients) 
	{ 
		return false;
	}

	return IsClientInGame(client);
}

public void OnPluginStart()
{
	AddNormalSoundHook(SoundHook);
}

public void OnMapStart()
{
	PrecacheSound("undertale/talk_undyne01.mp3");
	PrecacheSound("undertale/talk_undyne02.mp3");
	PrecacheSound("undertale/talk_undyne03.mp3");
	PrecacheSound("undertale/talk_undyne04.mp3");
	AddFileToDownloadsTable("sound/undertale/talk_undyne01.mp3");
	AddFileToDownloadsTable("sound/undertale/talk_undyne02.mp3");
	AddFileToDownloadsTable("sound/undertale/talk_undyne03.mp3");
	AddFileToDownloadsTable("sound/undertale/talk_undyne04.mp3");
	
	PrecacheSound("undertale/talk_papyrus01.mp3");
	PrecacheSound("undertale/talk_papyrus02.mp3");
	PrecacheSound("undertale/talk_papyrus03.mp3");
	AddFileToDownloadsTable("sound/undertale/talk_papyrus01.mp3");
	AddFileToDownloadsTable("sound/undertale/talk_papyrus02.mp3");
	AddFileToDownloadsTable("sound/undertale/talk_papyrus03.mp3");
}