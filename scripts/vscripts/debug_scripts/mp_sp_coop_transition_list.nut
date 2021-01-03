//--------------------------------------------------------------------------------
//====================== CUSTOM COOP TRANSITION SCRIPT ===========================
//========================== MADE BY CHICKENMOBILE ===============================
//--------------------------------------------------------------------------------
//PLEASE REFER TO THE README FILE INCLUDED WITH DOWNLOAD FOR ANY EXTRA INFORMATION
//           OR LOOK AT THE COMMENTS TO KNOW WHERE TO PLACE EXTRA CODE
// REMEMBER TO REMOVE ANY COMMENTS '//' IN FRONT OF LINES TO MAKE THE CODE ACTIVE
//--------------------------------------------------------------------------------

//================== CONSTANTS ( EDIT THESE ) =====================
//-----------------------------------------------------------------

// Turn Debug on (1) or off (0)
DBG <- 0

// Set to false if you don't want text to appear showing the name of the current chosen level on the chooser
textPreview <- true

// The name of the Hub map. This the map it will transition to when all maps are finished in the current course.
// The hubmap will be ignored if tried to transition to if it is in MapPlayOrder[]
HUB_MAP <- "mp_coop_start"

//--------------------------------------------------------------------------------
// Create new START and END maps to calculate a new level chooser for another course.
// For eg. "map1ex" is the start level and "map3ex" is the end level of the first course.
//--------------------------------------------------------------------------------
START_MAP <- [ 
"mp_coop_a1_intro1", //Course 1 StartMap
"mp_coop_a2_laser_intro", //Course 2 StartMap
"mp_coop_a2_sphere_peek",
"mp_coop_a2_column_blocker",
"mp_coop_a2_bts3",
"mp_coop_a3_01",
"mp_coop_a3_speed_ramp",
"mp_coop_a4_intro",
"mp_coop_a4_finale1",
]

END_MAP <- [ 
"mp_coop_a2_intro", //Course 1 EndMap
"mp_coop_a2_fizzler_intro", //Course 2 EndMap
"mp_coop_a2_pull_the_rug",
"mp_coop_a2_bts2",
"mp_coop_a2_core",
"mp_coop_a3_transition01",
"mp_coop_a3_end",
"mp_coop_a4_jump_polarity",
"mp_coop_a4_finale4",
]

//============================= MapPlayOrder[] ===================================
// This is the order to play the maps. 
// Add any extra courses as a new START and END level in the arrays above.
// Note: both the start map and endmap need to appear in mapplayorder
//--------------------------------------------------------------------------------
MapPlayOrder<- [

//Course 1
"mp_coop_a1_intro1",
"mp_coop_a1_intro2",
"mp_coop_a1_intro3",
"mp_coop_a1_intro4",
"mp_coop_a1_intro5",
"mp_coop_a1_intro6",
"mp_coop_a1_intro7",
"mp_coop_a1_wakeup",
"mp_coop_a2_intro",

//Course 2
"mp_coop_a2_laser_intro",
"mp_coop_a2_laser_stairs",
"mp_coop_a2_dual_lasers",
"mp_coop_a2_laser_over_goo",
"mp_coop_a2_catapult_intro",
"mp_coop_a2_trust_fling",
"mp_coop_a2_pit_flings",
"mp_coop_a2_fizzler_intro",

//Course 3
"mp_coop_a2_sphere_peek",
"mp_coop_a2_ricochet",
"mp_coop_a2_bridge_intro",
"mp_coop_a2_bridge_the_gap",
"mp_coop_a2_turret_intro",
"mp_coop_a2_laser_relays",
"mp_coop_a2_turret_blocker",
"mp_coop_a2_laser_vs_turret",
"mp_coop_a2_pull_the_rug",

//Course 4
"mp_coop_a2_column_blocker",
"mp_coop_a2_laser_chaining",
"mp_coop_a2_triple_laser",
"mp_coop_a2_bts1",
"mp_coop_a2_bts2",

//Course 5
"mp_coop_a2_bts3",
"mp_coop_a2_bts4",
"mp_coop_a2_bts5",
"mp_coop_a2_core",

//Course 6
"mp_coop_a3_01",
"mp_coop_a3_03",
"mp_coop_a3_jump_intro",
"mp_coop_a3_bomb_flings",
"mp_coop_a3_crazy_box",
"mp_coop_a3_transition01",

//Course 7
"mp_coop_a3_speed_ramp",
"mp_coop_a3_speed_flings",
"mp_coop_a3_portal_intro",
"mp_coop_a3_end",

//Course 8
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

//Course 9
"mp_coop_a4_finale1",
"mp_coop_a4_finale2",
"mp_coop_a4_finale3",
"mp_coop_a4_finale4",
]

//============================= CHAPTER_TITLES ===================================
// This is the array that holds the titles. Add a new Chapter title by copying and
// pasting a new entry if another chapter exists within another map in the transition. 
// Ignore this if you don't want names of chapters to appear
//--------------------------------------------------------------------------------
CHAPTER_TITLES <- 
[
	//{ map = "mp_coop_map2ex", title_text = "CHAPTER NUMBER", subtitle_text = "CHAPTER NAME", displayOnSpawn = true, displaydelay = 1.0 },
	//{ map = START_MAP[1], title_text = "CHAPTER 2", subtitle_text = "EXAMPLE CHAPTER NAME", displayOnSpawn = false, displaydelay = 2.0 },
]

//================= CONSTANTS AND FUNCTIONS =======================
//============= DO NOT EDIT ANY CODE BELOW HERE ===================
//-----------------------------------------------------------------
nLevels <- 0
nCurrentLevel <- 1
units <- 1
tens <- 0
lastunits <- 0
lasttens <- 0
sNextLevel <- "none"
courseStartIndex <- 0
courseEndIndex <- 0

//======================== TRANSITIONS ============================
//-----------------------------------------------------------------

//called when level finished and next map is to be played
function TransitionFromMap()
{
	local lastmap = false
	
	foreach( index, map in END_MAP )
	{
		if ( END_MAP[index] == GetMapName() ) { lastmap = true }
	}
	foreach( index, map in MapPlayOrder )
	{
		if ( MapPlayOrder[index] == GetMapName() )
		{
			if ( lastmap ) { EntFire( "@command", "command", "changelevel " + HUB_MAP, 0 ) }
			else { 
				sNextLevel = MapPlayOrder[index + 1]
      				EntFire( "@command", "command", "changelevel " + sNextLevel, 0 ) 
      			}
			return
		}
	}
	printl ( "Current map is not in list or has no map following!" )
}

//Called when disassembled from hub
function TransitionFromHub()
{
	EntFire( "@command", "command", "changelevel " + sNextLevel, 0 )
}

//Call this when both bots are in disassemblers so right course and level is transitioned
function setActiveCourse( nCourse )
{
	nLevels = NumberOfLevels( nCourse )
	sNextLevel = FindCurrentLevel( nCurrentLevel )
	if( DBG ) printl( "Changing course to: " + nCourse + " Level: " + nCurrentLevel + " out of: " + nLevels + ". Map: " + sNextLevel )
}

//==================== LEVEL CHOOSER LOGIC ========================
//===================== GENERAL FUNCTIONS =========================
//-----------------------------------------------------------------
//sets the number of maps for the current course from the array
//also use this to prepare constants for the level chosen by the level choosers.
function NumberOfLevels( nCourse )
{
	local counter = 0
	local nCourseCompare = nCourse - 1
	local levelIndex = 0
	local nCurrent = 0

	foreach( index, map in MapPlayOrder )
	{
		//if( DBG ){ printl( "Loop number: " + index + " Current Map: " + MapPlayOrder[index] ) }

		if ( MapPlayOrder[index] == START_MAP[nCurrent] )
		{
			//if( DBG ){ printl ( nCurrent ) }
			if ( nCurrent == nCourseCompare )
			{
				courseStartIndex = index
				levelIndex = index
				while( levelIndex <= ArrayLength() && MapPlayOrder[levelIndex] != END_MAP[nCourseCompare] )
				{
					if ( CheckHubMap(levelIndex) ) { counter++ }
					levelIndex++
				}
				//adds 1 as the loop has exited before adding the final map
				courseEndIndex = levelIndex
				counter++

				//if( DBG ){ printl ( "Course: " + nCourse +" Levels: " + counter + ". LastMap: " + MapPlayOrder[courseEndIndex] + " index: " + courseEndIndex + ". FirstMap: " + MapPlayOrder[courseStartIndex] + " index: " + courseStartIndex ) }
				return counter
			}
			nCurrent++ 
		}
	}
	printl ( "Could not find any courses! Make sure the START_MAP and END_MAP is inside both their arrays and the MapPlayOrder[] Array!" )
	return 0
}
//Setup of Fake Vgui and buttons on startup
function InitButtons( nCourse )
{	
	if( DBG ){ printl ( "========================== Course " + nCourse + " =======================" ) }
	nLevels = NumberOfLevels( nCourse )
	if( DBG ){ printl ( "Course: " + nCourse + " Levels: " + nLevels ) }
	UpdateButtons()
	SetLengthOfSlider()
}

//Returns false if map in transition is the hub
function CheckHubMap( nMap ) {
	if ( MapPlayOrder[nMap] == HUB_MAP ) { return false }
	else { return true }
}

//gets the current courses' number based off the instance
Course1 <- 1;
function AddCourse1(){Course1++}
function SubtractCourse1(){Course1--}
function getCourse() {return Course1;}

function dumpLevel() { printl ( GetMapName() ) }

//Finds length of MapPlayOrder[] array (total maps in transition)
function ArrayLength() 
{
	local total = 0
	foreach( index, map in MapPlayOrder ) { total++ }
	return total
}
//returns the current chosen map's name
function FindCurrentLevel( nCurrentLevel )
{
	local j = 0
	nLevels = NumberOfLevels( getCourse() )
	if(DBG){ printl( getCourse() ) }

	if ( nCurrentLevel < 1 ) 
	{ 
		if( DBG ) { printl( "#" + nCurrentLevel + " Chooser on first: " + MapPlayOrder[courseStartIndex] ) } 
		return MapPlayOrder[courseStartIndex] 
	}
	if ( nCurrentLevel >= ArrayLength() ) 
	{ 
		if( DBG ) { printl( "#" + nCurrentLevel + " Chooser on last: " + MapPlayOrder[courseEndIndex] ) }
		return MapPlayOrder[courseEndIndex] 
	}

	foreach( index, map in MapPlayOrder )
	{
		if ( MapPlayOrder[index] == MapPlayOrder[courseStartIndex] )
		{
			j = index

			//we need this as we dont want to ovveride the world variable nCurrentLevel
			local tempCurrentLevel = nCurrentLevel + index
			
			//Finds the appropriate level from MapPlayOrder[] from chooser
			while ( j < ArrayLength() && MapPlayOrder[j] != MapPlayOrder[courseEndIndex] )
			{
				if ( !CheckHubMap(j) ) 
				{ 
					j++ 
					printl("Skipping Hub Map...") 
				}
				else if( j == tempCurrentLevel - 1 ) 
				{ 
					if( DBG ){ printl( "#" + nCurrentLevel + " map on chooser is: " + MapPlayOrder[j] ) }
					return MapPlayOrder[j]
				}
				j++
			}

			if ( MapPlayOrder[j] == MapPlayOrder[courseEndIndex] ) 
			{ 
				if( DBG ){ printl( "#" + nCurrentLevel + " Chooser on 2last: " + MapPlayOrder[courseEndIndex] ) }
				return MapPlayOrder[courseEndIndex] 
			}
		}
	}
	printl ( "== Current map is not in list! ==" )	
}

//==================== LEVEL CHOOSER LOGIC ========================
//======================== VGUI SCREEN ============================
//-----------------------------------------------------------------
//Pressing the Right Button
function AddLevel( nCourse )
{
	if ( DBG ) { printl("=================================== Add Button ============================") }
	nLevels = NumberOfLevels( nCourse )
	local nNewLevel = nCurrentLevel + 1
	if ( nNewLevel > nLevels ){ return }
	else { nCurrentLevel++ }
	
	sNextLevel = FindCurrentLevel( nCurrentLevel )
	lasttens = tens
	lastunits = units
	units++

	MoveSlider( nCurrentLevel )
	UpdateCounter()
	UpdateButtons()
	if( textPreview ){ DisplayLevelTitle() }
}

//Pressing the Left button
function SubtractLevel( nCourse )
{
	if ( DBG ) { printl("============================== Subtract Button ===========================") }
	nLevels = NumberOfLevels( nCourse )
	local nNewLevel = nCurrentLevel - 1
	if ( nNewLevel < 1 ){ return }
	else { nCurrentLevel-- }

	sNextLevel = FindCurrentLevel( nCurrentLevel )
	lasttens = tens
	lastunits = units
	units--

	MoveSlider( nCurrentLevel )
	UpdateCounter()
	UpdateButtons()
	if( textPreview ){ DisplayLevelTitle() }
}

function DisplayLevelTitle()
{
	EntFire( EntityGroup[6].GetName(), "setText", FindCurrentLevel(nCurrentLevel), 0 )
	EntFire( EntityGroup[6].GetName(), "Display", "", 0.1 )
}

//moves the slider based off the current number and how many maps there are
function MoveSlider( nDistance )
{
	local nSections = 1.0
	nSections = nSections / ( nLevels - 1 )
	local nMovePercentage = ( nSections * nDistance ) - nSections

	//for some reason the input cannot be a 0 from the script.
	if ( nMovePercentage <= 0 ){ nMovePercentage = 0.0001 }

	if( DBG ){ printl ( "nDistance: " + nDistance + ", nMovePercentage: " + nMovePercentage + ", nSections: " + nSections ) }
	EntFire( EntityGroup[2].GetName(), "SetPosition", nMovePercentage, 0 )
}

//Displays Numbers of current course chosen
function UpdateCounter()
{
	if ( units > 9 ) {
		tens++
		units = 0
	}
	if ( units < 0 ) {
		tens--
		units = 9
	}
	if ( tens > 9 || tens < 0 ) { tens = 0 }
	if ( tens == lasttens ) { lasttens = 9 }

	//Enables and disables the correct level numbers
	EntFire( EntityGroup[3].GetName() + "" + tens, "Enable", "", 0 )
	EntFire( EntityGroup[3].GetName() + "" + lasttens, "Disable", "", 0 )
	EntFire( EntityGroup[4].GetName() + "" + units, "Enable", "", 0 )
	EntFire( EntityGroup[4].GetName() + "" + lastunits, "Disable", "", 0 )
}

//Decides what length to set the slider depending on how many levels are in course. More courses will make the slider smaller.
function SetLengthOfSlider()
{
	local nSlider = 0
	if ( nLevels == 1) { nSlider = 1 }
	if ( nLevels == 2) { nSlider = 2 }
	if ( nLevels == 3) { nSlider = 3 }
	if ( nLevels == 4) { nSlider = 4 }
	if ( nLevels == 5 || nLevels == 6 ) { nSlider = 5 }
	if ( nLevels >= 7 && nLevels <= 9 ) { nSlider = 6 }
	if ( nLevels >= 10 && nLevels <= 13 ) { nSlider = 7 }
	if ( nLevels >= 14 && nLevels <= 20 ) { nSlider = 8 }
	if ( nLevels >= 21 ) { nSlider = 9 }

	if( DBG ){ printl ( "Slider # is: " + nSlider ) }

	for ( local j = 0; j < 10; j++ )
	{
		if( j == nSlider )
		{
			EntFire( EntityGroup[2].GetName() + nSlider, "addoutput", "targetname " + EntityGroup[2].GetName(), 0)
			EntFire( EntityGroup[2].GetName() + nSlider, "addoutput", "classname " + EntityGroup[2].GetName(), 0)
		} 
		//removes every other slider except the wanted one when the loop is irated
		EntFire( EntityGroup[2].GetName() + j, "Kill", "", 0)
	}
}

//Sets if the buttons are red or dull depending if the last or first map is currently chosen.
function UpdateButtons()
{
	if ( nCurrentLevel <= 1 ) {
		// turn off the left light
		EntFire( EntityGroup[0].GetName(), "Skin", "1", 0)
	}
	else {
		// turn on the left light
		EntFire( EntityGroup[0].GetName(), "Skin", "0", 0)
	}
	if ( nCurrentLevel >= nLevels ) {
		// turn off the right light
		EntFire( EntityGroup[1].GetName(), "Skin", "1", 0)
	}
	else {
		// turn on the right light
		EntFire( EntityGroup[1].GetName(), "Skin", "0", 0)
	}
}
//=================== CHAPTER TITLE DISPLAY =======================
//-----------------------------------------------------------------
// Display the chapter title
function DisplayChapterTitle()
{
	foreach (index, level in CHAPTER_TITLES)
	{
		if (level.map == GetMapName() )
		{
			EntFire( "@chapter_title_text", "SetTextColor", "210 210 210 128", 0.0 )
			EntFire( "@chapter_title_text", "SetTextColor2", "50 90 116 128", 0.0 )
			EntFire( "@chapter_title_text", "SetPosY", "0.32", 0.0 )
			EntFire( "@chapter_title_text", "SetText", level.title_text, 0.0 )
			EntFire( "@chapter_title_text", "display", "", level.displaydelay )
			
			EntFire( "@chapter_subtitle_text", "SetTextColor", "210 210 210 128", 0.0 )
			EntFire( "@chapter_subtitle_text", "SetTextColor2", "50 90 116 128", 0.0 )
			EntFire( "@chapter_subtitle_text", "SetPosY", "0.35", 0.0 )
			EntFire( "@chapter_subtitle_text", "settext", level.subtitle_text, 0.0 )
			EntFire( "@chapter_subtitle_text", "display", "", level.displaydelay )
		}
	}
}

// Display the chapter title on spawn if it is flagged to show up on spawn
function TryDisplayChapterTitle()
{
	foreach (index, level in CHAPTER_TITLES)
	{
		if (level.map == GetMapName() && level.displayOnSpawn )
		{
			DisplayChapterTitle()
		}	
	}
}