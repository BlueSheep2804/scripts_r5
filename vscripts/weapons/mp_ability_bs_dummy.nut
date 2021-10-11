global function OnWeaponPrimaryAttack_bs_dummy

var function OnWeaponPrimaryAttack_bs_dummy( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	#if SERVER
	DEV_SpawnDummyAtCrosshair()
	#endif
	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire )
}
