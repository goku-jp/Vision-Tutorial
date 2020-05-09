CMD:modoadmin(playerid, params[])
{
    if(PlayerData[playerid][logado] == false)
	    SendClientMessage(playerid, COR_VERMELHO, "ERRO: Você não está logado!");
    else if(PlayerData[playerid][admin] > PLAYER)
    {
        if(ModoAdmin[playerid] == false)
        {
            GetPlayerHealth(playerid, PlayerData[playerid][health]);
            ModoAdmin[playerid] = true;
            SetPlayerHealth(playerid, FLOAT_INFINITY);
            new string[128];
            format(string, sizeof(string), "%s %s entrou em modo admin.", GetAdminLevelName (PlayerData[playerid][admin]), GetPlayerNameEx(playerid));
            SendClientMessageToAll(COR_ROSA, string);
            SendClientMessageToAll(COR_ROSA, "Use /admins para mais informações.");
        }
        else
        {
            ModoAdmin[playerid] = false;
            SetPlayerHealth(playerid, PlayerData[playerid][health]);
            new string[128];
            format(string, sizeof(string), "%s %s saiu do modo admin.", GetAdminLevelName(PlayerData[playerid][admin]), GetPlayerNameEx(playerid));
            SendClientMessageToAll(COR_ROSA, string);
            SendClientMessageToAll(COR_ROSA, "Use /admins para mais informações.");
        }
    }
    return 1;
}

CMD:admins(playerid, params[])
{
    if(PlayerData[playerid][logado] == false)
	    SendClientMessage(playerid, COR_VERMELHO, "ERRO: Você não está logado!");

    new string[512];
    format(string, sizeof(string), "Admin\tNível\tStatus");
    new Cache:cache = mysql_query(DBConn, "SELECT * FROM Player WHERE admin>0");
    if(cache_is_valid(cache))
    {
        cache_set_active(cache);
        new row;
        if(cache_get_row_count(row))
        {
            for(new i; i<row; i++)
            {
                new adminid, nomeadm[MAX_PLAYER_NAME], modoadm[16], admlvlname[16];
                cache_get_value_name(i, "nome", nomeadm);
                sscanf(nomeadm, "u", adminid);
                if(IsPlayerConnected(adminid)) 
                {
                    format(nomeadm, sizeof(nomeadm), "%s", GetPlayerNameEx(adminid));
                    if(ModoAdmin[adminid] == true)
                        format(modoadm,sizeof(modoadm), "%sDisponível",EMBED_VERDE);
                    else format(modoadm,sizeof(modoadm), "%sJogando",EMBED_AMARELO);
                    format(admlvlname, sizeof(admlvlname), "%s", GetAdminLevelName(PlayerData[adminid][admin]));
                    
                    format(string, sizeof(string), "%s\n%s\t%s\t%s", nomeadm, admlvlname, modoadm);
                }
                else
                {
                    format(modoadm,sizeof(modoadm), "%sOffline",EMBED_VERMELHO);
                    new admlvl;
                    cache_get_value_name_int(i, "admin", admlvl);
                    format(admlvlname, sizeof(admlvlname), "%s", GetAdminLevelName(admlvl));
                    
                    format(string, sizeof(string), "%s\n%s\t%s\t%s", nomeadm, admlvlname, modoadm);
                }
            }
        }
        ShowPlayerDialog(playerid, DIALOG_ADMINS, DIALOG_STYLE_TABLIST_HEADERS, "Staff Administrativa", string, "OK", "Fechar");
    }
    cache_unset_active();
    cache_delete(cache);
    return 1;
}