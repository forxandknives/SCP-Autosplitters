state("SCP - Containment Breach", "v1.3.11")
{
	byte mainmenu : "SCP - Containment Breach.exe", 0x000F5400, 0x120, 0x458;
	byte onaloadingscreen : "SCP - Containment Breach.exe", 0x000F5400, 0x98, 0x598;
	byte a2event : "SCP - Containment Breach.exe", 0x000F5400, 0x98, 0x1490;
	byte gateBloadigscreen : "SCP - Containment Breach.exe", 0x000f5400, 0x98, 0xd68;
	byte gateBloadigscreen2 : "SCP - Containment Breach.exe", 0x000f5400, 0x98, 0xd64;
	byte paused : "SCP - Containment Breach.exe", 0x000f5400, 0x98, 0x5dc;
	byte keypresses : "SCP - Containment Breach.exe", 0x000f5f70, 0x604;
	byte inventory : "SCP - Containment Breach.exe", 0x000f5400, 0x98, 0x5E4;
	float blink : "SCP - Containment Breach.exe", 0x000F5400, 0x498, 0x7CC;
	float sprint : "SCP - Containment Breach.exe", 0x000F5400, 0x680, 0x77C;
	float xaxis : "SCP - Containment Breach.exe", 0x000F5400, 0x160, 0x140, 0x40;
	float yaxis : "SCP - Containment Breach.exe", 0x000F5400, 0x160, 0x140, 0x44;
	float zaxis : "SCP - Containment Breach.exe", 0x000F5400, 0x160, 0x140, 0x48;
	float deathTimer : "SCP - Containment Breach.exe", 0x000F5400, 0x98, 0x358;
	float scp106state : "SCP - Containment Breach.exe", 0x000F5400, 0xBC, 0x8, 0x88, 0x8, 0xEc, 0x8, 0x178;
}

startup
{
	//prompts use to switch to game time if they are using real time
	if (timer.CurrentTimingMethod == TimingMethod.RealTime) {
	    var gameTimeMessage = MessageBox.Show( // i yoinked part of this code from the BFBBR .ASL file
	            "SCP - Containment Breach v1.3.11 uses Time Without Loads (Game Time) as it's main timing method.\n\n" +
	            "Your timing method is currently set to Real Time. \nWould you like to switch to Game Time?\n",
	            "Livesplit | SCP - Containment Breach v1.3.11",
	            MessageBoxButtons.YesNo, MessageBoxIcon.Question
	    );
	    if (gameTimeMessage == DialogResult.Yes) timer.CurrentTimingMethod = TimingMethod.GameTime;
	}
settings.Add("1.3.11", true, "1.3.11");
settings.SetToolTip("1.3.11", "It will automatically split when you:\n - Spawn\n - Beat the game\nCurrently supports the following versions:\n - 1.3.11");

settings.Add("allEndings", true, "All Endings", "1.3.11");
settings.SetToolTip("allEndings", "Select this if you are going for any ending.\nIf you are going for B2, time ends when the B1 run would end, but you need to add 1:22.12 to your final time.");

settings.Add("death%", false, "Death%", "1.3.11");
settings.SetToolTip("death%", "It will automatically split when you start and when you die.\n");
}

init
{
    if (modules.First().ModuleMemorySize == 6537216)
        version = "v1.3.11";
	int split;
	vars.split = 0;
}

start
{
	if (settings["1.3.11"] == true && (current.onaloadingscreen != 0 | current.onaloadingscreen == 0))
		if (old.blink < -9.99999999 && (current.blink > 1 || current.blink <= -10.00000001) && current.zaxis > 130) {
			vars.split = 1;
			return true;
		}

}

split
{
	if (settings["1.3.11"] == true)
	{
        if (settings["allEndings"] == true)
		{
            if ((current.sprint == -5 && current.scp106state != -11) || (current.a2event == 1) || (current.yaxis < 42.0781 && current.yaxis > 42 && current.deathTimer == 0))
            {
                vars.split++;
                return true;
            }
		}
		else if (settings["death%"] == true)
		{
			if (current.deathTimer != 0.0)
			{
				vars.split++;
				return true;
			}
		}
	}
}

isLoading
{
	if (settings["1.3.11"] == true)
	{
		if ((current.onaloadingscreen == 1 && current.keypresses == 0) || (current.yaxis > 501.25) || (current.yaxis > 42 && current.gateBloadigscreen == 2 && current.paused == 0 && current.gateBloadigscreen2 == 2 && current.inventory == 0))
			return true;
		else
			return false;
	}
}

reset
{
	if (settings["1.3.11"] == true)
	{
		if(current.mainmenu == 0)
		{
			vars.split = 0;
			return true;
		}
	}
}
