
state("SCP - Containment Breach", "1.3.3") {

    bool paused : "SCP - Containment Breach.exe", 0x000EFF78, 0xFC, 0x9A8, 0x248;
    bool inventory : "SCP - Containment Breach.exe", 0x000EFF78, 0xFC, 0x9A8, 0x250;
    bool loading : "SCP - Containment Breach.exe", 0x000EFF78, 0xFC, 0x9A8, 0x204;
    bool a2Event : "SCP - Containment Breach.exe", 0x000EFF78, 0xFC, 0x9A8, 0x182C;
    bool console : "SCP - Containment Breach.exe", 0x000EFF78, 0xFC, 0x9A8, 0x5B8;

    byte mainMenu : "SCP - Containment Breach.exe", 0x000EFF78, 0xFC, 0x9A8, 0x1910;

    float blink : "SCP - Containment Breach.exe", 0x000EFF78, 0xFC, 0x9A8, 0x0;
    float stamina : "SCP - Containment Breach.exe", 0x000EFF78, 0xFC, 0x9A8, 0x14;
    float xPos : "SCP - Containment Breach.exe", 0x000F67DC, 0xC, 0x4, 0x40;
    float yPos : "SCP - Containment Breach.exe", 0x000F67DC, 0xC, 0x4, 0x44;
    float zPos : "SCP - Containment Breach.exe", 0x000F67DC, 0xC, 0x4, 0x48;
    float deathTimer : "SCP - Containment Breach.exe", 0x000F5EEC, 0xA0, 0x6C, 0x58, 0x1C, 0x74, 0x2D0;
}

startup {
    if (timer.CurrentTimingMethod == TimingMethod.RealTime) {
        var gameTimeMessage = MessageBox.Show( // i yoinked part of this code from the BFBBR .ASL file
                "SCP - Containment Breach v1.3.11 uses Time Without Loads (Game Time) as it's main timing method.\n\n" +
                "Your timing method is currently set to Real Time. \nWould you like to switch to Game Time?\n",
                "Livesplit | SCP - Containment Breach v1.3.3",
                MessageBoxButtons.YesNo, MessageBoxIcon.Question
        );
        if (gameTimeMessage == DialogResult.Yes) timer.CurrentTimingMethod = TimingMethod.GameTime;
    }

    settings.Add("allEndings1.3.3", true, "All Endings for v1.3.3");
    settings.SetToolTip("allEndings1.3.3", "It will automatically split when you:\n - Spawn" +
                                            "\n - Reach Heavy Containment Zone\n - Reach Entrance Zone." +
                                            "\n - Reach the Surface." +
                                            "\n - Finish the Game Through Any Ending." +
                                            "\nCurrently supports the following versions:\n - 1.3.3");
}

init {
    int moduleSize = modules.First().ModuleMemorySize;
    print(moduleSize.ToString());
    if (moduleSize == 5861376) version = "1.3.3";
    print(version);

    int currentSplit;
    vars.currentSplit = 0;

    bool isLoading;
    vars.isLoading = current.loading && current.blink == old.blink;

    bool gateALoading;
    vars.gateALoading = (current.yPos > 48 && current.yPos < 49 && current.blink == old.blink);

    bool gateBLoading;
    vars.gateBLoading = (current.yPos > 42.3 && current.yPos < 42.7 && current.blink == old.blink && !current.inventory && !current.paused && !current.console);

}

start {
    if (settings["allEndings1.3.3"] && version.Equals("1.3.3") && !current.loading) {
        if (old.blink < -9.99999999 && (current.blink > 1 || current.blink <= -10.00000001) && current.zPos > 130) {
			vars.currentSplit = 1;
			return true;
		}
    }
}

split {
    if (vars.currentSplit == 1 && current.zPos < 95 && current.zPos > 94) {
        vars.currentSplit++;
        return true;
    }
    if (vars.currentSplit == 2 && current.zPos < 48 && current.zPos > 47) {
        vars.currentSplit++;
        return true;
    }
    if (vars.currentSplit == 3 && ((current.yPos < 49 && current.yPos > 48) || (current.yPos > 42.3 && current.yPos < 42.7))) {
        vars.currentSplit++;
        return true;
    }
    if (vars.currentSplit == 4 && ((current.stamina == -5 || current.a2Event) || (current.yPos < 42.0781))) {
        return true;
    }
}

isLoading {
    return vars.isLoading || vars.gateALoading || vars.gateBLoading;
}

update {
    vars.isLoading = current.loading && current.blink == old.blink;
    vars.gateALoading = (current.yPos > 48 && current.yPos < 49 && current.blink == old.blink);
    vars.gateBLoading = (current.yPos > 42.3 && current.yPos < 42.7 && current.blink == old.blink && !current.inventory && !current.paused && !current.console);
}

reset {
    if (current.mainMenu == 0) {
        vars.currentSplit = 0;
        return true;
    }
}
