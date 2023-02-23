#pragma semicolon 1
#include <shop>
#include <sourcemod>
#include <sdktools>
#pragma newdecls required

int ScrollTimes[MAXPLAYERS + 1];
int WinNumber[MAXPLAYERS + 1];
int betAmount[MAXPLAYERS + 1];
bool isSpinning[MAXPLAYERS + 1] = false;
int PlayerChoice[MAXPLAYERS + 1];

int PlayerBet[MAXPLAYERS + 1];
int PlayerLastBet[MAXPLAYERS + 1] = 0;
int a[MAXPLAYERS + 1] = 0;

int timeLeft;

ConVar g_Cvar_VIPFlag;

#define PLUGIN_NAME "Shop Roulette by Kewaii x TTony"
#define PLUGIN_AUTHOR "Kewaii x TTony"
#define PLUGIN_DESCRIPTION "Shop Roulette"
#define PLUGIN_VERSION "1.3.9"
#define PLUGIN_TAG "[Roulette]"

public Plugin myinfo =
{
    name        =    PLUGIN_NAME,
    author        =    PLUGIN_AUTHOR,
    description    =    PLUGIN_DESCRIPTION,
    version        =    PLUGIN_VERSION,
    url            =    "https://github.com/PrdTTony/-CSGO-Roulette"
};

public void OnPluginStart()
{	
	g_Cvar_VIPFlag = CreateConVar("ttony_roulette_vip_flag", "a", "VIP Access Flag");
	RegConsoleCmd("sm_roleta", CommandRoulette);
	RegConsoleCmd("sm_roulette", CommandRoulette);
	RegConsoleCmd("sm_ruleta", CommandRoulette);
	LoadTranslations("ttony_roulette.phrases");
	AutoExecConfig(true, "ttony_roulette");
}

public void OnClientPostAdminCheck(int client)
{
	isSpinning[client] = false;
}

public Action CommandRoulette(int client, int args)
{
	if (client > 0 && args < 1)
	{		
		CreateRouletteMenu(client).Display(client, 10);	
	}
	return Plugin_Handled;
}

public void OnClientPutInServer(int client)
{
    PlayerLastBet[client] = 0;
}

Menu CreateRouletteMenu(int client)
{
	Menu menu = new Menu(RouletteMenuHandler);
	char buffer[128];
	char item[64];
	char betall[64];
	Format(buffer, sizeof(buffer), "%T", "ChooseType", client, Shop_GetClientCredits(client));
	Format(betall, sizeof(betall), "➤Bet all-in [%d credits]", Shop_GetClientCredits(client));
	Format(item, sizeof(item), "➤Bet %d credits again", PlayerLastBet[client]);
	menu.SetTitle(buffer);	
	menu.AddItem("1000", "➤Bet 1000 credits", Shop_GetClientCredits(client) < 50 ? ITEMDRAW_DISABLED : ITEMDRAW_DEFAULT);
	menu.AddItem("5000", "➤Bet 5.000 credits", Shop_GetClientCredits(client) < 100 ? ITEMDRAW_DISABLED : ITEMDRAW_DEFAULT);
	menu.AddItem("20000", "➤Bet 20.000 credits", Shop_GetClientCredits(client) < 100 ? ITEMDRAW_DISABLED : ITEMDRAW_DEFAULT);
	menu.AddItem("50000", "➤Bet 50.000 credits", Shop_GetClientCredits(client) < 500 ? ITEMDRAW_DISABLED : ITEMDRAW_DEFAULT);
	menu.AddItem("75000", "➤[VIP] Bet 75.000 credits", !HasClientVIP(client) || Shop_GetClientCredits(client) < 1000 ? ITEMDRAW_DISABLED : ITEMDRAW_DEFAULT);
	menu.AddItem("100000", "➤[VIP] Bet 100.000 credits", !HasClientVIP(client) || Shop_GetClientCredits(client) < 1000 ? ITEMDRAW_DISABLED : ITEMDRAW_DEFAULT);
	menu.AddItem("150000", "➤[VIP] Bet 150.000 credits", !HasClientVIP(client) || Shop_GetClientCredits(client) < 5000 ? ITEMDRAW_DISABLED : ITEMDRAW_DEFAULT);
	menu.AddItem("200000", "➤[VIP] Bet 200.000 credits", !HasClientVIP(client) || Shop_GetClientCredits(client) < 5000 ? ITEMDRAW_DISABLED : ITEMDRAW_DEFAULT);
	menu.AddItem("lastbet", item, PlayerLastBet[client] == 0 || Shop_GetClientCredits(client) < PlayerLastBet[client] ? ITEMDRAW_DISABLED : ITEMDRAW_DEFAULT);
	menu.AddItem("betallin", betall, ITEMDRAW_DISABLED);
	menu.AddItem("info", "➤How does the roulette work?");
	menu.AddItem("credits", "➤Credits");
	return menu;
}

public int RouletteMenuHandler(Menu menu, MenuAction action, int client, int selection)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			if(IsClientInGame(client))
			{
				char option[32];
				menu.GetItem(selection, option, sizeof(option));
				if (StrEqual(option, "1000"))
				{	
					PlayerBet[client] = 1000;
					CreatePlayerRouletteChooseMenu(client).Display(client, MENU_TIME_FOREVER);		
				}
				if (StrEqual(option, "5000"))
				{	
					PlayerBet[client] = 5000;
					CreatePlayerRouletteChooseMenu(client).Display(client, MENU_TIME_FOREVER);
				}
				if (StrEqual(option, "20000"))
				{	
					PlayerBet[client] = 20000;
					CreatePlayerRouletteChooseMenu(client).Display(client, MENU_TIME_FOREVER);
				}
				if (StrEqual(option, "50000"))
				{	
					PlayerBet[client] = 50000;
					CreatePlayerRouletteChooseMenu(client).Display(client, MENU_TIME_FOREVER);
				}
				if (StrEqual(option, "75000"))
				{	
					PlayerBet[client] = 75000;
					CreatePlayerRouletteChooseMenu(client).Display(client, MENU_TIME_FOREVER);
				}
				if (StrEqual(option, "100000"))
				{	
					PlayerBet[client] = 100000;
					CreatePlayerRouletteChooseMenu(client).Display(client, MENU_TIME_FOREVER);
				}
				if (StrEqual(option, "150000"))
				{	
					PlayerBet[client] = 150000;
					CreatePlayerRouletteChooseMenu(client).Display(client, MENU_TIME_FOREVER);
				}
				if (StrEqual(option, "200000"))
				{	
					PlayerBet[client] = 200000;
					CreatePlayerRouletteChooseMenu(client).Display(client, MENU_TIME_FOREVER);
				}
				if (StrEqual(option, "info"))
				{	
					CreatePlayerRouletteInfoMenu(client).Display(client, MENU_TIME_FOREVER);
				}
				if (StrEqual(option, "credits"))
				{	
					CreatePlayerRouletteCreditsMenu(client).Display(client, MENU_TIME_FOREVER);
				}
				if (StrEqual(option, "lastbet"))
				{	
					PlayerBet[client] = PlayerLastBet[client];
					CreatePlayerRouletteChooseMenu(client).Display(client, MENU_TIME_FOREVER);
				}
				if (StrEqual(option, "betallin"))
				{	
					PlayerBet[client] = Shop_GetClientCredits(client);
					CreatePlayerRouletteChooseMenu(client).Display(client, MENU_TIME_FOREVER);
				}
				
			}
		}
		case MenuAction_End:
		{
			delete menu;
		}
	}
}

Menu CreatePlayerRouletteChooseMenu(int client)
{
	Menu menu1 = new Menu(RouletteMenuHandler1);
	SetMenuExitBackButton(menu1, true);
	char item[256];
	Format(item, sizeof(item), "➤Roulette System™ by TTony © \n\n➤Your bet: %d \n➤Choose what you want to bet on\n‎ ", PlayerBet[client]);
	menu1.SetTitle(item);	
	menu1.AddItem("black", "➤Bet on BLACK");
    menu1.AddItem("red", "➤Bet on RED");
	menu1.AddItem("green", "➤Bet on GREEN", ITEMDRAW_DISABLED);
	menu1.ExitBackButton = true;
	return menu1;
}

Menu CreatePlayerRouletteCreditsMenu(int client)
{
	Menu menu1 = new Menu(RouletteMenuHandler1);
	SetMenuExitBackButton(menu1, true);
	menu1.SetTitle("➤Credits:");	
	menu1.AddItem("0", "➤TTony - Modified Plugin / Menu Showcase", ITEMDRAW_DISABLED);
	menu1.AddItem("0", "➤Kewaii - Roulette System", ITEMDRAW_DISABLED);
	menu1.AddItem("0", "➤xSlow - Hint Animation / Menu Showcase", ITEMDRAW_DISABLED);
	menu1.ExitBackButton = true;
	return menu1;
}

Menu CreatePlayerRouletteInfoMenu(int client)
{
	Menu menu1 = new Menu(RouletteMenuHandler1);
	SetMenuExitBackButton(menu1, true);
	menu1.SetTitle("➤Roulette System™ by TTony © \nHow does the roulette work? \n‎ \nPick your bet between RED | BLACK | GREEN \nIf your pick is similar to the roulette pick you win x2 \nIf not you lose the bet");	
	menu1.AddItem("0", "0", ITEMDRAW_DISABLED);
	menu1.ExitBackButton = true;
	return menu1;
}

public int RouletteMenuInfoHandler(Menu menu, MenuAction action, int client, int selection)
{
	switch(action)
	{
		case MenuAction_Cancel:
		{
			if (IsClientInGame(client) && selection == MenuCancel_ExitBack)
			{
				CreateRouletteMenu(client).Display(client, 10);
			}
		}
		case MenuAction_End:
		{
			delete menu;
		}
	}
}
public int RouletteMenuHandler1(Menu menu, MenuAction action, int client, int selection)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			if(IsClientInGame(client))
			{
				char option[32];
				menu.GetItem(selection, option, sizeof(option));
								
				int crd = Shop_GetClientCredits(client);
				int bet = PlayerBet[client];
				if(crd >= bet)
				{
					if (!isSpinning[client])
					{
						if (StrEqual(option, "black"))
						{
							GetMapTimeLeft(timeLeft);
							if(timeLeft != 0 && timeLeft > 70){
								Shop_SetClientCredits(client, crd - bet);
								betAmount[client] = bet;
								PlayerLastBet[client] = bet;
								SpinCredits(client);
								isSpinning[client] = true;
								PlayerChoice[client] = 1;
							} else {
								PrintToChat(client, " \x07[Roulette™] \x01Map is ending soon, please try again next map");
							}

						} else if (StrEqual(option, "red")) {
							
							GetMapTimeLeft(timeLeft);
							if(timeLeft != 0 && timeLeft > 70){
								Shop_SetClientCredits(client, crd - bet);
								betAmount[client] = bet;
								PlayerLastBet[client] = bet;
								SpinCredits(client);
								isSpinning[client] = true;
								PlayerChoice[client] = 2;
							} else {
								PrintToChat(client, " \x07[Roulette™] \x01Map is ending soon, please try again next map");
							}

						} else if (StrEqual(option, "green")){
							
							GetMapTimeLeft(timeLeft);
							if(timeLeft != 0 && timeLeft > 70){
								Shop_SetClientCredits(client, crd - bet);
								betAmount[client] = bet;
								PlayerLastBet[client] = bet;
								SpinCredits(client);
								isSpinning[client] = true;
								PlayerChoice[client] = 3;
							} else {
								PrintToChat(client, " \x07[Roulette™] \x01Map is ending soon, please try again next map");
							}
						}
					}
					else
					{
						PrintToChat(client, "%s %t", PLUGIN_TAG, "AlreadySpinning");
					}
				} 
				else
				{
					PrintToChat(client, "%s %t", PLUGIN_TAG,  "NotEnoughCredits", bet - crd);
				}
			}
		}
		case MenuAction_Cancel:
		{
			if (IsClientInGame(client) && selection == MenuCancel_ExitBack)
			{
				CreateRouletteMenu(client).Display(client, 10);
			}
		}
		case MenuAction_End:
		{
			delete menu;
		}
	}
}


int b;
int c;
int WinRed[MAXPLAYERS + 1];
int WinBlack[MAXPLAYERS + 1];

public void SpinCredits(int client)
{
	int	FakeNumber = GetRandomInt(0,99);
	int FakeNumber2 = GetRandomInt(0,99);
	int FakeNumber3 = GetRandomInt(0,99);
	int FakeNumber4 = GetRandomInt(0,99);
	WinRed[client] = 0;
	WinBlack[client] = 0;
	
	if (a[client] == 0) {

		PrintHintText(client, "<font color='#494646'>####[ %d ]####\n</font><font color='#0083FF'>➤</font><font color='#FF0000'> ####[ %d ]####\n<font color='#494646'>####[ %d ]####", FakeNumber2, FakeNumber, FakeNumber3);
		a[client] = 1;
		b = FakeNumber;
		c = FakeNumber3;
		WinRed[client] = 1;
		
		
	} else if (a[client] == 1){

		PrintHintText(client, "<font color='#FF0000'>####[ %d ]####\n</font><font color='#0083FF'>➤</font><font color='#494646'> ####[ %d ]####\n<font color='#FF0000'>####[ %d ]####", b, c, FakeNumber4);
		a[client] = 0;
		WinBlack[client] = 1;
		
	}

	if(ScrollTimes[client] == 0)
	{
		ClientCommand(client, "playgamesound *ui/csgo_ui_crate_open.wav");
	}
	if(ScrollTimes[client] < 19)
	{
		CreateTimer(0.05, TimerNext, client);
		ScrollTimes[client] += 1;
		ClientCommand(client, "playgamesound *ui/csgo_ui_crate_item_scroll.wav");
	} 
	else if(ScrollTimes[client] < 29)
	{
		float AddSomeTime = 0.05 * ScrollTimes[client] / 3;
		CreateTimer(AddSomeTime, TimerNext, client);
		ScrollTimes[client] += 1;
		ClientCommand(client, "playgamesound *ui/csgo_ui_crate_item_scroll.wav");
	}
	else if(ScrollTimes[client] == 29)
	{
		int troll = GetRandomInt(1,2);
		if(troll == 1)
		{
			ClientCommand(client, "playgamesound *ui/csgo_ui_crate_item_scroll.wav");
			ScrollTimes[client] += 1;
			CreateTimer(1.5, TimerNext, client);
		}
		else
		{
			ClientCommand(client, "playgamesound *ui/csgo_ui_crate_item_scroll.wav");
			CreateTimer(1.5, TimerFinishing, client);
			WinNumber[client] = FakeNumber;
			ScrollTimes[client] = 0;
		}
	} 
	else
	{
		ClientCommand(client, "playgamesound *ui/csgo_ui_crate_item_scroll.wav");
		CreateTimer(1.5, TimerFinishing, client);
		WinNumber[client] = FakeNumber;
		ScrollTimes[client] = 0;
	}
}

public Action TimerFinishing(Handle timer, any client)
{
	if (IsClientInGame(client))
	{
		isSpinning[client] = false;
		WinCredits(client, WinNumber[client], betAmount[client]);
	}
}

public void WinCredits(int client, int Number, int Bet)
{
	if(IsClientInGame(client))
	{	
		int multiplier;
		/*if((WinGreen[client] == 0 || WinGreen[client] == 999) && PlayerChoice[client] == 3)    // WIN ON GREEN
		{
			multiplier = 10;
			PrintToChat(client, " \x07[Roulette™] \x01You Won \x06%d \x01on \x04GREEN", Bet * multiplier);
			Shop_SetClientCredits(client, Shop_GetClientCredits(client) + (Bet * multiplier));
			CreateRouletteMenu(client).Display(client, MENU_TIME_FOREVER);	
			PrintToChatAll(" \x07[Roulette™] \x06%N \x01won \x06%d on \x04GREEN", client, Bet * multiplier);
		} else if((WinGreen[client] == 0 || WinGreen[client] == 999) && PlayerChoice[client] != 3)
		{
			PrintToChat(client, " \x07[Roulette™] \x01You Lost \x06%s \x01on \x04GREEN", Bet);
			Shop_SetClientCredits(client, Shop_GetClientCredits(client) - Bet);
			CreateRouletteMenu(client).Display(client, MENU_TIME_FOREVER);
		}*/

		if(WinBlack[client] == 1 && PlayerChoice[client] == 1)		// WIN ON BLACK
		{
			multiplier = 2;
			PrintToChat(client, " \x07[Roulette™] \x01You Won \x06%d \x01on \x08BLACK", Bet * multiplier);
			Shop_SetClientCredits(client, Shop_GetClientCredits(client) + (Bet + Bet));
			CreateRouletteMenu(client).Display(client, MENU_TIME_FOREVER);	
			PrintToChatAll(" \x07[Roulette™] \x06%N \x01won \x06%d on \x08BLACK", client, Bet * multiplier);

		} else if(WinBlack[client] == 1 && PlayerChoice[client] != 1) 		// LOSE ON BLACK
		{
			PrintToChat(client, " \x07[Roulette™] \x01You Lost \x06%d \x01on \x08BLACK", Bet);
			Shop_SetClientCredits(client, Shop_GetClientCredits(client) - Bet);
			CreateRouletteMenu(client).Display(client, MENU_TIME_FOREVER);	
		}

		if(WinRed[client] == 1 && PlayerChoice[client] == 2)		// WIN ON RED
		{			
			multiplier = 2;
			PrintToChat(client, " \x07[Roulette™] \x01You Won \x06%d \x01on \x07RED", Bet * multiplier);
			Shop_SetClientCredits(client, Shop_GetClientCredits(client) + (Bet + Bet));
			CreateRouletteMenu(client).Display(client, MENU_TIME_FOREVER);	
			PrintToChatAll(" \x07[Roulette™] \x06%N \x01won \x06%d on \x07RED", client, Bet * multiplier);

		} else if(WinRed[client] == 1 && PlayerChoice[client] != 2)			// LOSE ON RED
		{
			PrintToChat(client, " \x07[Roulette™] \x01You Lost \x06%d \x01on \x07RED", Bet);
			Shop_SetClientCredits(client, Shop_GetClientCredits(client) - Bet);
			CreateRouletteMenu(client).Display(client, MENU_TIME_FOREVER);	
		}	
	}
}

public Action TimerNext(Handle timer, any client)
{
	if (IsClientInGame(client))
	{
		SpinCredits(client);
	}
}

public bool HasClientVIP(int client)
{
	char ConVarValue[32];
	GetConVarString(g_Cvar_VIPFlag, ConVarValue, sizeof(ConVarValue));
	int flag = ReadFlagString(ConVarValue);
	return CheckCommandAccess(client, "", flag, true);
	
}