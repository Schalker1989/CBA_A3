/* ----------------------------------------------------------------------------
Internal Function: CBA_settings_fnc_init

Description:
    Init settings.

Parameters:
    None

Returns:
    None

Author:
    commy2
---------------------------------------------------------------------------- */
#include "script_component.hpp"

if (isNil QGVAR(defaultSettings)) then {
    // settings can be set in the main menu. have to use ui namespace copies of the functions
    GVAR(defaultSettings) = [] call (uiNamespace getVariable "CBA_fnc_createNamespace");
    GVAR(allSettings) = []; // same as allVariables GVAR(defaultSettings), but case sensitive

    {
        private _addon = configName _x;

        {
            private _setting = configName _x;
            private _settingType = getText (_x >> "type");
            private _displayName = getText (_x >> "displayName");
            private _tooltip = getText (_x >> "tooltip");

            if (_displayName isEqualTo "") then {
                _displayName = _setting;
            };

            private "_defaultValue";
            private _values = [];
            private _labels = [];
            private _trailingDecimals = 0;
            private _enabledFor = getNumber (_x >> "enabledFor");

            switch (toUpper _settingType) do {
                case ("BOOLEAN"): {
                    _defaultValue = getNumber (_x >> "defaultValue") == 1;
                    _values = [_defaultValue, !_defaultValue];
                };
                case ("LIST"): {
                    _values = getArray (_x >> "values");
                    _labels = getArray (_x >> "labels");
                    _labels resize count _values;
                    {
                        if (isNil "_x") then { _x = _values select _forEachIndex };
                        if !(_x isEqualType "") then { _x = str _x };
                        if ((_x select [0, 1]) isEqualTo "$") then {
                            _x = _x select [1];
                            if (isLocalized _x) then { _x = localize _x };
                        };
                        _labels set [_forEachIndex, _x];
                    } forEach _labels;

                    _defaultValue = _values param [getNumber (_x >> "defaultIndex"), 0];
                };
                case ("SLIDER"): {
                    _values = [getNumber (_x >> "min"), getNumber (_x >> "max")];
                    _defaultValue = getNumber (_x >> "defaultValue");
                    _trailingDecimals = getNumber (_x >> "trailingDecimals");
                };
                case ("COLOR"): {
                    _defaultValue = getArray (_x >> "defaultValue");
                };
                default {};
            };

            _enabledFor = _enabledFor call (uiNamespace getVariable "BIS_fnc_decodeFlags") apply {
                ["client", "server", "mission"] param [_x, "client"];
            };

            GVAR(defaultSettings) setVariable [_setting, [_defaultValue, _addon, _settingType, _values, _labels, _displayName, _tooltip, _trailingDecimals, _enabledFor arrayIntersect _enabledFor, []]];
            GVAR(allSettings) pushBack _setting;
        } forEach ("true" configClasses _x);
    } forEach ("true" configClasses (configFile >> "CBA_Settings"));
};

if (isNil QGVAR(clientSettings)) then {
    // retrieve client settings from profile
    GVAR(clientSettings) = [] call (uiNamespace getVariable "CBA_fnc_createNamespace");

    (profileNamespace getVariable [QGVAR(profileSettings), []]) params [["_clientSettings", []], ["_clientValues", []], ["_clientForced", []]];

    {
        private _setting = _x;
        private _value = _clientValues param [_forEachIndex];
        private _forced = _clientForced param [_forEachIndex, false];

        if (!isNil {GVAR(defaultSettings) getVariable _setting}) then {
            if !([_setting, _value] call FUNC(check)) then {
                _value = [_setting, "default"] call FUNC(get);

                [_setting, _value, _forced, "client"] call FUNC(set);
                diag_log text format ["[CBA] (settings): Invalid value for setting %1. Fall back to default value.", str _setting];
            };

            GVAR(clientSettings) setVariable [_setting, [_value, _forced]];
        };
    } forEach _clientSettings;
};

if (isNil QGVAR(serverSettings)) then {
    if (!isServer) exitWith {};

    if (isMultiplayer) then {
        // retrieve client settings from profile
        GVAR(serverSettings) = true call (uiNamespace getVariable "CBA_fnc_createNamespace");
        publicVariable QGVAR(serverSettings);

        (profileNamespace getVariable [QGVAR(profileSettings), []]) params [["_serverSettings", []], ["_serverValues", []], ["_serverForced", []]];

        {
            private _setting = _x;
            private _value = _serverValues param [_forEachIndex];
            private _forced = _serverForced param [_forEachIndex, false];

            if (!isNil {GVAR(defaultSettings) getVariable _setting} && {[_setting, _value] call FUNC(check)}) then {
                GVAR(serverSettings) setVariable [_setting, [_value, _forced], true];
            };
        } forEach _serverSettings;
    } else {
        GVAR(serverSettings) = [] call (uiNamespace getVariable "CBA_fnc_createNamespace");
    };
};

if (isNil QGVAR(missionSettings)) then {
    // retrieve mission settings from 3den mission
    GVAR(missionSettings) = [] call (uiNamespace getVariable "CBA_fnc_createNamespace");

    // delay a frame, because "get3DENMissionAttribute" (and "is3DEN") are not working on preInit when
    // returning from a preview (they do when entering the editor from the main menu though)
    // use spawn-directCall, because CBA_fnc_execNextFrame stalls until after postInit
    0 spawn {
        {

            private _missionSettingsVar = missionNamespace getVariable [QGVAR(3denSettings), "Scenario" get3DENMissionAttribute QGVAR(missionSettings)];
            _missionSettingsVar params [["_missionSettings", []], ["_missionValues", []], ["_missionForced", []]];

            {
                private _setting = _x;
                private _value = _missionValues param [_forEachIndex];
                private _forced = _missionForced param [_forEachIndex, false];

                if (!isNil {GVAR(defaultSettings) getVariable _setting} && {[_setting, _value] call FUNC(check)}) then {
                    GVAR(missionSettings) setVariable [_setting, [_value, _forced]];
                };
            } forEach _missionSettings;

            // set local values now, but don't do events. this is so these don't remain undefined
            {
                private _setting = _x;
                private _value = _setting call FUNC(get);

                missionNamespace setVariable [_setting, _value];
            } forEach GVAR(allSettings);
        } call (uiNamespace getVariable "CBA_fnc_directCall");
    };
};
