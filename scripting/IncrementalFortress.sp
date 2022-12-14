#include <tf2>
#include <tf2_stocks>
#include <tf2items>
#include <tf2_isPlayerInSpawn>
#include <tf_ontakedamage>
#include <sourcemod>
#include <functions>
#include <keyvalues>
#include <sdktools>
#include <dhooks>
#include <weapondata>
#include <clientprefs>
#include <morecolors>
#include <razorstocks>
#include <stocksoup/memory>
#include <vphysics>
#include <tf2utils>

#pragma tabsize 0

#define SecondaryCostReduction 1.0
#define RED 0
#define BLUE 1
#define NB_SLOTS_UED 6
#define MAX_ATTRIBUTES 7000
#define MAX_ATTRIBUTES_ITEM 65
#define _NUMBER_DEFINELISTS 630
#define _NUMBER_DEFINELISTS_CAT 9
#define WCNAMELISTSIZE 700
#define _NB_SP_TWEAKS 90
#define NB_WEAPONS 20
#define Max_Attunement_Slots 10
#define MAX_STAGES 5

#define SOUND_THUNDER "ambient/explosions/explode_9.wav"
#define SOUND_ZAP  "misc/halloween/spell_lightning_ball_impact.wav"
#define SOUND_HEAL "misc/halloween/spell_overheal.wav"
#define SOUND_CALLBEYOND_CAST "misc/halloween/spell_lightning_ball_cast.wav"
#define SOUND_CALLBEYOND_ACTIVE "weapons/cow_mangler_explosion_normal_01.wav"
#define SOUND_FREEZE "physics/glass/glass_impact_bullet4.wav"
#define SOUND_HORN_RED "weapons/battalions_backup_red.wav"
#define SOUND_HORN_BLUE "weapons/battalions_backup_blue.wav"
#define SOUND_SHOCKWAVE "weapons/cow_mangler_explosion_charge_04.wav"
#define SOUND_ARCANESHOOT "weapons/sniper_railgun_charged_shot_crit_01.wav"
#define SOUND_ARCANESHOOTREADY "weapons/upgrade_explosive_headshot.wav"
#define SOUND_SPEEDAURA "weapons/bumper_car_speed_boost_start.wav"
#define SOUND_INFERNO "weapons/bombinomicon_explode1.wav"
#define SOUND_FAIL "mvm/mvm_money_vanish.wav"
#define SOUND_SABOTAGE "weapons/sentry_damage1.wav"
#define SOUND_ARROW "weapons/bow_shoot.wav"
#define SOUND_ADRENALINE "items/powerup_pickup_knockout_melee_hit.wav"
#define SOUND_REVENGE "items/powerup_pickup_team_revenge.wav"
#define SOUND_SUPERNOVA "items/powerup_pickup_supernova_activate.wav"
#define SOUND_DASH "weapons/bumper_car_jump.wav"
#define SOUND_JAR_EXPLOSION "weapons/jar_explode.wav"

#define PLUGIN_VERSION "INDEV-1.0"

// Plugin Info
public Plugin:myinfo =
{
	name = "Incremental Upgrades",
	author = "Telia (post-2.0) & Razor (pre-2.0)",
	description = "Incremental game styled MvM upgrades on any gamemode.",
	version = PLUGIN_VERSION,
	url = "https://github.com/rustedBlood/Incremental-Fortress",
}

#include "IncFort/globalVariables.sp"
#include "IncFort/functions.sp"
#include "IncFort/timers.sp"
#include "IncFort/configSystem.sp"
#include "IncFort/onPluginStart.sp"
#include "IncFort/commands.sp"
#include "IncFort/damageSystem.sp"
#include "IncFort/menuFrontEnd.sp"
#include "IncFort/menuBackEnd.sp"
#include "IncFort/collisionOverrides.sp"
#include "IncFort/databases.sp"
#include "IncFort/events.sp"
#include "IncFort/arcaneSystem.sp"