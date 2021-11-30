#include <a_samp>

//----------------------------------------------------

#define DIALOG_INDEX                 (0)
#define DIALOG_MODEL_INPUT           (1)
#define DIALOG_BONE_SELECTION        (2)

//----------------------------------------------------

#define MAX_MODEL_INDEX              (10)

//----------------------------------------------------

new IndexModel[MAX_MODEL_INDEX];
new Model[MAX_MODEL_INDEX];

new Bones[][24] = {
{"Spine"},
{"Head"},
{"Left Upper arm"},
{"Right Upper arm"},
{"Left Hand"},
{"Right Hand"},
{"Left Thigh"},
{"Right Thigh"},
{"Left Foot"},
{"Right Foot"},
{"Right Calf"},
{"Left Calf"},
{"Left Forearm"},
{"Right Forearm"},
{"Left Clavicle"},
{"Right Clavicle"},
{"Neck"},
{"Jaw"}
};

//----------------------------------------------------

main()
{
	print("\n----------------------------------");
	print(" >> Chaga's Player Object Attachment");
    print(" >> Last Update: 1 Desember 2021");
    print(" >> Version: V1");
	print("----------------------------------\n");
}

public OnGameModeInit()
{
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	return 1;
}

public OnGameModeExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);
	return 1;
}

public OnPlayerConnect(playerid)
{
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerSpawn(playerid)
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/attach", cmdtext, true, 10) == 0)
	{
        ShowPlayerDialog(playerid, DIALOG_INDEX, DIALOG_STYLE_INPUT, "Index ID", "Please enter the Index ID below:", "Continue", "Cancel");
        return 1;
    }
	return 0;
}

public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ )
{
    new string[280];
	format(string, sizeof(string),"SetPlayerAttachedObject(playerid, %d, %d, %d, %f, %f, %f, %f, %f, %f, %f, %f, %f)", index,modelid,boneid,fOffsetX,fOffsetY,fOffsetZ,fRotX,fRotY,fRotZ,fScaleX,fScaleY,fScaleZ);
	print(string);
    SetPlayerAttachedObject(playerid, index, modelid, boneid, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ);
    SendClientMessage(playerid, 0xFFFFFFFF, "You finished editing an attached object.");
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case DIALOG_INDEX:
        {
            for (new modelid = 0; modelid < MAX_MODEL_INDEX; modelid++)
            {
                IndexModel[modelid] = strval(inputtext);
                ShowPlayerDialog(playerid, DIALOG_MODEL_INPUT, DIALOG_STYLE_INPUT, "Model ID", "Please enter the model ID below:", "Continue", "Cancel");
            }
        }
        case DIALOG_MODEL_INPUT:
        {
            if(response)
            {
                for (new modelid = 0; modelid < MAX_MODEL_INDEX; modelid++)
                {
                    Model[modelid] = strval(inputtext);
                    new string[256+1];
                    for(new c;c<sizeof(Bones);c++)
                    {
                        format(string, sizeof(string), "%s%s\n", string, Bones[c]);
                    }
                    ShowPlayerDialog(playerid, DIALOG_BONE_SELECTION, DIALOG_STYLE_LIST, "Bone Selection", string, "Select", "Cancel");
                }
            }
            else 
            {
                for (new modelid = 0; modelid < MAX_MODEL_INDEX; modelid++) { IndexModel[modelid] = -1; }
            }
            return 1;
        }
        case DIALOG_BONE_SELECTION:
        {
            if(response)
            {
                for (new modelid = 0; modelid < MAX_MODEL_INDEX; modelid++)
                {
                    SetPlayerAttachedObject(playerid, IndexModel[modelid], Model[modelid], listitem+1);
                    EditAttachedObject(playerid, IndexModel[modelid]);
                }
            }
            for (new modelid = 0; modelid < MAX_MODEL_INDEX; modelid++) { IndexModel[modelid] = -1; Model[modelid] = -1; }
            return 1;
        }
    }
    return 0;
}