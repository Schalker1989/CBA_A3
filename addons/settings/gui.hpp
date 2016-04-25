
class RscControlsGroup {
    class VScrollbar;
    class HScrollbar;
};

class RscText;
class CBA_Rsc_SettingText: RscText {
    style = 0x01;
};

class RscCombo;
class RscListNBox;
class RscButtonMenu;

// can't set the colorDisable with SQF, so we have to create our own base classes when we want to use these with ctrlCreate
class RscXSliderH;
class CBA_Rsc_Slider_R: RscXSliderH {
    color[] = {1,0,0,0.6};
    colorActive[] = {1,0,0,1};
    colorDisable[] = {1,0,0,0.4};
};
class CBA_Rsc_Slider_G: RscXSliderH {
    color[] = {0,1,0,0.6};
    colorActive[] = {0,1,0,1};
    colorDisable[] = {0,1,0,0.4};
};
class CBA_Rsc_Slider_B: RscXSliderH {
    color[] = {0,0,1,0.6};
    colorActive[] = {0,0,1,1};
    colorDisable[] = {0,0,1,0.4};
};

class GVAR(OptionsGroup): RscControlsGroup {
    class HScrollbar: HScrollbar {
        height = 0;
    };
    x = "0.5 * (((safezoneW / safezoneH) min 1.2) / 40)";
    y = "3.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
    w = "35 * (((safezoneW / safezoneH) min 1.2) / 40)";
    h = "13.8 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
    lineHeight = "1 *((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";

    class controls {}; // auto generated
};

// have to create to dynamically for every options group, because they would interfere with the controls groups otherwise
// has to be done, because scripted controls are always placed below regular (config) ones.
class GVAR(AddonsList): RscCombo {
    linespacing = 1;
    text = "";
    wholeHeight = "12 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
    x = "4.5 * (((safezoneW / safezoneH) min 1.2) / 40)";
    y = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
    w = "21 * (((safezoneW / safezoneH) min 1.2) / 40)";
    h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
};

class RscDisplayGameOptions {
    class controls {
        class CBA_ButtonConfigureAddons: RscButtonMenu {
            idc = IDC_BTN_CONFIGURE_ADDONS;
            text = CSTRING(configureAddons);
            x = "20.15 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX)";
            y = "23 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))";
            w = "12.5 * (((safezoneW / safezoneH) min 1.2) / 40)";
            h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
        };

        class CBA_ButtonClient: RscButtonMenu {
            idc = IDC_BTN_CLIENT;
            text = CSTRING(ButtonClient);
            tooltip = CSTRING(ButtonClient_tooltip);
            x = "1 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX)";
            y = "2.1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))";
            w = "8 * (((safezoneW / safezoneH) min 1.2) / 40)";
            h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
        };

        class CBA_ButtonServer: CBA_ButtonClient {
            idc = IDC_BTN_SERVER;
            text = CSTRING(ButtonServer);
            tooltip = CSTRING(ButtonServer_tooltip);
            x = "9 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX)";
        };

        class CBA_ButtonMission: CBA_ButtonClient {
            idc = IDC_BTN_MISSION;
            text = CSTRING(ButtonMission);
            tooltip = CSTRING(ButtonMission_tooltip);
            x = "17 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX)";
        };

        class CBA_AddonsGroup: RscControlsGroup {
            class VScrollbar: VScrollbar {
                width = 0;
            };
            class HScrollbar: HScrollbar {
                height = 0;
            };
            idc = IDC_ADDONS_GROUP;
            enableDisplay = 0;
            x = "1 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX)";
            y = "3.1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + safezoneH -     (((safezoneW / safezoneH) min 1.2) / 1.2))";
            w = "38 * (((safezoneW / safezoneH) min 1.2) / 40)";
            h = "17.3 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";

            class controls {
                class CBA_AddonsEmptyBackground: RscText {
                    idc = -1;
                    type = 0x00;
                    text = "";
                    colorBackground[] = {0,0,0,0.4};
                    x = "0.5 * (((safezoneW / safezoneH) min 1.2) / 40)";
                    y = "3.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
                    w = "35 * (((safezoneW / safezoneH) min 1.2) / 40)";
                    h = "13.8 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
                };
                class CBA_AddonsCA_ControlsPageText: RscText {
                    sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
                    style = 0x01;
                    idc = 2002;
                    text = "Addon:";
                    x = "0.5 * (((safezoneW / safezoneH) min 1.2) / 40)";
                    y = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
                    w = "4 * (((safezoneW / safezoneH) min 1.2) / 40)";
                    h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
                };
                class CBA_ForceSettingText: RscText {
                    style = 0x01;
                    idc = IDC_TXT_FORCE;
                    text = "";
                    tooltip = CSTRING(force_tooltip);
                    x = "25 * (((safezoneW / safezoneH) min 1.2) / 40)";
                    y = "2.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
                    w = "10 * (((safezoneW / safezoneH) min 1.2) / 40)";
                    h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
                };
            };
        };
    };
};
