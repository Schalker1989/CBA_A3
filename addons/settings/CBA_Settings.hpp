
class CBA_Setting_Boolean_base {
    type = "BOOLEAN";
    displayName = "";
    tooltip = "";
    defaultValue = 0;
    enabledFor = CLIENT_SETTING + SERVER_SERVER + MISSION_SERVER;
};

class CBA_Setting_List_base {
    type = "LIST";
    displayName = "";
    tooltip = "";
    values[] = {0,1};
    //labels[] = {"disabled","enabled"};
    defaultIndex = 0;
    enabledFor = CLIENT_SETTING + SERVER_SERVER + MISSION_SERVER;
};

class CBA_Setting_Slider_base {
    type = "SLIDER";
    displayName = "";
    tooltip = "";
    min = 0;
    max = 100;
    defaultValue = 50;
    enabledFor = CLIENT_SETTING + SERVER_SERVER + MISSION_SERVER;
};

class CBA_Setting_Slider_2_base: CBA_Setting_Slider_base {
    min = 0;
    max = 1;
    defaultValue = 0.5;
    trailingDecimals = 2;
    enabledFor = CLIENT_SETTING + SERVER_SERVER + MISSION_SERVER;
};

class CBA_Setting_Color_base {
    type = "COLOR";
    displayName = "";
    tooltip = "";
    defaultValue[] = {1,1,1};
    enabledFor = CLIENT_SETTING + SERVER_SERVER + MISSION_SERVER;
};

class CBA_Setting_Color_Alpha_base: CBA_Setting_Color_base {
    defaultValue[] = {1,1,1,1};
};

class CBA_Settings {
    class CBA {
        /*displayName = "CBA";
        class CBA_TEST1: CBA_Setting_List_base {};
        class CBA_TEST2: CBA_Setting_Boolean_base {};
        class CBA_TEST3: CBA_Setting_Slider_base {};
        class CBA_TEST_C: CBA_Setting_Color_base { displayName = "Test Setting Color"; };
        class CBA_TEST_A: CBA_Setting_Color_Alpha_base { displayName = "Test Setting Color Alpha"; };*/
    };
};
