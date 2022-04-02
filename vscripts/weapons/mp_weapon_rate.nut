global function OnWeaponPrimaryAttack_rate

var function OnWeaponPrimaryAttack_rate( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	if ( weapon.HasMod( "altfire_highcal" ) )
		thread PlayDelayedShellEject( weapon, RandomFloatRange( 0.03, 0.04 ) )

	weapon.FireWeapon_Default( attackParams.pos, attackParams.dir, 1.0, 1.0, false )

    #if CLIENT
    //printl(Time() - weapon.w.lastFireTime)
    printl(1 / (Time() - weapon.w.lastFireTime))
    weapon.w.lastFireTime = Time()
    #endif

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}
