//oh boy here we go
state("SCP - Containment Breach", "v1.3.11")
{
	byte mainmenu : "SCP - Containment Breach.exe", 0x000F5400, 0x120, 0x458;
	float blink : "SCP - Containment Breach.exe", 0x000F5400, 0x498, 0x7CC;
	float zaxis : "SCP - Containment Breach.exe", 0x000F5400, 0x160, 0x140, 0x48;
	float deathTimer : "SCP - Containment Breach.exe", 0x000F5400, 0x98, 0x358;
}
state("SCP - Containment Breach", "v1.3.10")
{
    byte mainmenu : "SCP - Containment Breach.exe", 0xF5400, 0x98, 0x1574;
    float blink : "SCP - Containment Breach.exe", 0x000F5400, 0x98, 0x360;
    float zaxis : "SCP - Containment Breach.exe", 0x000F5400, 0x160, 0x140, 0x48;
    float deathTimer : "SCP - Containment Breach.exe", 0x000F5400, 0x98, 0x338;
}

state("SCP - Containment Breach", "v1.3.9")
{
    byte mainmenu : "SCP - Containment Breach.exe", 0x000F5400, 0x128, 0x450;
    float blink : "SCP - Containment Breach.exe", 0x000F5400, 0x5D4, 0x734;
    float zaxis : "SCP - Containment Breach.exe", 0xF5E5C;
    float deathTimer : "SCP - Containment Breach.exe", 0x000F5400, 0x84, 0x344;
}

state("SCP - Containment Breach", "v1.3.8")
{
    byte mainmenu : "SCP - Containment Breach.exe", 0x000F5400, 0x84, 0x1DC0;
    float blink : "SCP - Containment Breach.exe", 0x000F5400, 0x84, 0x364;
    float zaxis : "SCP - Containment Breach.exe", 0x000F5400, 0x14C, 0x154, 0xC, 0x4, 0x1A0;
    float deathTimer : "SCP - Containment Breach.exe", 0x000F5400, 0x84, 0x33C;
}

state("SCP - Containment Breach", "v1.3.7")
{
    byte mainmenu : "SCP - Containment Breach.exe", 0x000F5400, 0x84, 0x1DC4;
    float blink : "SCP - Containment Breach.exe", 0x000F5400, 0x84, 0x364;
    float zaxis : "SCP - Containment Breach.exe", 0x000F5400, 0x14C, 0x154, 0xC, 0x4, 0x1A0;
    float deathTimer : "SCP - Containment Breach.exe", 0x000F5400, 0x84, 0x33C;
}

startup
{
    settings.Add("death%", true, "Death%");
    settings.SetToolTip("death%", "Will automatically start the timer and stop when you die.\nCurrently works on versions:\n-1.3.11\n-1.3.10\n-1.3.9\n-1.3.8\n-1.3.7\n");
}

init
{
    //print(Convert.ToString(modules.First().ModuleMemorySize));
    if (modules.First().ModuleMemorySize == 6537216)
        version = "v1.3.11";
    else if (modules.First().ModuleMemorySize == 6500352)
        version = "v1.3.10";
    else if (modules.First().ModuleMemorySize == 6221824)
        version = "v1.3.9";
    else if (modules.First().ModuleMemorySize == 6164480)
        version = "v1.3.8";
    else if (modules.First().ModuleMemorySize == 6123520)
        version = "v1.3.7";

    bool isDead;
    vars.isDead = false;
}

start
{
    if (settings["death%"] == true)
    {
        if (old.blink < -9.99999999 && (current.blink > 1 || current.blink <= -10.00000001) && current.zaxis > 130)
        {
			return true;
	}
    }
}

split
{
    if (settings["death%"] == true)
        if (current.deathTimer != 0.0 && vars.isDead == false)
        {
            vars.isDead = true;
            return true;
        }
}

isLoading
{
    //for whatever dumbfuck reason, livesplit refuses to split correctly if this function isnt here
    //i dont need the function but fuck you
    return false;
}

reset
{
	vars.isDead = false;
    return (current.mainmenu == 0 && settings["death%"]) ? true : false;
}
