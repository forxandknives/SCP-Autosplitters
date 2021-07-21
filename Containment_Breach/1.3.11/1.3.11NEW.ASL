
// 5 SPLITS ARE REQURED TO USE THIS AUTOSPLITTER
// IF YOU RUN GATE B ENDING 2 ADD 1:22.12 TO YOUR FINAL TIME
//
// MADE BY FORX

//all the pointers needs to make autosplitter work
state("SCP - Containment Breach" , "v1.3.11") {
    bool a2Event : "SCP - Containment Breach.exe", 0x000f5400, 0x98, 0x1490; // 1 for event is happening
    bool inventory : "SCP - Containment Breach.exe", 0x000f5400, 0x98, 0x5E4; // 1 for user is in inventory
    bool loading : "SCP - Containment Breach.exe", 0x000f5400, 0x98, 0x598; // 1 for user is in a quick load
    bool paused : "SCP - Containment Breach.exe", 0x000f5400, 0x98, 0x5dc; // 1 for user is paused in game

    byte achievements : "SCP - Containment Breach.exe", 0x000f5400, 0x98, 0x550; // number of achievements unlocked
    byte mainMenu : "SCP - Containment Breach.exe", 0x000f5400, 0x120, 0x458; // 0 for at main menu
    byte gateBisLoading1 : "SCP - Containment Breach.exe", 0x000f5400, 0x98, 0xd68; // 2 for in load from ez to gate b surface
    byte gateBisLoading2 : "SCP - Containment Breach.exe", 0x000f5400, 0x98, 0xd64; // 2 for in load from ez to gate b surface
    byte keypresses : "SCP - Containment Breach.exe", 0x000f5f70, 0x604; // num of kerypress done, goes from 0-32, 0 when in a load

    float blink : "SCP - Containment Breach.exe", 0x000f5400, 0x498, 0x7CC; // shows how much blink is left
    float deathTimer : "SCP - Containment Breach.exe", 0x000f5400, 0x98, 0x358; // says if dead or not
    float sprint : "SCP - Containment Breach.exe", 0x000f5400, 0x680, 0x77C; // how much sprint you have
    float xaxis : "SCP - Containment Breach.exe", 0x000f5400, 0x160, 0x140, 0x40; // player x pos
    float yaxis : "SCP - Containment Breach.exe", 0x000f5400, 0x160, 0x140, 0x44; // player y pos
    float zaxis : "SCP - Containment Breach.exe", 0x000f5400, 0x160, 0x140, 0x48; // player z pos
}

startup {
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
    //hover over the setting in autosplitter settings to see this stuff
    settings.Add("allEndings1.3.11", true, "All Endings for v1.3.11");
    settings.SetToolTip("allEndings1.3.11", "It will automatically split when you:\n - Spawn" +
                                            "\n - Reach Heavy Containment Zone\n - Reach Entrance Zone." +
                                            "\n - Encounter SCP-079.\n - Reach the Surface." +
                                            "\n - Finish the Game Through Any Ending." +
                                            "\nCurrently supports the following versions:\n - 1.3.11");
    settings.Add("SCP079", false, "Split on SCP-079");
    settings.SetToolTip("SCP079", "Setting to split when SCP-079 is activated.\n" +
                        "If another SCP's room overlaps with 079's room\n" +
                        "It may not split. It's best to not use this setting\n" +
                        "during Random% runs.");
}

init {
    int moduleSize = modules.First().ModuleMemorySize;
    //verifies that you are on v1.3.11
    if (moduleSize == 6537216) version = "1.3.11";

    //keeps track of current split
    int currentSplit;
    vars.currentSplit = 0;

    //keeps track of whats needed to trigger autostop on Gate B ending
    bool gateBEnding;
    vars.gateBEnding = current.yaxis < 42.0781 && current.yaxis > 42f && current.deathTimer == 0 ? true : false;

    //load remover for anything that is a quickLoad
    bool isLoading;
    vars.isLoading = current.loading && current.keypresses == 0 ? true : false;

    //load remover for the loads from ez to surface
    //gate b loading is utterly retarded
    bool gateLoading;
    vars.gateLoading = (current.yaxis > 501.25 || (current.yaxis > 42 && current.gateBisLoading1 == 2 && !current.paused && current.gateBisLoading2 == 2 && !current.inventory)) ? true : false;
}

start {
    //starts the run
    if (settings["allEndings1.3.11"] && !current.loading) {
		if (old.blink < -9.99999999 && (current.blink > 1 || current.blink <= -10.00000001) && current.zaxis > 130) {
			vars.currentSplit = 1;
			return true;
		}
    }
}

split {
    //split when enter heavy containment
    if (vars.currentSplit == 1 && current.zaxis < 95 && current.zaxis > 94) {
        vars.currentSplit++;
        return true;
    }
    //split when enter entrance zone
    if (vars.currentSplit == 2 && current.zaxis < 48f && current.zaxis > 47f) {
        if (settings["SCP079"]) {
            vars.currentSplit++;
        } else {
            vars.currentSplit += 2;
        }
        return true;
    }
    //split when scp079 is activated
    if (settings["SCP079"] && vars.currentSplit == 3 && current.achievements != old.achievements &&
        current.yaxis < -2.44 && current.yaxis > -2.46) {
        vars.currentSplit++;
        return true;
    }
    //split from entrance zone to surface
    if (vars.currentSplit == 4 && (current.yaxis > 500f || (current.yaxis > 42f && current.yaxis < 43f))) {
        vars.currentSplit++;
        return true;
    }
    //split on any of the 4 endings except b2 -> manually add 1:22.12 to timer
    if (vars.currentSplit == 5 && (current.sprint == -5 || current.a2Event || vars.gateBEnding)) {
        return true;
    }

}
//removes quickLoads and removes the manual loads the game does. why arent they the same devs????
isLoading {
    return vars.isLoading || vars.gateLoading ? true : false;
}
//updates values you get from reading the memory into one variable
update {
    vars.isLoading = current.loading && current.keypresses == 0 && current.blink == old.blink;
    vars.gateLoading = ((current.yaxis < 502 && current.yaxis > 501.25) || (current.yaxis > 42 && current.gateBisLoading1 == 2 && !current.paused && current.gateBisLoading2 == 2 && !current.inventory)) ? true : false;
    vars.gateBEnding = current.yaxis < 42.0781 && current.yaxis > 42f && current.deathTimer == 0 ? true : false;
}
//resets the run if on main menu and sets current split back to 0
reset {
    if (current.mainMenu == 0) {
        vars.currentSplit = 0;
        return true;
    }
}
