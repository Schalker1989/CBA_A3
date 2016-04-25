#include "script_component.hpp"
SCRIPT(XEH_preInit);

ADDON = false;

#include "XEH_PREP.sqf"

call FUNC(init);

// event to refresh missionNamespace value if setting has changed and call public event
[QGVAR(refreshSetting), {
    params ["_setting"];
    private _value = _setting call FUNC(get);

    missionNamespace setVariable [_setting, _value];

    private _this = [_value];
    {
        private "_value"; // prevent this variable from being overwritten
        _this call _x;
    } forEach (GVAR(defaultSettings) getVariable _setting select 9);

    ["CBA_SettingChanged", [_setting, _value]] call CBA_fnc_localEvent;
}] call CBA_fnc_addEventHandler;

// event to refresh all settings at once - saves bandwith
[QGVAR(refreshAllSettings), {
    {
        [QGVAR(refreshSetting), _x] call CBA_fnc_localEvent;
    } forEach GVAR(allSettings);
}] call CBA_fnc_addEventHandler;

#ifdef DEBUG_MODE_FULL
["CBA_SettingChanged", {
    params ["_setting", "_value"];

    private _message = format ["[CBA] (settings): %1 = %2", _setting, _value];
    systemChat _message;
    diag_log text _message;
}] call CBA_fnc_addEventHandler;
#endif

// event to modify settings on a dedicated server as admin
if (isServer) then {
    [QGVAR(setSettingServer), {
        params ["_setting", "_value", "_forced"];
        [_setting, _value, _forced, "server"] call FUNC(set);
    }] call CBA_fnc_addEventHandler;
};

// import settings from file if filepatching is enabled
if (isFilePatchingEnabled) then {
    [loadFile PATH_SETTINGS_FILE, "client"] call FUNC(import);
    diag_log text "[CBA] (settings): Settings file loaded.";
} else {
    diag_log text "[CBA] (settings): Cannot load settings file. File patching disabled. Use -filePatching flag.";
};

ADDON = true;
