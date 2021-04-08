
state("SCP - Containment Breach", "1.3.3") {

    bool paused : "SCP - Containment Breach.exe", 0x000F52D0, 0x1A0, 0x9EC;
    bool inventory : "SCP - Containment Breach.exe", 0x000F52D0, 0x1A0, 0x9F4;
    bool loading : "SCP - Containment Breach.exe", 0x000F52D0, 0x1A0, 0x9A8;
    bool mouseHold : "SCP - Containment Breach.exe", 0x000F52D0, 0x1A0, 0x9AC;
    bool a2Event : "SCP - Containment Breach.exe", 0x000F52D0, 0x1A0, 0x1FD0;
    bool console : "SCP - Containment Breach.exe", 0x000F52D0, 0x1A0, 0xD5C;

    byte mainMenu : "SCP - Containment Breach.exe", 0x000F52D0, 0x1A0, 0x20B4;

    int inEle : "SCP - Containment Breach.exe", 0x000F52D0, 0x1A0, 0xF6A;

    float blink : "SCP - Containment Breach.exe", 0x000F52D0, 0x1A0, 0x7A4;
    float stamina : "SCP - Containment Breach.exe", 0x000F52D0, 0x1A0, 0x7B8;
    float deathTimer : "SCP - Containment Breach.exe", 0x000F52D0, 0x1A0, 0x780;
}

startup {
    if (timer.CurrentTimingMethod == TimingMethod.RealTime) {
        var gameTimeMessage = MessageBox.Show( // i yoinked part of this code from the BFBBR .ASL file
                "SCP - Containment Breach v1.3.3 uses Time Without Loads (Game Time) as it's main timing method.\n\n" +
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

    bool gateLoading;

    bool reachedSurface;
    vars.reachedSurface = false;

}

start {
    if (settings["allEndings1.3.3"] && version.Equals("1.3.3") && !current.loading) {
        if (old.blink < -9.99999999 && (current.blink > 1 || current.blink <= -10.00000001)) {
			vars.currentSplit = 1;
			return true;
		}
    }
}

split {
    if (current.stamina == -5 || current.a2Event || current.deathTimer != old.deathTimer) {
        return true;
    }
}

isLoading {
    return vars.isLoading || vars.gateLoading;
}

update {
    vars.isLoading = current.loading && current.blink == old.blink;
    vars.gateLoading = current.blink == old.blink && !current.inventory && !current.paused &&
                        !current.console && !current.mouseHold && current.inEle != 0 &&
                        current.inEle == old.inEle; //literal garbage holy god
}

reset {
    if (current.mainMenu == 0) {
        vars.currentSplit = 0;
        return true;
    }
}
