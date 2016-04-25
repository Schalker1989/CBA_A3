
private _ctrlSettingDefault = _display ctrlCreate ["RscButtonMenu", count _contols + IDC_OFFSET_SETTING, _ctrlOptionsGroup];
_contols pushBack _ctrlSettingDefault;

_ctrlSettingDefault ctrlSetPosition [
    POS_X(27),
    POS_Y(_ctrlOptionsGroup getVariable QGVAR(offsetY)),
    POS_X(5),
    POS_Y(1)
];
_ctrlSettingDefault ctrlCommit 0;
_ctrlSettingDefault ctrlSetText localize LSTRING(Default);

private _data = [_setting, _source, _defaultValue, _settingType, _values, _trailingDecimals];

_ctrlSettingDefault setVariable [QGVAR(linkedControls), _linkedControls];
_ctrlSettingDefault setVariable [QGVAR(data), _data];

_ctrlSettingDefault ctrlAddEventHandler ["ButtonClick", {
    params ["_control"];

    (_control getVariable QGVAR(data)) params ["_setting", "_source", "_defaultValue", "_settingType", "_values", "_trailingDecimals"];
    SET_TEMP_NAMESPACE_VALUE(_setting,_defaultValue,_source);

    private _linkedControls = _control getVariable QGVAR(linkedControls);

    // reset buttons to default state
    switch (toUpper _settingType) do {
    case ("BOOLEAN"): {
        _linkedControls params ["_ctrlSetting"];

        _ctrlSetting cbSetChecked _defaultValue;
    };
    case ("LIST"): {
        _linkedControls params ["_ctrlSetting"];

        _ctrlSetting lbSetCurSel (_values find _defaultValue);
    };
    case ("SLIDER"): {
        _linkedControls params ["_ctrlSetting", "_ctrlSettingEdit"];

        _ctrlSetting sliderSetPosition _defaultValue;
        _ctrlSettingEdit ctrlSetText ([_defaultValue, 1, _trailingDecimals] call (uiNamespace getVariable "CBA_fnc_formatNumber"));
    };
    case ("COLOR"): {
        _linkedControls params ["_ctrlSettingPreview", "_settingControls"];

        _defaultValue params [
            ["_r", 0, [0]],
            ["_g", 0, [0]],
            ["_b", 0, [0]],
            ["_a", 1, [0]]
        ];
        private _color = [_r, _g, _b, _a];
        _ctrlSettingPreview ctrlSetBackgroundColor _color;

        {
            _x params ["_ctrlSetting", "_ctrlSettingEdit"];
            private _value = _defaultValue select _forEachIndex;

            _ctrlSetting sliderSetPosition _value;
            _ctrlSettingEdit ctrlSetText ([_value, 1, 2] call (uiNamespace getVariable "CBA_fnc_formatNumber"));
        } forEach _settingControls;
    };
    default {};
    };
}];

_linkedControls pushBack _ctrlSettingDefault;

if !(_enabled) then {
    _ctrlSettingDefault ctrlEnable false;
};
