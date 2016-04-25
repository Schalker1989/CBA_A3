
private _lists = [];
_display setVariable [QGVAR(lists), _lists];
_display setVariable [QGVAR(controls), []];

{
    private _setting = _x;
    (GVAR(defaultSettings) getVariable _setting) params ["_defaultValue", "_addon", "_settingType", "_values", "_labels", "_displayName", "_tooltip", "_trailingDecimals", "_enabledFor"];

    private _addon = toLower _addon;
    _addons pushBackUnique _addon;

    {
        private _source = toLower _x;
        private _currentValue = [_setting, _source] call FUNC(get);

        // ----- create or retrieve options "list" controls group
        private _list = [QGVAR(list), _addon, _source] joinString "$";

        private _ctrlOptionsGroup = controlNull;

        if !(_list in _lists) then {
            _ctrlOptionsGroup = _display ctrlCreate [QGVAR(OptionsGroup), -1, _display displayCtrl IDC_ADDONS_GROUP];
            _ctrlOptionsGroup ctrlEnable false;
            _ctrlOptionsGroup ctrlShow false;

            (_display getVariable QGVAR(controls)) pushBack _ctrlOptionsGroup;
            _ctrlOptionsGroup setVariable [QGVAR(controls), []];
            _ctrlOptionsGroup setVariable [QGVAR(offsetY), MENU_OFFSET_INITIAL];

            _lists pushBack _list;
            _display setVariable [_list, _ctrlOptionsGroup];
        } else {
            _ctrlOptionsGroup = _display getVariable _list;
        };

        private _offsetY = _ctrlOptionsGroup getVariable QGVAR(offsetY);

        // ----- create setting name text
        private _ctrlSettingName = _display ctrlCreate ["CBA_Rsc_SettingText", -1, _ctrlOptionsGroup];

        _ctrlSettingName ctrlSetText format ["%1:", _displayName];
        _ctrlSettingName ctrlSetTooltip _tooltip;
        _ctrlSettingName ctrlSetPosition [
            POS_X(1),
            POS_Y(_offsetY),
            POS_X(15),
            POS_Y(1)
        ];
        _ctrlSettingName ctrlCommit 0;

        // ----- check if setting can be altered
        private _enabled = switch (_source) do {
            case ("client"): {
                CAN_SET_CLIENT_SETTINGS
            };
            case ("server"): {
                CAN_SET_SERVER_SETTINGS
            };
            case ("mission"): {
                CAN_SET_MISSION_SETTINGS
            };
        };

        // ----- check if altering setting would have no effect
        private _isOverwritten = [_setting, _source] call FUNC(isOverwritten);

        // ----- create setting changer control
        private _contols = _ctrlOptionsGroup getVariable QGVAR(controls);
        private _linkedControls = [];

        switch (toUpper _settingType) do {
            case ("BOOLEAN"): {
                #include "gui_createMenu_button.sqf"
            };
            case ("LIST"): {
                #include "gui_createMenu_list.sqf"
            };
            case ("SLIDER"): {
                #include "gui_createMenu_slider.sqf"
            };
            case ("COLOR"): {
                #include "gui_createMenu_color.sqf"
            };
            default {};
        };

        #include "gui_createMenu_default.sqf"

        // ----- handle "force" button
        if (_source != "client") then {
            #include "gui_createMenu_force.sqf"
        };

        _ctrlOptionsGroup setVariable [QGVAR(offsetY), _offsetY + MENU_OFFSET_SPACING];
    } forEach _enabledFor;
} forEach GVAR(allSettings);
