state("SCP - Containment Breach", "v1.3.11")
{
	byte mainmenu : "SCP - Containment Breach.exe", 0x000F5400, 0x120, 0x458;
	byte onaloadingscreen : "SCP - Containment Breach.exe", 0x000F5400, 0x98, 0x598;
	byte a2event : "SCP - Containment Breach.exe", 0x000F5400, 0x98, 0x1490;
	byte gateBloadigscreen : "SCP - Containment Breach.exe", 0x000f5400, 0x98, 0xd68;
	byte gateBloadigscreen2 : "SCP - Containment Breach.exe", 0x000f5400, 0x98, 0xd64;
	byte paused : "SCP - Containment Breach.exe", 0x000f5400, 0x98, 0x5dc;
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
settings.Add("1.3.11", true, "1.3.11");
settings.SetToolTip("1.3.11", "It will automatically split when you:\n - Spawn\n - Reach Heavy Containment Zone\n - Reach Entrance Zone.\nCurrently supports the following versions:\n - 1.3.11");

settings.Add("maincategory", false, "Any%", "1.3.11");
settings.SetToolTip("maincategory", "Select this if you are running Any% with or without OoB.");

settings.Add("randomending", false, "Random%", "1.3.11");
settings.SetToolTip("randomending", "Select this if you are running Random%.\nDoes not include B2 because I can't find a pointer to the warheads.");

settings.Add("gatea1ending", false, "Gate A Ending 1", "maincategory");
settings.SetToolTip("gatea1ending", "It will automatically split when you:\n - Reach Gate A\n - Trigger the Chaos Insurgency event.");

settings.Add("gatea2ending", false, "Gate A Ending 2", "maincategory");
settings.SetToolTip("gatea2ending", "It will automatically split when you:\n - Reach Gate A\n - Trigger the MTF event.");

settings.Add("gateb1ending", false, "Gate B Ending 1", "maincategory");
settings.SetToolTip("gateb1ending", "It will automatically split when you:\n - Reach Gate B\n - Trigger the SCP-682 event.");

settings.Add("gateb2ending", false, "Gate B Ending 2", "maincategory");
settings.SetToolTip("gateb2ending", "It will automatically split when you:\n - Reach Gate B\n - Die after triggering the SCP-682 event.");
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
		if (settings["maincategory"] == true)
		{
			if (vars.split == 1 && current.zaxis < 95)
			{
				vars.split = 2;
				return true;
			}
			else if (vars.split == 2 && current.zaxis < 48)
			{
				vars.split = 3;
				return true;
			}
			else if(settings["gatea1ending"] == true)
			{
				if (vars.split == 3)
				{
					if (version == "v1.3.11" && current.xaxis > 141 && current.xaxis < 145 && current.zaxis < 9 && current.zaxis > 6 && current.yaxis > 500)
					{
						vars.split = 4;
						return true;
					}
				}
				if ((vars.split == 4) && (current.sprint == -5) && (current.scp106state != -11))
				{
					vars.split = 5;
					return true;
				}
			}
			else if(settings["gatea2ending"] == true)
			{
				if (vars.split == 3)
				{
					if (current.yaxis > 500)
					{
						vars.split = 4;
						return true;
					}
				}
				if (vars.split == 4 && current.a2event == 1)
				{
					vars.split = 5;
					return true;
				}
			}
			else if(settings["gateb1ending"] == true)
			{
				if (vars.split == 3)
				{
					if (version == "v1.3.11" && current.yaxis > 42 && current.yaxis < 43)
					{
						vars.split = 4;
						return true;
					}
				}
				if (vars.split == 4 && current.yaxis < 42.0781 && current.yaxis > 42 && current.deathTimer == 0)
				{
					vars.split = 5;
					return true;
				}
			}
			else if(settings["gateb2ending"] == true)
			{
				if (vars.split == 3)
				{
					if (version == "v1.3.11" && current.yaxis > 42 && current.yaxis < 43)
					{
						vars.split = 4;
						return true;
					}
				}
				if ((vars.split == 4) && (current.deathTimer != 0.0) && (current.yaxis < 42.0781))
				{
					vars.split = 5;
					return true;
				}
			}
		}
		else if (settings["randomending"] == true)
		{
			if (vars.split == 1 && current.zaxis < 95) //lcz to hc split
			{
				vars.split = 2;
				return true;
			}
			else if (vars.split == 2 && current.zaxis < 48) //hc to ez
			{
				vars.split = 3;
				return true;
			}
			if (vars.split == 3)
			{
				if ((current.xaxis > 141 && current.xaxis < 145 && current.zaxis < 9 && current.zaxis > 6 && current.yaxis > 500) /*ez to gate a*/ || (current.yaxis > 42 && current.yaxis < 43) /*ez to gate b*/)
				{
					vars.split = 4;
					return true;
				}
			}
			if (vars.split == 4)
			{
				if (current.sprint == -5 && current.scp106state != -11 || current.a2event == 1 || current.yaxis < 42.0781 && current.yaxis > 42 && current.deathTimer == 0)
				{
					vars.split = 5;
					return true;
				}
			}
		}
	}
}

isLoading
{
	if (settings["1.3.11"] == true)
	{
		if ((current.onaloadingscreen != 0) || (current.yaxis > 501.25) || (current.yaxis > 42 && current.gateBloadigscreen == 2 && current.paused == 0 && current.gateBloadigscreen2 == 2))
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
