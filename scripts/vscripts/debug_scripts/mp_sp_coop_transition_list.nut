// Map order
MapPlayOrder<- [
"mp_coop_start",
"mp_coop_lobby_3",
"mp_coop_a1_intro2",
"mp_coop_a1_intro3",
"mp_coop_a1_intro4",
"mp_coop_a1_intro5",
"mp_coop_a1_intro6",
"mp_coop_a1_intro7",
"mp_coop_a1_wakeup",
"mp_coop_a2_intro",
"mp_coop_a2_laser_intro",
"mp_coop_a2_laser_stairs",
"mp_coop_a2_dual_lasers",
"mp_coop_a2_laser_over_goo",
"mp_coop_a2_catapult_intro",
"mp_coop_a2_trust_fling",
"mp_coop_a2_pit_flings",
"mp_coop_a2_fizzler_intro",
"mp_coop_a2_sphere_peek",
"mp_coop_a2_ricochet",
"mp_coop_a2_bridge_intro",
"mp_coop_a2_bridge_the_gap",
"mp_coop_a2_turret_intro",
"mp_coop_a2_laser_relays",
"mp_coop_a2_turret_blocker",
"mp_coop_a2_laser_vs_turret",
"mp_coop_a2_pull_the_rug",
"mp_coop_a2_column_blocker",
"mp_coop_a2_laser_chaining",
"mp_coop_a2_triple_laser",
"mp_coop_a2_bts1",
"mp_coop_a2_bts2",
"mp_coop_a2_bts3",
"mp_coop_a2_bts4",
"mp_coop_a2_bts5",
"mp_coop_a2_core",
"mp_coop_a3_01",
"mp_coop_a3_03",
"mp_coop_a3_jump_intro",
"mp_coop_a3_bomb_flings",
"mp_coop_a3_crazy_box",
"mp_coop_a3_transition01",
"mp_coop_a3_speed_ramp",
"mp_coop_a3_speed_flings",
"mp_coop_a3_portal_intro",
"mp_coop_a3_end",
"mp_coop_a4_intro",
"mp_coop_a4_tb_intro",
"mp_coop_a4_tb_trust_drop",
"mp_coop_a4_tb_wall_button",
"mp_coop_a4_tb_polarity",
"mp_coop_a4_tb_catch",
"mp_coop_a4_stop_the_box",
"mp_coop_a4_laser_catapult",
"mp_coop_a4_laser_platform",
"mp_coop_a4_speed_tb_catch"
"mp_coop_a4_jump_polarity",
"mp_coop_a4_finale1",
"mp_coop_a4_finale2",
"mp_coop_a4_finale3",
"mp_coop_a4_finale4"
]

function TransitionFromMap()
{	
	local nextmap = -2
	
	// Loop through maps
	foreach( index, map in MapPlayOrder )
	{
		if( GetMapName() == MapPlayOrder[index] )
		{
			// This is the map we're on
			nextmap = -1
		}
		else 
		{
			if (nextmap == -1)
			{
				// This is the first map past that one
				nextmap = index
			}
		}
	}
	
	if(GetMapName() == "mp_coop_start")
	{
		nextmap = 2;
	}
		
	printl( "nextmap = " + nextmap )
		
	if (nextmap > 0)
	{
		// We found a map; go to it
		EntFire( "@command", "command", "changelevel " + MapPlayOrder[nextmap], 1.0 )
	}
	else
	{
		// No map found; we're done
		EntFire( "@command", "command", "disconnect", 2.0 )
	}
}