
private _ctrlSetting = _display ctrlCreate ["RscCombo", count _contols + IDC_OFFSET_SETTING, _ctrlOptionsGroup];
_contols pushBack _ctrlSetting;

_ctrlSetting ctrlSetPosition [
    POS_X(16),
    POS_Y(_offsetY),
    POS_X(10),
    POS_Y(1)
];
_ctrlSetting ctrlCommit 0;

private _data = [_setting, _source, []];

{
    private _index = _ctrlSetting lbAdd (_labels select _forEachIndex);
    _ctrlSetting lbSetData [_index, str _index];
    (_data select 2) set [_index, _x];
} forEach _values;

_ctrlSetting lbSetCurSel (_values find _currentValue);

_ctrlSetting setVariable [QGVAR(linkedControls), _linkedControls];
_ctrlSetting setVariable [QGVAR(data), _data];

_ctrlSetting ctrlAddEventHandler ["LBSelChanged", {
    params ["_control", "_index"];

    (_control getVariable QGVAR(data)) params ["_setting", "_source", "_data"];

    private _value = _data select _index;
    SET_TEMP_NAMESPACE_VALUE(_setting,_value,_source);
}];

_linkedControls pushBack _ctrlSetting;

if (_isOverwritten) then {
    _ctrlSettingName ctrlSetTextColor COLOR_TEXT_OVERWRITTEN;
    _ctrlSetting ctrlSetTooltip localize LSTRING(overwritten_tooltip);
};

if !(_enabled) then {
    _ctrlSettingName ctrlSetTextColor COLOR_TEXT_DISABLED;
    _ctrlSetting ctrlEnable false;
};
