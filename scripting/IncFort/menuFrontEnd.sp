//IF Front Menu
public Action:Menu_BuyUpgrade(client, args)
{
	if (IsValidClient(client) && IsPlayerAlive(client) && !client_respawn_checkpoint[client] )
	{
		menuBuy = CreateMenu(MenuHandler_BuyUpgrade);
		SetMenuTitle(menuBuy, "Incremental Fortress - /buy or +SHOWSCORES");
		
		AddMenuItem(menuBuy, "upgrade_player", "Upgrade Body");
		
		AddMenuItem(menuBuy, "upgrade_primary", "Upgrade Primary Slot");
		
		AddMenuItem(menuBuy, "upgrade_secondary", "Upgrade Secondary Slot");
		
		AddMenuItem(menuBuy, "upgrade_melee", "Upgrade Melee Slot");
		
		AddMenuItem(menuBuy, "upgrade_dispcurrups", "Upgrade Manager");
		
		AddMenuItem(menuBuy, "upgrade_stats", "View Stats");
		
		AddMenuItem(menuBuy, "use_arcane", "Use Arcane Spells");

		if (currentitem_level[client][3] != 242)
		{
			AddMenuItem(menuBuy, "upgrade_buyoneweap", "Buy a Custom Weapon");
		}
		else
		{
			AddMenuItem(menuBuy, "upgrade_upgradeoneweap", "Upgrade Bought Weapon");
		}
		
		AddMenuItem(menuBuy, "preferences", "Change Preferences/Settings");
		
		AddMenuItem(menuBuy, "wiki", "Display In-Game Wiki");
		
		DisplayMenuAtItem(menuBuy, client, args, MENU_TIME_FOREVER)
	}
}
//When you purchase an upgrade
Action:Menu_UpgradeChoice(client, subcat_choice, cat_choice, char[] TitleStr, int page = 0)
{
	int i

	Handle menu = CreateMenu(MenuHandler_UpgradeChoice, MENU_ACTIONS_DEFAULT|MenuAction_DisplayItem);
	playerUpgradeMenus[client] = view_as<int>(menu);
	int rate = getUpgradeRate(client);
	if (cat_choice != -1)
	{
		int w_id = current_w_list_id[client]

		char desc_str[512]
		int tmp_up_idx
		int tmp_ref_idx
		int up_cost
		float tmp_val
		float val
		float tmp_ratio
		int slot
		char plus_sign[4]
		current_w_sc_list_id[client] = subcat_choice;
		current_w_c_list_id[client] = cat_choice;
		slot = current_slot_used[client]
		int attributeDisabled[MAX_ATTRIBUTES]
		//PrintToServer("%i | %i", cat_choice, subcat_choice)
		for (i = 0; (tmp_up_idx = given_upgrd_list[w_id][cat_choice][subcat_choice][i]); i++)
		{
			//PrintToServer("%i", tmp_up_idx);
			up_cost = upgrades_costs[tmp_up_idx] / 2
			if (slot == 1)
			{
				up_cost = RoundFloat((up_cost * 1.0) * SecondaryCostReduction)
			}
			tmp_ref_idx = upgrades_ref_to_idx[client][slot][tmp_up_idx];
			if (tmp_ref_idx != 20000)
			{
				val = currentupgrades_val[client][slot][tmp_ref_idx]
				tmp_val = currentupgrades_val[client][slot][tmp_ref_idx] - upgrades_i_val[tmp_up_idx]
				if(currentupgrades_i[client][slot][tmp_ref_idx] != 0.0)
					tmp_val = currentupgrades_val[client][slot][tmp_ref_idx] - currentupgrades_i[client][slot][tmp_ref_idx]
			}
			else
			{
				tmp_val = 0.0
				val = 0.0
			}
			tmp_ratio = upgrades_ratio[tmp_up_idx]
			/*if (tmp_val && tmp_ratio)
			{
				up_cost += RoundFloat(up_cost * (tmp_val / tmp_ratio) * upgrades_costs_inc_ratio[tmp_up_idx])
				if (up_cost < 0.0)
				{
					up_cost *= -1;
					if (up_cost < (upgrades_costs[tmp_up_idx] / 2))
					{
						up_cost = upgrades_costs[tmp_up_idx] / 2
					}
				}
			}*/
			float t_up_cost = 0.0;
			int times = 0;
			if(tmp_ref_idx != 20000)
			{
				float upgrades_val = currentupgrades_val[client][slot][tmp_ref_idx];
				int idx_currentupgrades_val
				if(currentupgrades_i[client][slot][tmp_ref_idx] != 0.0){
					idx_currentupgrades_val = RoundFloat((currentupgrades_val[client][slot][tmp_ref_idx] - currentupgrades_i[client][slot][tmp_ref_idx])/ upgrades_ratio[tmp_up_idx])
				}
				else{
					idx_currentupgrades_val = RoundFloat((currentupgrades_val[client][slot][tmp_ref_idx] - upgrades_i_val[tmp_up_idx])/ upgrades_ratio[tmp_up_idx])
				}
				if(rate > 0)
				{
					for (int idx = 0; idx < rate; idx++)
					{
						float nextcost = t_up_cost + up_cost + up_cost * (idx_currentupgrades_val * upgrades_costs_inc_ratio[tmp_up_idx])
						if(nextcost < CurrencyOwned[client] && upgrades_ratio[tmp_up_idx] > 0.0 && 
						(canBypassRestriction[client] == true || RoundFloat(upgrades_val*100.0)/100.0 < upgrades_m_val[tmp_up_idx]))
						{
							t_up_cost += up_cost + RoundFloat(up_cost * (idx_currentupgrades_val* upgrades_costs_inc_ratio[tmp_up_idx]))
							idx_currentupgrades_val++		
							upgrades_val += upgrades_ratio[tmp_up_idx]
							times++;
						}
						if(nextcost < CurrencyOwned[client] && upgrades_ratio[tmp_up_idx] < 0.0 && 
						(canBypassRestriction[client] == true || RoundFloat(upgrades_val*100.0)/100.0 > upgrades_m_val[tmp_up_idx]))
						{
							t_up_cost += up_cost + RoundFloat(up_cost * (idx_currentupgrades_val * upgrades_costs_inc_ratio[tmp_up_idx]))
							idx_currentupgrades_val++		
							upgrades_val += upgrades_ratio[tmp_up_idx]
							times++;
						}
					}
				}
				else
				{
					for (int idx = 0; idx < IntAbs(rate); idx++)
					{
						if(idx_currentupgrades_val > 0 && upgrades_ratio[tmp_up_idx] > 0.0 && 
						(canBypassRestriction[client] == true || (RoundFloat(upgrades_val*100.0)/100.0 <= upgrades_m_val[tmp_up_idx]
						&& client_spent_money[client][slot] + t_up_cost > client_tweak_highest_requirement[client][slot] - 1.0)))
						{
							idx_currentupgrades_val--
							t_up_cost -= up_cost + RoundFloat(up_cost * (idx_currentupgrades_val* upgrades_costs_inc_ratio[tmp_up_idx]))		
							upgrades_val -= upgrades_ratio[tmp_up_idx]
							times--;
						}
						if(idx_currentupgrades_val > 0 && upgrades_ratio[tmp_up_idx] < 0.0 && 
						(canBypassRestriction[client] == true || (RoundFloat(upgrades_val*100.0)/100.0 >= upgrades_m_val[tmp_up_idx]
						&& client_spent_money[client][slot] + t_up_cost > client_tweak_highest_requirement[client][slot] - 1.0)))
						{
							idx_currentupgrades_val--
							t_up_cost -= up_cost + RoundFloat(up_cost * (idx_currentupgrades_val * upgrades_costs_inc_ratio[tmp_up_idx]))	
							upgrades_val -= upgrades_ratio[tmp_up_idx]
							times--;
						}
					}
				}
			}
			if (tmp_val && tmp_ratio)
			{
				up_cost += RoundFloat(up_cost * (tmp_val / tmp_ratio) * upgrades_costs_inc_ratio[tmp_up_idx])
				if (up_cost < 0.0)
				{
					up_cost *= -1;
					if (up_cost < (upgrades_costs[tmp_up_idx] / 2))
					{
						up_cost = upgrades_costs[tmp_up_idx] / 2
					}
				}
			}
			if(times == 0){
				times = 1;
				t_up_cost = float(up_cost);
			}

			if (tmp_ratio*times > 0.0)
			{
				plus_sign = "+"
			}
			else
			{
				tmp_ratio *= -1.0
				plus_sign = "-"
			}
			char buf[256]
			bool itemDisabled;
			Format(buf, sizeof(buf), "%T", upgradesNames[tmp_up_idx], client)
			if (tmp_ratio < 0.99)
			{
				if(RoundFloat(val*100.0)/100.0 == upgrades_m_val[tmp_up_idx])
				{
					Format(desc_str, sizeof(desc_str), "$%.0f - %s\n\t\t\t%s%i%%\t(%i%%) MAXED %s",
						t_up_cost, buf,
						plus_sign, RoundFloat(tmp_ratio * 100 * times), (RoundFloat(tmp_val * 100)),
						canBypassRestriction[client] == true ? "swagged" : "")
					itemDisabled = true;
					attributeDisabled[tmp_up_idx] = true;
				}
				else if(upgrades_restriction_category[tmp_up_idx] != 0 && (val == 0.0 || val - upgrades_i_val[tmp_up_idx] == 0.0))
				{
					for(int it = 0;it<5;it++)
					{
						if(currentupgrades_restriction[client][slot][it] == upgrades_restriction_category[tmp_up_idx])
						{
							Format(desc_str, sizeof(desc_str), "$%.0f - %s\n\t\t\t%s%i%%\t(%i%%) RESTRICTED %s",
								t_up_cost, buf,
								plus_sign, RoundFloat(tmp_ratio * 100 * times), (RoundFloat(tmp_val * 100)),
								canBypassRestriction[client] == true ? "swagged" : "")
							itemDisabled = true;
							attributeDisabled[tmp_up_idx] = true;
						}
					}
					if(!itemDisabled)
					{
						Format(desc_str, sizeof(desc_str), "$%.0f - %s\n\t\t\t%s%i%%\t(%i%%)",
							t_up_cost, buf,
							plus_sign, RoundFloat(tmp_ratio * 100 * times), (RoundFloat(tmp_val * 100)))
					}
				}
				else if(upgrades_requirement[tmp_up_idx] > StartMoney + additionalstartmoney)
				{
					Format(desc_str, sizeof(desc_str), "$%.0f - %s\n\t\t\t%s%i%%\t(%i%%) RESTRICTED - $%s %s",
						t_up_cost, buf,
						plus_sign, RoundFloat(tmp_ratio * 100 * times), RoundFloat(tmp_val * 100), GetAlphabetForm(upgrades_requirement[tmp_up_idx]),
						canBypassRestriction[client] == true ? "swagged" : "")
					itemDisabled = true;
					attributeDisabled[tmp_up_idx] = true;
				}
				else
				{
					Format(desc_str, sizeof(desc_str), "$%.0f - %s\n\t\t\t%s%i%%\t(%i%%)",
						t_up_cost, buf,
						plus_sign, RoundFloat(tmp_ratio * 100 * times), (RoundFloat(tmp_val * 100)))
				}
			}
			else
			{
				if(RoundFloat(val*100.0)/100.0 == upgrades_m_val[tmp_up_idx])
				{
					Format(desc_str, sizeof(desc_str), "$%.0f - %s\n\t\t\t%s%3.1f\t(%.1f) MAXED %s",
						t_up_cost, buf,
						plus_sign, tmp_ratio * times, tmp_val,
						canBypassRestriction[client] == true ? "swagged" : "")
					itemDisabled = true
					attributeDisabled[tmp_up_idx] = true;
				}
				else if(upgrades_restriction_category[tmp_up_idx] != 0 && (val == 0.0 || val - upgrades_i_val[tmp_up_idx] == 0.0))
				{
					for(int it = 0;it<5;it++)
					{
						if(currentupgrades_restriction[client][slot][it] == upgrades_restriction_category[tmp_up_idx])
						{
							Format(desc_str, sizeof(desc_str), "$%.0f - %s\n\t\t\t%s%3.1f\t(%.1f) RESTRICTED %s",
								t_up_cost, buf,
								plus_sign, RoundFloat(tmp_ratio * 100 * times), (RoundFloat(tmp_val * 100)),
								canBypassRestriction[client] == true ? "swagged" : "")
							itemDisabled = true;
							attributeDisabled[tmp_up_idx] = true;
						}
					}
					if(!itemDisabled)
					{
						Format(desc_str, sizeof(desc_str), "$%.0f - %s\n\t\t\t%s%3.1f\t(%.1f)",
							t_up_cost, buf,
							plus_sign, tmp_ratio * times, tmp_val)
					}
				}
				else if(upgrades_requirement[tmp_up_idx] > StartMoney + additionalstartmoney)
				{
					Format(desc_str, sizeof(desc_str), "$%.0f - %s\n\t\t\t%s%3.1f\t(%.1f) RESTRICTED - $%s %s",
						t_up_cost, buf,
						plus_sign, tmp_ratio * times, tmp_val, GetAlphabetForm(upgrades_requirement[tmp_up_idx]),
						canBypassRestriction[client] == true ? "swagged" : "")
					itemDisabled = true
					attributeDisabled[tmp_up_idx] = true;
				}
				else
				{
					Format(desc_str, sizeof(desc_str), "$%.0f - %s\n\t\t\t%s%3.1f\t(%.1f)",
						t_up_cost, buf,
						plus_sign, tmp_ratio * times, tmp_val)
				}
			}
			if(canBypassRestriction[client]){ attributeDisabled[tmp_up_idx] = false; itemDisabled = false;}
			if(!itemDisabled)
			{
				switch(upgrades_display_style[tmp_up_idx])
				{
					case 1:
					{
						if(val == 0.0)
							val = upgrades_i_val[tmp_up_idx];
						upgrades_efficiency[client][slot][tmp_up_idx] = 50000.0*(((val+upgrades_ratio[tmp_up_idx])/val)-1.0)/up_cost;
					}
					case 6:
					{
						if(val == 0.0)
							val = upgrades_i_val[tmp_up_idx];
						upgrades_efficiency[client][slot][tmp_up_idx] = 50000.0*(0.05)/up_cost;
					}
					case 2:
					{
						if(val == 0.0)
							val = upgrades_i_val[tmp_up_idx];
						float delta = (GetResistance(client, true, upgrades_ratio[tmp_up_idx])) - (GetResistance(client, true));
						upgrades_efficiency[client][slot][tmp_up_idx] = 50000.0*(delta)/up_cost;
					}
					case 3:
					{
						if(val == 0.0)
							val = upgrades_i_val[tmp_up_idx];
						float delta = (GetResistance(client, true, 0.0, upgrades_ratio[tmp_up_idx])) - (GetResistance(client, true));
						upgrades_efficiency[client][slot][tmp_up_idx] = 50000.0*(delta)/up_cost;
					}
					case 4:
					{
						float arcanePower = 1.0;
						
						Address ArcaneActive = TF2Attrib_GetByName(client, "arcane power")
						if(ArcaneActive != Address_Null)
						{
							arcanePower = TF2Attrib_GetValue(ArcaneActive);
						}
						
						float arcaneDamageMult = 1.0;

						Address ArcaneDamageActive = TF2Attrib_GetByName(client, "arcane damage")
						if(ArcaneDamageActive != Address_Null)
						{
							arcaneDamageMult = TF2Attrib_GetValue(ArcaneDamageActive);
						}

						float delta = Pow((arcaneDamageMult+upgrades_ratio[tmp_up_idx]) * Pow(arcanePower, 4.0), 2.45) - Pow(arcaneDamageMult * Pow(arcanePower, 4.0), 2.45);
						Format(desc_str, sizeof(desc_str), "%s (+%.1f)", desc_str, delta);
					}
					case 5:
					{
						float arcanePower = 1.0;
						
						Address ArcaneActive = TF2Attrib_GetByName(client, "arcane power")
						if(ArcaneActive != Address_Null)
						{
							arcanePower = TF2Attrib_GetValue(ArcaneActive);
						}
						
						float arcaneDamageMult = 1.0;

						Address ArcaneDamageActive = TF2Attrib_GetByName(client, "arcane damage")
						if(ArcaneDamageActive != Address_Null)
						{
							arcaneDamageMult = TF2Attrib_GetValue(ArcaneDamageActive);
						}

						float delta = Pow(arcaneDamageMult * Pow(arcanePower+upgrades_ratio[tmp_up_idx], 4.0), 2.45) - Pow(arcaneDamageMult * Pow(arcanePower, 4.0), 2.45);
						Format(desc_str, sizeof(desc_str), "%s (+%.1f)", desc_str, delta);
					}
				}
			}
			AddMenuItem(menu, "upgrade", desc_str);
		}
		if(efficiencyCalculationTimer[client] <= 0.0)
		{
			int numEff = 0;
			for(int e=0;e<MAX_ATTRIBUTES;e++)
			{
				if(upgrades_efficiency[client][slot][e])
				{
					numEff++;
				}
			}
			float max = 0.0;
			int highestIndex = 0;
			bool toBlock[MAX_ATTRIBUTES];
			for(int k=0;k<numEff;k++) 
			{
				for(int t=0;t<MAX_ATTRIBUTES;t++)
				{
					if(!toBlock[t] && upgrades_efficiency[client][slot][t])
					{
						if(upgrades_efficiency[client][slot][t] > max)
						{
							max = upgrades_efficiency[client][slot][t]
							highestIndex = t;
						}
					}
					if(attributeDisabled[t])
					{
						upgrades_efficiency_list[client][slot][t] = 0;
						upgrades_efficiency[client][slot][t] = 0.0;
					}
				}
				max = 0.0;
				toBlock[highestIndex] = true;
				//PrintToServer("%i | %.2f | %s", k, upgrades_efficiency[client][slot][highestIndex], toBlock[highestIndex] ? "blocked" : "unblocked")
				upgrades_efficiency_list[client][slot][highestIndex] = k+1;
			}
			efficiencyCalculationTimer[client] = 0.03;
		}
		SetMenuTitle(menu, TitleStr);
		SetMenuExitBackButton(menu, true);
		DisplayMenuAtItem(menu, client, page, MENU_TIME_FOREVER)
	}
}
//Category Selection
public Action:Menu_ChooseCategory(client, char[] TitleStr)
{
	int w_id
	
	Handle menu = CreateMenu(MenuHandler_Choosecat);
	int slot = current_slot_used[client];
	if (slot != 4)
	{
		w_id = currentitem_catidx[client][slot];
	}
	else
	{
		w_id = _:TF2_GetPlayerClass(client) - 1;
		if(w_id < 0)
		{
			w_id = 0;
		}
	}
	if (w_id >= -1)
	{
		current_w_list_id[client] = w_id
		char buf[128]
		for (int i = 0; i < given_upgrd_list_nb[w_id] <= 10 ; i++)
		{
			Format(buf, sizeof(buf), "%T", given_upgrd_classnames[w_id][i], client)
			AddMenuItem(menu, "upgrade", buf);
		}
	}
	SetMenuTitle(menu, TitleStr);
	SetMenuExitBackButton(menu, true);
	if (IsValidClient(client) && IsPlayerAlive(client))
	{
		DisplayMenu(menu, client, 20);
	}
}
//Subcategory Selection
public Action:Menu_ChooseSubcat(client, subcat_choice, const char[] TitleStr)
{
	int w_id = current_w_list_id[client];
	int slot = current_slot_used[client];
	int cat_id = currentitem_catidx[client][slot]
	Handle menu = CreateMenu(MenuHandler_ChooseSubcat);
	if (w_id >= -1)
	{
		current_w_sc_list_id[client] = subcat_choice;
		char buf[128]

		for(int j = 0; j < given_upgrd_subcat_nb[w_id][subcat_choice];j++)
		{
			//PrintToServer("%s", given_upgrd_subclassnames[w_id][j])
			Format(buf, sizeof(buf), "%T", given_upgrd_subclassnames[cat_id][subcat_choice][j], client);
			AddMenuItem(menu, "subcat", buf);
		}
	}
	SetMenuTitle(menu, TitleStr);
	SetMenuExitBackButton(menu, true);
	if (IsValidClient(client) && IsPlayerAlive(client))
	{
		DisplayMenu(menu, client, 20);
	}
}
//Tweak menu
public Action:Menu_SpecialUpgradeChoice(client, cat_choice, char[] TitleStr, selectidx)
{
	int i, j
	Handle menu = CreateMenu(MenuHandler_SpecialUpgradeChoice);
	SetMenuPagination(menu, 2);
	SetMenuExitBackButton(menu, true);
	
	if (cat_choice != -1)
	{
		char desc_str[512]
		int w_id = current_w_list_id[client]
		int tmp_up_idx
		int tmp_spe_up_idx
		int tmp_ref_idx
		float tmp_val
		float tmp_ratio
		int slot
		char plus_sign[4]
		char buft[256]
	
		current_w_c_list_id[client] = cat_choice
		slot = current_slot_used[client]
		for (i = 0; i < given_upgrd_classnames_tweak_nb[w_id]; i++)
		{
			tmp_spe_up_idx = given_upgrd_list[w_id][cat_choice][0][i]
			Format(buft, sizeof(buft), "%T",  upgrades_tweaks[tmp_spe_up_idx], client);
			if(upgrades_tweaks_cost[tmp_spe_up_idx] > 0.0)
			{
				Format(buft, sizeof(buft), "%s\nCost: $%.0f",  buft, upgrades_tweaks_cost[tmp_spe_up_idx])
			}
			if(upgrades_tweaks_requirement[tmp_spe_up_idx] > 0.0)
			{
				Format(buft, sizeof(buft), "%s\nRequirement: $%.0f spent",  buft, upgrades_tweaks_requirement[tmp_spe_up_idx])
			}
			desc_str = buft;
			for (j = 0; j < upgrades_tweaks_nb_att[tmp_spe_up_idx]; j++)
			{
				tmp_up_idx = upgrades_tweaks_att_idx[tmp_spe_up_idx][j]
				tmp_ref_idx = upgrades_ref_to_idx[client][slot][tmp_up_idx]
				if (tmp_ref_idx != 20000)
				{	
					tmp_val = currentupgrades_val[client][slot][tmp_ref_idx] - upgrades_i_val[tmp_up_idx]
				}
				else
				{
					tmp_val = 0.0
				}
				tmp_ratio = upgrades_ratio[tmp_up_idx]
				if (tmp_ratio > 0.0)
				{
					plus_sign = "+"
				}
				else
				{
					tmp_ratio *= -1.0
					plus_sign = "-"
				}
				char buf[256]
				Format(buf, sizeof(buf), "%T", upgradesNames[tmp_up_idx], client)
				if (tmp_ratio < 0.99)
				{
					tmp_ratio *= upgrades_tweaks_att_ratio[tmp_spe_up_idx][j]
					Format(desc_str, sizeof(desc_str), "%s\n%\t-%s\n\t\t\t%s%i%%\t(%i%%)",
						desc_str, buf,
						plus_sign, RoundFloat(tmp_ratio * 100), RoundFloat(tmp_val * 100))
				}
				else
				{
					tmp_ratio *= upgrades_tweaks_att_ratio[tmp_spe_up_idx][j]
					Format(desc_str, sizeof(desc_str), "%s\n\t-%s\n\t\t\t%s%3.1f\t(%.1f)",
						desc_str, buf,
						plus_sign, tmp_ratio, tmp_val)
				}
			}
			AddMenuItem(menu, "upgrade", desc_str);
		}
	}
	else{
	CloseHandle(menu);
	}
	SetMenuTitle(menu, TitleStr);
	DisplayMenuAtItem(menu, client, selectidx, MENU_TIME_FOREVER);

	return; 
}
public	Menu_TweakUpgrades_slot(client, arg, page)
{
	if (arg > -1 && arg < 5
	&& IsValidClient(client) 
	&& IsPlayerAlive(client))
	{
		Handle menu = CreateMenu(MenuHandler_AttributesTweak_action);
		int i, s
			
		s = arg;
		current_slot_used[client] = s;
		SetMenuTitle(menu, "$%.0f ***%s - Choose attribute:", CurrencyOwned[client], current_slot_name[s]);
		char buf[256]
		char fstr[512]
		if(currentupgrades_number[client][s] != 0)
		{
			for (i = 0; i < currentupgrades_number[client][s]; i++)
			{
				int u = currentupgrades_idx[client][s][i]
				Format(buf, sizeof(buf), "%T", upgradesNames[u], client)
				if (upgrades_costs[u] < -0.1)
				{
					int nb_time_upgraded = RoundToNearest((upgrades_i_val[u] - currentupgrades_val[client][s][i]) / upgrades_ratio[u])
					float up_cost = upgrades_costs[u] * nb_time_upgraded * 3.0
					if(up_cost > 200.0)
					{
						Format(fstr, sizeof(fstr), "[%s] :\n\t\t%10.2f\n%.0f", buf, RoundFloat(currentupgrades_val[client][s][i]*100.0)/100.0,up_cost)
					}
					else
					{
						Format(fstr, sizeof(fstr), "[%s] :\n\t\t%10.2f", buf, RoundFloat(currentupgrades_val[client][s][i]*100.0)/100.0)
					}
				}
				else if (upgrades_costs[u] > 1.0)
				{
					int nb_time_upgraded;
					if(currentupgrades_i[client][s][i] != 0.0)
					{
						nb_time_upgraded = RoundToNearest((currentupgrades_i[client][s][i] - currentupgrades_val[client][s][i]) / upgrades_ratio[u])
					}
					else
					{
						nb_time_upgraded = RoundToNearest((upgrades_i_val[u] - currentupgrades_val[client][s][i]) / upgrades_ratio[u])
					}
					nb_time_upgraded *= -1
					float up_cost = ((upgrades_costs[u]+((upgrades_costs_inc_ratio[u]*upgrades_costs[u])*(nb_time_upgraded-1))/2)*nb_time_upgraded)
					up_cost /= 2
					if(s == 1)
						up_cost *= SecondaryCostReduction;
						
					if(up_cost > 200.0)
					{
						Format(fstr, sizeof(fstr), "[%s] :\n\t\t%10.2f\n+%.0f", buf, RoundFloat(currentupgrades_val[client][s][i]*100.0)/100.0,up_cost)
					}
					else
					{
						Format(fstr, sizeof(fstr), "[%s] :\n\t\t%10.2f", buf, RoundFloat(currentupgrades_val[client][s][i]*100.0)/100.0)
					}
				}
				else
				{
					Format(fstr, sizeof(fstr), "[%s] :\n\t\t%10.2f", buf, RoundFloat(currentupgrades_val[client][s][i]*100.0)/100.0)
				}
				AddMenuItem(menu, "yep", fstr);
			}
			if (IsValidClient(client) && IsPlayerAlive(client))
			{
				DisplayMenu(menu, client, 20);
			}
			DisplayMenuAtItem(menu, client, page, MENU_TIME_FOREVER);
		}
		else
		{
			PrintToChat(client, "This weapon has no changeable attributes.");
			CloseHandle(menu);
			Menu_TweakUpgrades(client);
		}
	}
}
public Menu_TweakUpgrades(client)
{
	Handle menu = CreateMenu(MenuHandler_AttributesTweak);
	int s
	
	SetMenuExitBackButton(menu, true);
	
	SetMenuTitle(menu, "Display Upgrades Or Remove downgrades");
	for (s = 0; s < 5; s++)
	{
		char fstr[100]
		
		Format(fstr, sizeof(fstr), "$%.0f of upgrades | Refund & Remove my %s attributes", client_spent_money[client][s], current_slot_name[s])
		AddMenuItem(menu, "tweak", fstr);
	}
	if (IsValidClient(client) && IsPlayerAlive(client))
	{
		DisplayMenu(menu, client, MENU_TIME_FOREVER);
	}
	return;
}
public Menu_ChangePreferences(client)
{
	if (IsValidClient(client) && IsPlayerAlive(client))
	{
		Handle menu = CreateMenu(MenuHandler_Preferences);
		
		SetMenuExitBackButton(menu, true);
		SetMenuTitle(menu, "Set Preferences");
		AddMenuItem(menu, "increaseX", "+1 X to armor hud.");
		AddMenuItem(menu, "decreaseX", "-1 X to armor hud.");
		AddMenuItem(menu, "increaseY", "+1 Y to armor hud.");
		AddMenuItem(menu, "decreaseY", "-1 Y to armor hud.");
		AddMenuItem(menu, "ifrespawn", "Toggle buy menu on spawn.");
		AddMenuItem(menu, "particleToggle", "Toggle Self-Viewable Particles");
		AddMenuItem(menu, "resetTutorial", "Reset all tutorial HUD elements.");
		if (IsValidClient(client) && IsPlayerAlive(client))
		{
			DisplayMenu(menu, client, MENU_TIME_FOREVER);
		}
	}
}
Menu_ShowWiki(client, int item = 0)
{
	if (IsValidClient(client) && IsPlayerAlive(client))
	{
		Handle menu = CreateMenu(MenuHandler_Wiki);
		
		SetMenuExitBackButton(menu, true);
		SetMenuTitle(menu, "??? Incremental Fortress Wiki ???");
		AddMenuItem(menu, "UpgradeInfo", "Upgrades Walkthrough");
		AddMenuItem(menu, "DamageInfo", "Damage Math Walkthrough");
		AddMenuItem(menu, "ArmorInfo", "Armor Math Walkthrough");
		AddMenuItem(menu, "SpecialTweaksInfo", "Special Tweaks Walkthrough");
		AddMenuItem(menu, "SpecialAbilitiesInfo", "Special Abilities Explanation #1");
		AddMenuItem(menu, "SpecialAbilitiesInfo2", "Special Abilities Explanation #2");
		AddMenuItem(menu, "ArcaneInfo", "Arcane Walkthrough");
		AddMenuItem(menu, "ArcaneInfo2", "Arcane Spells #1");
		AddMenuItem(menu, "ArcaneInfo2", "Arcane Spells #2");
		AddMenuItem(menu, "ArcaneInfo3", "Class Specific Arcanes #1");
		AddMenuItem(menu, "ArcaneInfo4", "Class Specific Arcanes #2");
		if (IsValidClient(client) && IsPlayerAlive(client))
		{
			DisplayMenuAtItem(menu, client, item, MENU_TIME_FOREVER);
		}
	}
}
public Action:ShowMults(client, args)
{
	if(IsPlayerAlive(client))
	{
		Menu_ShowStatsMenu(client);
	}
	return Plugin_Handled;
}
public Menu_ShowStatsMenu(client)
{
	Handle menu = CreateMenu(MenuHandler_StatsViewer);
	SetMenuExitBackButton(menu, true);
	SetMenuTitle(menu, "Display weapon stats by slot.");
	AddMenuItem(menu, "slot", "View stats for body");
	AddMenuItem(menu, "slot", "View stats for primary");
	AddMenuItem(menu, "slot", "View stats for secondary");
	AddMenuItem(menu, "slot", "View stats for melee");
	
	if (currentitem_level[client][3] == 242)
	{
		AddMenuItem(menu, "slot", "View stats for bought weapon");
	}
	
	if (IsValidClient(client) && IsPlayerAlive(client))
	{
		DisplayMenu(menu, client, 20);
	}
	return;
}
public Menu_ShowStats(client)
{
	if (IsValidClient(client) && IsPlayerAlive(client))
	{
		ClientCommand(client, "sm_stats");
	}
	return;
}
public CreateBuyNewWeaponMenu(client)
{
	Handle BuyNWmenu = CreateMenu(MenuHandler_ConfirmNewWeapon);
	
	SetMenuTitle(BuyNWmenu, "Buy A Custom Weapon:");
	SetMenuExitBackButton(BuyNWmenu, true);
	int i = 0;
	int it = 0;
	char strTotal[64];
	char playerClass[16]
	switch(current_class[client])
	{
		case TFClass_Scout:
		{
			playerClass = "scout"
		}
		case TFClass_Soldier:
		{
			playerClass = "soldier"
		}
		case TFClass_Pyro:
		{
			playerClass = "pyro"
		}
		case TFClass_DemoMan:
		{
			playerClass = "demo"
		}
		case TFClass_Heavy:
		{
			playerClass = "heavy"
		}
		case TFClass_Engineer:
		{
			playerClass = "engineer"
		}
		case TFClass_Medic:
		{
			playerClass = "medic"
		}
		case TFClass_Sniper:
		{
			playerClass = "sniper"
		}
		case TFClass_Spy:
		{
			playerClass = "spy"
		}
	}
	for (i = 0; i < upgrades_weapon_nb; i++)
	{
		if(StrContains(upgrades_weapon_class_restrictions[i],playerClass) != -1 || StrEqual(upgrades_weapon_class_restrictions[i],"none",false))
		{
			Format(strTotal, sizeof(strTotal), "%s | $%.0f",upgrades_weapon[i],upgrades_weapon_cost[i]); 
			AddMenuItem(BuyNWmenu, "tweak", strTotal);
			buyableIndexOffParam[client][it] = i
			it++
		}
	}
	if(it == 0)
	{
		PrintToChat(client,"There aren't any custom weapons for this class yet.")
	}
	if (IsValidClient(client) && IsPlayerAlive(client))
	{
		DisplayMenu(BuyNWmenu, client, 20);
	}
}