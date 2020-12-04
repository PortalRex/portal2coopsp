playerPortals <- {}
playerPortals["blue"] <- []
playerPortals["red"] <- []
preregisteredPortals <- []

function SinglePortalGunGrabBlue()
{
    SinglePortalGunGrab("!player_blue")
}

function SinglePortalGunGrabOrange()
{
    SinglePortalGunGrab("!player_orange")
}

// desiredPlayer has to be either "!player_blue" or "!player_orange"
// The relays that get ent_fire'd must either call LinkSinglePortalGuns or UpgradePortalGuns
function SinglePortalGunGrab(desiredPlayer)
{
    if (CheckIfActivatorIsDesiredPlayer(desiredPlayer))
    {
        EntFire("!self", "Use", "", 0, activator);
        // Trigger the correct relay according to the player
        if (desiredPlayer == "!player_blue")
        {
            EntFire("pickup_portalgun_blue_rl", "Trigger", "", 0);
        }
        else
        {
            EntFire("pickup_portalgun_orange_rl", "Trigger", "", 0);
        }
    }
}

// Check if whoever activated the script is the player we want
function CheckIfActivatorIsDesiredPlayer(desiredPlayer)
{
    local desiredPlayerHandle = Entities.FindByName(null, desiredPlayer)
    if ( GetDeveloperLevel() >= 1 )
	{
        printl("caller: " + caller);
		printl("activator: " + activator);

        printl("desiredPlayer: " + desiredPlayer);
        printl("desiredPlayerHandle :" + desiredPlayerHandle);

        printl("activator == desiredPlayer: " + (activator == desiredPlayerHandle));
	}

    return (activator == desiredPlayerHandle);
}

// Link players' portalguns together
// Should be called everytime a player spawns
function LinkSinglePortalGuns()
{
    local bluePlayerHandle = Entities.FindByName(null, "!player_blue");
    local orangePlayerHandle = Entities.FindByName(null, "!player_orange");

    if ( GetDeveloperLevel() >= 1 )
	{
        printl("Linking portal guns..");
    }

    // Set Orange's gun to set the 2nd portal
    local portalgun = null;
    while (portalgun = Entities.FindByClassname(portalgun, "weapon_portalgun"))
    {
        if ( GetDeveloperLevel() >= 1 )
	    {
            printl("Found " + portalgun + " held by " + portalgun.GetMoveParent());
        }
        if (portalgun.GetMoveParent() == orangePlayerHandle)
        {
            if ( GetDeveloperLevel() >= 1 )
            {
                printl(portalgun + " set to only fire 2nd portal");
            }
            portalgun.__KeyValueFromInt("CanFirePortal1", 0);
            portalgun.__KeyValueFromInt("CanFirePortal2", 1);
        }
    }

    // Add output to new portals so they set themselves to the correct linkage when being placed
    local portal = null;
    if ( GetDeveloperLevel() >= 1 )
    {
        printl("Linking new portals..");
    }
    while (portal = Entities.FindByClassname(portal, "prop_portal"))
    {
        if (!CheckIfPortalIsPregistered(portal) && !CheckIfPortalIsRegistered(portal))
        {
            if ( GetDeveloperLevel() >= 1 )
	        {
                printl("Adding output to " + portal);
            }
            preregisteredPortals.push(portal);
            EntFireByHandle(portal, "AddOutput", "OnPlacedSuccessfully "+self.GetName()+":RunScriptCode:SetPortalToCorrectLinkage():0:-1", 0, null, null);
        }
    }
}

// For some reason "portal in preregisteredPortals" doesn't return true
// This function iterates through the array manually
function CheckIfPortalIsPregistered(portal)
{
    if ( GetDeveloperLevel() >= 1 )
    {
        printl("Looking for " + portal + " in preregistered portals..");
    }
    foreach (preregisteredPortal in preregisteredPortals)
    {
        if (portal == preregisteredPortal)
        {
            if ( GetDeveloperLevel() >= 1 )
            {
                printl(portal + " found in preregistered portals!");
            }
            return true;
        }
    }
    if ( GetDeveloperLevel() >= 1 )
    {
        printl(portal + " not found in preregistered portals");
    }
    return false;
}

// Check if the portal has been shot and assigned to a player
function CheckIfPortalIsRegistered(portal)
{
    if ( GetDeveloperLevel() >= 1 )
    {
        printl("Looking for " + portal + " in registered portals..");
    }
    local foundPortal = false;
    foreach (portalArray in playerPortals)
    {
        foreach (playerPortal in portalArray)
        {
            if (playerPortal == portal)
            {
                if ( GetDeveloperLevel() >= 1 )
                {
                    printl(portal + " found in registered portals!");
                }
                return true;
            }
        }
    }
    if ( GetDeveloperLevel() >= 1 )
    {
        printl(portal + " not found in registered portals");
    }
    return false;
}

// Function to be called by a prop_portal to correct it's linkage ID and register itself as being owned by a player
// Expected caller is the portal and expected activator is the player's portal gun
function SetPortalToCorrectLinkage()
{
    if (CheckIfPortalIsPregistered(caller))
    {
        if ( GetDeveloperLevel() >= 1 )
        {
            printl("New portal just got placed. Setting LinkageGroupID to 3 and registering owner as " + activator.GetMoveParent());
        }
        playerPortals[activator.GetMoveParent().GetName()].push(caller);
        // array.remove only takes indexes and array.find doesn't exist lol. Doing it manually then
        foreach (index, portal in preregisteredPortals)
        {
            if (portal == caller)
            {
                preregisteredPortals.remove(index);
                break;
            }
        }
        EntFireByHandle(caller, "SetLinkageGroupID", "3", 0, null, null);
    }
}

// Fizzles the activator's registered portals
function FizzlePlayerPortals()
{
    if ( GetDeveloperLevel() >= 1 )
    {
        printl(activator + " just died. Fizzling it's portals..");
    }
    local deadPlayerPortals = playerPortals[activator.GetName()];
    foreach (portal in deadPlayerPortals)
    {
        if ( GetDeveloperLevel() >= 1 )
        {
            printl("Fizzling portal " + portal);
        }
        EntFireByHandle(portal, "Fizzle", "", 0, null, null);
        EntFireByHandle(portal, "Kill", "", 0.1, null, null);
    }
    while (deadPlayerPortals.len() > 0)
    {
        deadPlayerPortals.remove(0);
    } 
}

// This function assumes the guns aren't linked
function UpgradePortalGuns()
{
    local portalgun = null;
    while (portalgun = Entities.FindByClassname(portalgun, "weapon_portalgun"))
    {
        if ( GetDeveloperLevel() >= 1 )
	    {
            printl("Found " + portalgun + " held by " + portalgun.GetMoveParent());
        }
        portalgun.__KeyValueFromInt("CanFirePortal2", 1);
    }
}