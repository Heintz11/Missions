
// Create reference to the two parameters
_cro_objectivePosition = _this select 0;
_cro_allplayersArray = _this select 1;

// Place objective types in array and choose one; greater weight given to custom objectives
_cro_objectivetypesArray = ["box", "wreck", "officer", "mortar", "custom", "custom"];
_cro_selectedobjectiveType = [_cro_objectivetypesArray] call Zen_ArrayGetRandom;

// If custom array, create array of vehicle types and choose one
_cro_customVehicle = "";
if (_cro_selectedobjectiveType == "custom") then {
	_cro_vehicletypesArray = ["O_Heli_Light_02_unarmed_F", "O_Truck_02_covered_F", "O_Truck_02_transport_F", "O_MRAP_02_F"];
	_cro_customVehicle = [_cro_vehicletypesArray] call Zen_ArrayGetRandom;
};

// Call Zen Objective function
_cro_currentObjective = [_cro_objectivePosition, _cro_allplayersArray, east, _cro_selectedobjectiveType, "eliminate", _cro_customVehicle] call Zen_CreateObjective;

// Create reference to elements of Objective reference
// _cro_currentObjective = reference to current Objective
// _cro_currentObjectiveUnit = reference to current Objective Unit; the squad, vehicle, box, etc, that is focus of the objective
// _cro_currentObjectiveTaskName = internal name generated by Framework
_cro_currentObjectiveUnit = (_cro_currentObjective select 0) select 0;
_cro_currentObjectiveTaskName = _cro_currentObjective select 1;

// Create target for the focus of the objective; for tracking moving vehicles in custom objectives
0 = [_cro_currentObjectiveTaskName, _cro_currentObjectiveUnit] call Zen_SetTaskTarget;

// Create an area marker around the objective spawn position
_cro_patrolMarker = [_cro_objectivePosition, "", "colorBlack", [600, 600], "ellipse", 0, 0] call Zen_SpawnMarker;
//_cro_patrolMarker = [_cro_objectivePosition, "", "colorBlue", [600, 600], "ellipse", 0, .5] call Zen_SpawnMarker;	// Debug code

// If custom generate crew and order vehicle to patrol
if (_cro_selectedobjectiveType == "custom") then {
	[_cro_currentObjectiveUnit] call zen_SpawnVehicleCrew;
	if (_cro_currentObjectiveUnit isKindOf "air") then {
		0 = [_cro_currentObjectiveUnit, _cro_patrolMarker] spawn Zen_OrderAircraftPatrol;
	} else {
		0 = [_cro_currentObjectiveUnit, _cro_patrolMarker] spawn Zen_OrderVehiclePatrol;
	};
};

// Spawn 3 TO 5 OPFOR squads inside the area marker surrounding the objective spawn position
_cro_OPFORPatrolArray = [];
for "_i" from 0 to (2 + random 2) do {
	_cro_squadPosition = [_cro_patrolMarker] call Zen_FindGroundPosition;
	_cro_OPFORSquad = [_cro_squadPosition, east, "infantry", [2,3]] call Zen_SpawnInfantry;
	//_cro_debugTracking = [[_cro_OPFORSquad], "group"] call Zen_TrackInfantry;	// Debug code
	0 = [_cro_OPFORSquad, ["Rifleman", "Assistant AR", "Recon", "Team Leader", "Grenadier", "Auto Rifleman", "Marksman", "Medic"]] call Zen_GiveLoadoutOpfor;
	_cro_OPFORPatrolArray set [(count _cro_OPFORPatrolArray), _cro_OPFORSquad];
};
0 = [_cro_OPFORPatrolArray, _cro_patrolMarker] spawn Zen_OrderInfantryPatrol;

// Return reference to objective
(_cro_currentObjectiveTaskName)
