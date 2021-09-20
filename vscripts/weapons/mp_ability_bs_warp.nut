global function OnWeaponAttemptOffhandSwitch_bs_warp
global function OnWeaponPrimaryAttack_bs_warp

global vector BS_WARP_POS = <0, 0, 0>

bool function OnWeaponAttemptOffhandSwitch_bs_warp( entity weapon )
{
	print("-----")
	print(BS_WARP_POS)
	//int ammoReq = weapon.GetAmmoPerShot()
	//int currAmmo = weapon.GetWeaponPrimaryClipCount()
	//if ( currAmmo < ammoReq )
	//	return false

	//entity player = weapon.GetWeaponOwner()
	//if ( player.IsPhaseShifted() )
	//	return false

	if ( <0, 0, 0> == BS_WARP_POS )
	{
		#if CLIENT
		print("not ready")
		AddPlayerHint( 1.0, 0.25, $"rui/hud/tactical_icons/tactical_mirage_in_world", "Location is not set" )
		#endif
		return false
	}

	//if ( StatusEffect_GetSeverity( player, eStatusEffect.crypto_camera_is_recalling ) > 0.0 )
	//{
	//	//
	//	return false
	//}

	return true
}

var function OnWeaponPrimaryAttack_bs_warp( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity weaponOwner = weapon.GetWeaponOwner()
	float chargeTime = weapon.GetWeaponSettingFloat( eWeaponVar.charge_time )
	print("yay")
	//if ( StatusEffect_GetSeverity( weaponOwner, eStatusEffect.crypto_has_camera ) == 0.0 )
	//	return 0

#if SERVER
	//DroneFireEMP( weapon )
	entity owner = weapon.GetWeaponOwner()
	//entity camera = GetPlayerCamera( owner )
	//vector pos = camera.GetOrigin()
	//LocPair loc = NewLocPair( <8486, 27026, 5000>, <0,0,0> )
	LocPair loc = NewLocPair( BS_WARP_POS + <0, 0, 10>, <0,0,0> )
	weaponOwner.SetOrigin( loc.origin )
	EmitSoundOnEntityOnlyToPlayer( weaponOwner, weaponOwner, "Wraith_PhaseGate_FirstGate_Place_1p" )
	EmitSoundOnEntityExceptToPlayer( weaponOwner, weaponOwner, "Wraith_PhaseGate_FirstGate_Place_3p" )
#else
	ScreenFlash( 80, 100, 140, 0, 0.2 )
#endif

	PhaseShift( weaponOwner, 0, chargeTime, eShiftStyle.Dash )
	PlayerUsedOffhand( weaponOwner, weapon )

	int ammoReq = weapon.GetAmmoPerShot()
	return ammoReq
}
