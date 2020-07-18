state("SCP - Containment Breach", "v1.3.9")
{
	byte mainmenu : "SCP - Containment Breach.exe", 0x000F5400, 0x128, 0x450;
	byte loadingscreentext : "SCP - Containment Breach.exe", 0x000F5400, 0x538, 0x4E0;
	byte onaloadingscreen : "SCP - Containment Breach.exe" , 0x000F5400, 0x84, 0x588;
    byte totalachievements : "SCP - Containment Breach.exe", 0x000F5400, 0x84, 0x540;
    byte a2event : "SCP - Containment Breach.exe", 0x000FE188, 0xC, 0xB60, 0xF34;
    byte gateloadingscreen : "SCP - Containment Breach.exe", 0x000F5E84, 0x18;
	float blink : "SCP - Containment Breach.exe", 0x000F5400, 0x5D4, 0x734;
	float sprint : "SCP - Containment Breach.exe", 0x000F5400, 0x84, 0x380;
	float xaxis : "SCP - Containment Breach.exe", 0xF5E54;
	float zaxis : "SCP - Containment Breach.exe", 0xF5E5C;
	float yaxis : "SCP - Containment Breach.exe", 0x000F5400, 0x14C, 0x154, 0xC, 0x4, 0x19C;
    float deathTimer : "SCP - Containment Breach.exe", 0x000F5400, 0x84, 0x344;
    float scp106state : "SCP - Containment Breach.exe", 0x000F64C0, 0x24, 0x18, 0x20, 0x10C, 0x3E0, 0x0, 0x38;
}

startup
{
settings.Add("1.3.9", true, "1.3.9");
settings.Add("100%", true, "100% Achievement Run", "1.3.9");
settings.SetToolTip("100%", "It will automatically split when you start, after evey achievement you unlock, and when you beat the game.\n Will not split on B2 ending.");
}

init
{
	if (modules.First().ModuleMemorySize == 6221824)
        version = "v1.3.9";
	int split;
	vars.split = 0;
}

start
{
	if (settings["100%"] == true && (current.onaloadingscreen != 0 | current.onaloadingscreen == 0))
		if (old.blink < -9.99999999 && (current.blink > 1 || current.blink <= -10.00000001) && current.zaxis > 130) {
			vars.split = 1;
			return true;
		}

}

split
{
	if (settings["100%"] == true)
	{
        if ((current.totalachievements != old.totalachievements)) {
			vars.split++;
			return true;
		}
        if((current.totalachievements >= 34 && vars.split == 35 && current.sprint == -5) | (current.totalachievements >= 34 && current.a2event == 1) | (current.totalachievements >= 34 && current.yaxis < 42.0781 && current.yaxis > 42))
        {
            vars.split++;
            return true;
        }
    }
}

isLoading
{
	if (settings["1.3.9"] == true)
	{
		if ((current.yaxis > 42 && current.yaxis < 44 && current.gateloadingscreen == 50) || (current.yaxis > 48 && current.yaxis < 49 && current.gateloadingscreen == 50) || (current.yaxis > 1 && current.yaxis < 2 && current.gateloadingscreen == 50 && current.loadingscreentext == 0))
			return true;

			return false;
	}
}

reset
{
	if (settings["1.3.9"] == true)
	{
		if(current.mainmenu == 0)
		{
			vars.split = 0;
			return true;
		}
	}
}
