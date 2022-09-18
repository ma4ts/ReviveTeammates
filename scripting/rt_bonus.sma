#include <amxmodx>
#include <rt_api>

#define MAX_SPAWN_WEAPONS 6

enum CVARS
{
	WEAPONS[256],
	Float:HEALTH,
	ARMOR_TYPE,
	ARMOR,
	FRAGS
};

new g_eCvars[CVARS];

new g_iWeapons;
new g_szWeapon[MAX_SPAWN_WEAPONS][32];

public plugin_init()
{
	register_plugin("Revive Teammates: Bonus", VERSION, AUTHORS);
	
	register_dictionary("rt_library.txt");

	bind_pcvar_string(create_cvar("rt_weapons", "weapon_knife weapon_deagle", FCVAR_NONE, "What weapons should be given to the player after resurrection(no more than 6)(otherwise standard from game.cfg)"), g_eCvars[WEAPONS], charsmax(g_eCvars[WEAPONS]));
	bind_pcvar_float(create_cvar("rt_health", "100.0", FCVAR_NONE, "The number of health of the resurrected player", true, 1.0), g_eCvars[HEALTH]);
	bind_pcvar_num(create_cvar("rt_armor_type", "2", FCVAR_NONE, "0 - do not issue armor, 1 - bulletproof vest, 2 - bulletproof vest with helmet", true, 1.0), g_eCvars[ARMOR_TYPE]);
	bind_pcvar_num(create_cvar("rt_armor", "100", FCVAR_NONE, "Number of armor of the resurrected player", true, 1.0), g_eCvars[ARMOR]);
	bind_pcvar_num(create_cvar("rt_frags", "1", FCVAR_NONE, "Number of frags for resurrection", true, 1.0), g_eCvars[FRAGS]);

	if(g_eCvars[WEAPONS][0] != EOS)
	{
		new szWeapon[32];
				
		while(argbreak(g_eCvars[WEAPONS], szWeapon, charsmax(szWeapon), g_eCvars[WEAPONS], charsmax(g_eCvars[WEAPONS])) != -1)
		{
			if(g_iWeapons == MAX_SPAWN_WEAPONS)
			{
				break;
			}

			copy(g_szWeapon[g_iWeapons++], charsmax(g_szWeapon[]), szWeapon);
		}
	}
}

public plugin_cfg()
{
	UTIL_UploadConfigs();
}

public rt_revive_end(const id, const activator, const modes_struct:mode)
{
	if(mode == MODE_REVIVE)
	{
		if(g_eCvars[HEALTH])
		{
			set_entvar(id, var_health, g_eCvars[HEALTH]);
		}

		if(g_eCvars[ARMOR_TYPE])
		{
			rg_set_user_armor(id, g_eCvars[ARMOR], ArmorType:ARMOR_TYPE);
		}

		if(g_szWeapon[0][0] != EOS)
		{
			for(new i; i <= g_iWeapons; i++)
			{
				rg_give_item(id, g_szWeapon[i]);
			}
		}
		else
		{
			rg_give_default_items(id);
		}

		if(g_eCvars[FRAGS])
		{
			ExecuteHamB(Ham_AddPoints, activator, g_eCvars[FRAGS], false);
		}
	}
}