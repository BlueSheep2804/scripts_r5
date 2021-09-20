global function OnWeaponPrimaryAttack_bs_warp_position

var function OnWeaponPrimaryAttack_bs_warp_position( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity player = weapon.GetWeaponOwner()
	Assert( player.IsPlayer() )

#if CLIENT
	CreateARIndicator( player )
#else
    vector eyePos = player.EyePosition()
	vector viewVector = player.GetViewVector()
	TraceResults trace = TraceLine( eyePos, eyePos + (viewVector * 5000.0), player, TRACE_MASK_SOLID_BRUSHONLY, TRACE_COLLISION_GROUP_NONE )
	print(trace.fraction)
	if ( trace.fraction < 1.0 )
	{
		trace = TraceLine( trace.endPos, trace.endPos + <0,0,-2000 * trace.fraction >, player, TRACE_MASK_SOLID_BRUSHONLY, TRACE_COLLISION_GROUP_NONE )
        BS_WARP_POS = trace.endPos
    }
#endif

	PlayerUsedOffhand( player, weapon )
	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire )
}

#if CLIENT
void function CreateARIndicator( entity player )
{
	vector eyePos = player.EyePosition()
	vector viewVector = player.GetViewVector()
	TraceResults trace = TraceLine( eyePos, eyePos + (viewVector * 5000.0), player, TRACE_MASK_SOLID_BRUSHONLY, TRACE_COLLISION_GROUP_NONE )
	print(trace.fraction)
	if ( trace.fraction < 1.0 )
	{
		trace = TraceLine( trace.endPos, trace.endPos + <0,0,-2000 * trace.fraction >, player, TRACE_MASK_SOLID_BRUSHONLY, TRACE_COLLISION_GROUP_NONE )
		int arID = GetParticleSystemIndex( $"P_ar_ping_squad_CP" )
		int fxHandle = StartParticleEffectInWorldWithHandle( arID, trace.endPos, trace.surfaceNormal )
		print(trace.endPos)
        BS_WARP_POS = trace.endPos
		EffectSetControlPointVector( fxHandle, 1, FRIENDLY_COLOR_FX )
		thread DestroyAfterTime( fxHandle, 1.0 )
	}
}

void function DestroyAfterTime( int fxHandle, float time )
{
	OnThreadEnd(
		function() : ( fxHandle )
		{
			if ( !EffectDoesExist( fxHandle ) )
				return

			EffectStop( fxHandle, true, true )
		}
	)
	wait( time )
}
#endif
