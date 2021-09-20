global function OnWeaponAttemptOffhandSwitch_bs_warp
global function OnWeaponPrimaryAttack_bs_warp

global vector BS_WARP_POS = <0, 0, 0>

bool function OnWeaponAttemptOffhandSwitch_bs_warp( entity weapon )
{
	if ( <0, 0, 0> == BS_WARP_POS )
	{
		#if CLIENT
		AddPlayerHint( 1.0, 0.25, $"rui/hud/tactical_icons/tactical_mirage_in_world", "Location is not set" )
		#endif
		return false
	}

	return true
}

var function OnWeaponPrimaryAttack_bs_warp( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity player = weapon.GetWeaponOwner()
	float chargeTime = weapon.GetWeaponSettingFloat( eWeaponVar.charge_time )

#if SERVER
	LocPair loc = NewLocPair( BS_WARP_POS + <0, 0, 10>, <0,0,0> )
	player.SetOrigin( loc.origin )
	EmitSoundOnEntityOnlyToPlayer( player, player, "Wraith_PhaseGate_FirstGate_Place_1p" )
	EmitSoundOnEntityExceptToPlayer( player, player, "Wraith_PhaseGate_FirstGate_Place_3p" )
#else
	ScreenFlash( 80, 100, 140, 0, 0.2 )
#endif

	PhaseShift( player, 0, chargeTime, eShiftStyle.Dash )
	PlayerUsedOffhand( player, weapon )

	int ammoReq = weapon.GetAmmoPerShot()
	return ammoReq
}
