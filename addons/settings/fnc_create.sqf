/* ----------------------------------------------------------------------------
Internal Function: CBA_settings_fnc_create

Description:
    Creates a new setting for that session.

Parameters:
    _addon       - Addon the setting to be creates belongs to. Used to organize settings menu <STRING>
    _setting     - Unique setting name. Matches resulting variable name <STRING>
    _settingType - Type of setting. Can be "BOOLEAN", "LIST", "SLIDER" or "COLOR" <STRING>
    _title       - Display name or display name + tooltip (optional, default: same as setting name) <STRING, ARRAY>
    _valueInfo   - Extra properties of the setting depending of _settingType. See examples below <ANY>
    _script      - Script to execute when setting is changed or forced. (optional) <CODE>

Returns:
    None

Examples:
    (begin example)
        // CHECKBOX --- extra argument: default value
        ["Mission Settings", "Test_Setting_1", "BOOLEAN", ["-test checkbox-", "-tooltip-"], true] call cba_settings_fnc_create;

        // LIST --- extra arguments: [_values, _valueTitles, _defaultIndex]
        ["Mission Settings", "Test_Setting_2", "LIST",    ["-test list-",     "-tooltip-"], [[1,0], ["enabled","disabled"], 1]] call cba_settings_fnc_create;

        // SLIDER --- extra arguments: [_min, _max, _default, _trailingDecimals]
        ["Mission Settings", "Test_Setting_3", "SLIDER",  ["-test slider-",   "-tooltip-"], [0, 10, 5, 0]] call cba_settings_fnc_create;

        // COLOR PICKER --- extra argument: _color
        ["Mission Settings", "Test_Setting_4", "COLOR",   ["-test color-",    "-tooltip-"], [1,1,0]] call cba_settings_fnc_create;
    (end)

Author:
    commy2
---------------------------------------------------------------------------- */
#include "script_component.hpp"

if (isNil QGVAR(allSettings)) exitWith {
    // this makes this function save to be used in preInit without having "CBA_settings" as required addon
    _this spawn {
        {
            _this call FUNC(create);
        } call CBA_fnc_directCall;
    };
};

params [
    ["_addon", "", [""]],
    ["_setting", "", [""]],
    ["_settingType", "", [""]],
    ["_title", [], ["", []]],
    ["_valueInfo", []],
    ["_enabledFor", nil, [[]]],
    ["_script", {}, [{}]]
];
_title params [["_displayName", nil, [""]], ["_tooltip", "", [""]]];

if (_addon isEqualTo "" || _setting isEqualTo "") exitWith {false};

if (_displayName isEqualTo "") then {
    _displayName = _setting;
};

if (isNil "_enabledFor") then {
    _enabledFor = ["client", "server", "mission"];
};

private "_defaultValue";
private _values = [];
private _labels = [];
private _trailingDecimals = 0;

switch (toUpper _settingType) do {
    case ("BOOLEAN"): {
        _defaultValue = _valueInfo param [0, false, [false]]; // don't use params - we want these variables to be private to the main scope
        _values = [_defaultValue, !_defaultValue];
    };
    case ("LIST"): {
        _values = _valueInfo param [0, [], [[]]];
        _labels = _valueInfo param [1, [], [[]]];
        private _defaultIndex = _valueInfo param [2, 0, [0]];

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

        _defaultValue = _values param [_defaultIndex, 0];
    };
    case ("SLIDER"): {
        _valueInfo params [
            ["_min", 0, [0]],
            ["_max", 1, [0]]
        ];
        _defaultValue = _valueInfo param [2, 0, [0]];
        _trailingDecimals = _valueInfo param [3, 2, [0]];
        _values = [_min, _max];
    };
    case ("COLOR"): {
        _defaultValue = [_valueInfo] param [0, [1,1,1], [[]], [3,4]];
    };
    default {};
};

if (isNil "_defaultValue") exitWith {false};

{
    GVAR(defaultSettings) setVariable [_setting, [_defaultValue, _addon, _settingType, _values, _labels, _displayName, _tooltip, _trailingDecimals, _enabledFor, [_script]]];
    //GVAR(allSettings) pushBackUnique _setting;
    if !(_setting in GVAR(allSettings)) then {GVAR(allSettings) pushBack _setting};

    // read previous setting values from profile
    (profileNamespace getVariable [QGVAR(profileSettings), []]) params [["_profileSettings", []], ["_profileValues", []], ["_profileForced", []]];

    //private _index = (_profileSettings apply {toLower _x}) find toLower _setting;
    private _index = ([_profileSettings, {toLower _x}] call CBA_fnc_filter) find toLower _setting;

    if (_index != -1) then {
        private _value = _profileValues param [_index];
        private _forced = _profileForced param [_index, false];

        if !([_setting, _value] call FUNC(check)) then {
            _value = [_setting, "default"] call FUNC(get);

            [_setting, _value, _forced, "client"] call FUNC(set);
            diag_log text format ["[CBA] (settings): Invalid value for setting %1. Fall back to default value.", str _setting];
        };

        GVAR(clientSettings) setVariable [_setting, [_value, _forced]];
        if (isServer && {isMultiplayer}) then {
            GVAR(serverSettings) setVariable [_setting, [_value, _forced], true];
        };
    };

    private _missionSettingsVar = missionNamespace getVariable [QGVAR(3denSettings), "Scenario" get3DENMissionAttribute QGVAR(missionSettings)];
    _missionSettingsVar params [["_missionSettings", []], ["_missionValues", []], ["_missionForced", []]];

    //_index = (_missionSettings apply {toLower _x}) find toLower _setting;
    _index = ([_missionSettings, {toLower _x}] call CBA_fnc_filter) find toLower _setting;

    if (_index != -1) then {
        private _value = _missionValues param [_index];
        private _forced = _missionForced param [_index, false];

        if ([_setting, _value] call FUNC(check)) then {
            GVAR(missionSettings) setVariable [_setting, [_value, _forced]];
        };
    };

    // refresh
    if (isServer) then {
        [QGVAR(refreshSetting), _setting] call CBA_fnc_globalEvent;
    } else {
        [QGVAR(refreshSetting), _setting] call CBA_fnc_localEvent;  
    };
} call CBA_fnc_directCall;

true
