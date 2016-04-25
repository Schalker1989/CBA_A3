#include "script_component.hpp"

disableSerialization;

params [["_display", findDisplay 46, [displayNull]]];

private _dlgSettings = _display createDisplay "RscDisplayGameOptions";

// switch to custom addons tab now
private _ctrlConfigureAddons = _dlgSettings displayCtrl IDC_BTN_CONFIGURE_ADDONS;
_ctrlConfigureAddons call FUNC(gui_configure);

// and hide the button to switch back
_ctrlConfigureAddons ctrlEnable false;
_ctrlConfigureAddons ctrlShow false;

// then switch right to missions tab
if (ctrlIDD _display == 313) then {
    private _ctrlMissionButton = _dlgSettings displayCtrl IDC_BTN_MISSION;
    _ctrlMissionButton call FUNC(gui_sourceChanged);
};
