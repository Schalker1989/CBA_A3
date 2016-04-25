#include "script_component.hpp"

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
private _ctrlOptionsGroup = ((_display getVariable [QGVAR(controls), []]) select {ctrlShown _x}) param [0, controlNull];
private _contols = _ctrlOptionsGroup getVariable [QGVAR(controls), []];

{
    private _linkedControls = _x getVariable QGVAR(linkedControls);
    (_x getVariable QGVAR(data)) params ["_setting", "_source"];
    (GVAR(defaultSettings) getVariable _setting) params ["_defaultValue", "_addon", "_settingType", "_values", "_labels", "_displayName", "_tooltip", "_trailingDecimals", "_enabledFor"];
    _settingType = toUpper _settingType;

    private _value = GET_TEMP_NAMESPACE_VALUE(_setting,_source);

    // reset buttons to current state
    if (!isNil "_value") then {
        switch (_settingType) do {
        case ("BOOLEAN"): {
            _linkedControls params ["_ctrlSetting"];

            _ctrlSetting cbSetChecked _value;
        };
        case ("LIST"): {
            _linkedControls params ["_ctrlSetting"];

            _ctrlSetting lbSetCurSel (_values find _value);
        };
        case ("SLIDER"): {
            _linkedControls params ["_ctrlSetting", "_ctrlSettingEdit"];

            _ctrlSetting sliderSetPosition _value;
            _ctrlSettingEdit ctrlSetText ([_value, 1, _trailingDecimals] call (uiNamespace getVariable "CBA_fnc_formatNumber"));
        };
        case ("COLOR"): {
            _linkedControls params ["_ctrlSettingPreview", "_settingControls"];

            _value params [
                ["_r", 0, [0]],
                ["_g", 0, [0]],
                ["_b", 0, [0]],
                ["_a", 1, [0]]
            ];
            private _color = [_r, _g, _b, _a];
            _ctrlSettingPreview ctrlSetBackgroundColor _color;

            {
                _x params ["_ctrlSetting", "_ctrlSettingEdit"];
                private _valueX = _value select _forEachIndex;

                _ctrlSetting sliderSetPosition _valueX;
                _ctrlSettingEdit ctrlSetText ([_valueX, 1, 2] call (uiNamespace getVariable "CBA_fnc_formatNumber"));
            } forEach _settingControls;
        };
        default {};
        };
    };

    private _forced = GET_TEMP_NAMESPACE_FORCED(_setting,_source);

    // reset force buttons to current state
    if (!isNil "_forced") then {
        switch (_settingType) do {
        case ("BOOLEAN");
        case ("LIST"): {
            private _ctrlSettingForce = _linkedControls param [1, controlNull];
            _ctrlSettingForce cbSetChecked _forced;
        };
        case ("SLIDER");
        case ("COLOR"): {
            private _ctrlSettingForce = _linkedControls param [2, controlNull];
            _ctrlSettingForce cbSetChecked _forced;
        };
        default {};
        };
    };
} forEach _contols;
