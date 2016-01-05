/*
Range clearance script - v0.1
Destroys the object ID's near the object in the range
Called from the object line: nul = this execVM "scripts\Range1\BEARB_RangeClearance.sqf";
Created by WyteOut/BearBison
*/

/* Private variables */
private ["_DestroyIDs"];

/* ID's of objects */
_DestroyIDs = [55890,55882,55883,55884,55885,26675,26673,26672,26676,26342,26359,26344];

/* Destroy objects to clear range */
{(getPos _this nearestObject _x) setDamage 1;} forEach _DestroyIDs;
