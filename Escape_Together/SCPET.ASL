
state("SCP_ET", "v0.1.1-alpha") {
    float playerX : "UnityPlayer.dll", 0x01970FC0, 0x10, 0xB0, 0x10, 0x38, 0x90;
    float playerY : "UnityPlayer.dll", 0x01970FC0, 0x10, 0xB0, 0x10, 0x38, 0x94;
    float playerZ : "UnityPlayer.dll", 0x01970FC0, 0x10, 0xB0, 0x10, 0x38, 0x98;

    byte roundEnd : "UnityPlayer.dll", 0x01970FC0, 0x10, 0xB8, 0x88, 0xF0, 0x90, 0x220, 0x780;
}

startup {
    settings.Add("SCP - Escape Together", true, "Escape Together");
    settings.SetToolTip("SCP - Escape Together", "Will start and end the run.");
}

init {
    int moduleSize = modules.First().ModuleMemorySize;
    //print(moduleSize.ToString());
    switch(moduleSize) {
        case 675840:
            version = "v0.1.1-alpha";
            break;
        default:
            version = "Unknown";
            break;
    }
}

start {
    if (old.playerY < -1000.0 && current.playerY > 0.0) {
        return true;
    }
}

split {
    if (current.playerY > 3000.0 && current.playerY < 3005.0 && current.roundEnd == 1) {
        return true;
    }
}
