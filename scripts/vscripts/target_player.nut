// Made for func_tank and point_futbol_shooter, but should be easily expandable

isTargetingClosestPlayer <- false;
lastTargetedPlayer <- "";

function CalculateClosestPlayer()
{
    local bluePlayerHandle = Entities.FindByName(null, "!player_blue");
    local orangePlayerHandle = Entities.FindByName(null, "!player_orange");

    // If blue closer than orange, return blue
    if ((self.GetOrigin() - bluePlayerHandle.GetOrigin()).Length() < (self.GetOrigin() - orangePlayerHandle.GetOrigin()).Length())
        return "!player_blue";
    else
        return "!player_orange";
}

// Targets the currently closest player (doesn't retarget if the closest player changes)
function TargetClosestPlayer()
{
    local closestPlayer = CalculateClosestPlayer();
    // I'm guessing that most classes with targeting will have a "SetTarget" input,
    // so func_tank gets a special check
    if (self.GetClassname() == "func_tank")
    {
        EntFire("!self", "SetTargetEntity", closestPlayer, 0, null);
    }
    else
    {
        EntFire("!self", "SetTarget", closestPlayer, 0, null);
    }
}

// Sets a flag so TargetThink can start looking for the closest player
function StartTargetingClosestPlayer()
{
    if ( GetDeveloperLevel() >= 1 )
    {
        printl(self + " is now targeting the closest player");
    }
    isTargetingClosestPlayer = true;
}

function ClearTargets()
{
    if ( GetDeveloperLevel() >= 1 )
    {
        printl(self + " is not targeting anything anymore");
    }
    isTargetingClosestPlayer = false;
    lastTargetedPlayer = "";
    EntFire("!self", "ClearTargetEntity", "", 0, null);
}

function TargetThink()
{
    if (isTargetingClosestPlayer)
    {
        local closestPlayer = CalculateClosestPlayer();
        if (closestPlayer != lastTargetedPlayer)
        {
            lastTargetedPlayer = closestPlayer;
            EntFire("!self", "SetTargetEntity", closestPlayer, 0, null);
        }
    }
}
