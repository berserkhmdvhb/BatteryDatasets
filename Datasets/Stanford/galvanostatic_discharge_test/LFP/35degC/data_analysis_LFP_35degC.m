close all
clc


%% LOAD BATTERY CHEMISTRY MANUFACTURER SPECIFICATIONS

%Function call - Addpath to the current folder to load vehicles data
load_data_ESS();

%Load vehicles parameters from excel file
ESS_technical_data = readtable('manufactuer_specifications.xlsx');
%Assign name for the table rows
ESS_names = ESS_technical_data.Name;
ESS_technical_data.Properties.RowNames = ESS_names;


%% COLOR DEFINITION

%Color linked to each C-rates
color_c_rate1 = [0.7700    0.7700    0.7700];
color_c_rate2 = [0.3020    0.3020    0.3020];
color_c_rate3 = [0    0.4078    0.6784];
color_c_rate4 = [0.0235    0.2314    0.3686];
color_c_rate5 = [0.5294     0    0.0980];
color_c_rate6 = [0.9490    0.4196    0.1882];
color_c_rate7 = [0.2627    0.5490    0.0549];
color_c_rate8 = [0.2627    0.5490    0.5549];

%Color linked to the selected chemistry under the considered temperature
color_LFP35degC = [0.0235    0.2314    0.3686];


%% LOAD RAW DATA

%Datasets related to cell sample #1
Filename_k1_LFP35degC = {'LFP_k1_0_05C_35degC',...
                         'LFP_k1_1C_35degC',...
                         'LFP_k1_2C_35degC',...
                         'LFP_k1_3C_35degC',...
                         'LFP_k1_5C_35degC',...
                         'LFP_k1_10C_35degC',...
                         'LFP_k1_15C_35degC',...
                         'LFP_k1_20C_35degC'};
%Datasets related to cell sample #2                     
Filename_k2_LFP35degC = {'LFP_k2_0_05C_35degC',...
                         'LFP_k2_1C_35degC',...
                         'LFP_k2_2C_35degC',...
                         'LFP_k2_3C_35degC',...
                         'LFP_k2_5C_35degC',...
                         'LFP_k2_10C_35degC',...
                         'LFP_k2_15C_35degC',...
                         'LFP_k2_20C_35degC'};
%Datasets related to cell sample #3                     
Filename_k3_LFP35degC = {'LFP_k3_0_05C_35degC',...
                         'LFP_k3_1C_35degC',...
                         'LFP_k3_2C_35degC',...
                         'LFP_k3_3C_35degC',...
                         'LFP_k3_5C_35degC',...
                         'LFP_k3_10C_35degC',...
                         'LFP_k3_15C_35degC',...
                         'LFP_k3_20C_35degC'};
%Datasets related to cell sample #4                     
Filename_k4_LFP35degC = {'LFP_k4_0_05C_35degC',...
                         'LFP_k4_1C_35degC',...
                         'LFP_k4_2C_35degC',...
                         'LFP_k4_3C_35degC',...
                         'LFP_k4_5C_35degC',...
                         'LFP_k4_10C_35degC',...
                         'LFP_k4_15C_35degC',...
                         'LFP_k4_20C_35degC'};                  
%Datasets related to cell sample #5
Filename_k5_LFP35degC = {'LFP_k5_0_05C_35degC',...
                         'LFP_k5_1C_35degC',...
                         'LFP_k5_2C_35degC',...
                         'LFP_k5_3C_35degC',...
                         'LFP_k5_5C_35degC',...
                         'LFP_k5_10C_35degC',...
                         'LFP_k5_15C_35degC',...
                         'LFP_k5_20C_35degC'};
%Datasets related to cell sample #6                     
Filename_k6_LFP35degC = {'LFP_k6_0_05C_35degC',...
                         'LFP_k6_1C_35degC',...
                         'LFP_k6_2C_35degC',...
                         'LFP_k6_3C_35degC',...
                         'LFP_k6_5C_35degC',...
                         'LFP_k6_10C_35degC',...
                         'LFP_k6_15C_35degC',...
                         'LFP_k6_20C_35degC'};

%Define C-rate tested for the considered chemistry                     
C_rate_vec_LFP35degC = [{'0.05C'},{'1C'},{'2C'},{'3C'},{'5C'},{'10C'},{'15C'},{'20C'}];               

%-------------------------------------------------------------------------%        
%-------------------------------------------------------------------------%
%Each worksheet containing collected data has the following columns:
time_col = 2; %Time column
step_index_col = 3; %Step index column
voltage_col = 4; %Voltage column
current_col = 5; %Current column
T_surf_col = 6; %Cell surface temperature

%-------------------------------------------------------------------------%
%Cell 1
%-------------------------------------------------------------------------%
%Extract data from the slowest C-rate experiment (n = 1)
[curr,~,~] = xlsread(Filename_k1_LFP35degC{1},1);
%Initialize signal matrix
t_full_vec_k1_LFP35degC = zeros(length(curr(:,time_col)),length(Filename_k1_LFP35degC));
Step_Index_full_vec_k1_LFP35degC = zeros(length(curr(:,time_col)),length(Filename_k1_LFP35degC));
I_full_vec_k1_LFP35degC = zeros(length(curr(:,time_col)),length(Filename_k1_LFP35degC));
V_full_vec_k1_LFP35degC = zeros(length(curr(:,time_col)),length(Filename_k1_LFP35degC));
surf_temp_full_vec_k1_LFP35degC = zeros(length(curr(:,time_col)),length(Filename_k1_LFP35degC));
%Read each .xls file and extract data in Matlab Workspace  
for n = 1:length(Filename_k1_LFP35degC)    
        
        %Get .xls file worksheet names
        [~,sheets] = xlsfinfo(Filename_k1_LFP35degC{n});
        %Read data from curr worksheet
        [num, curr_txt, curr_raw] = xlsread(Filename_k1_LFP35degC{n},1);
               
        %Time vector [s]
        t_full_vec_k1_LFP35degC(1:length(num(:,time_col)),n) = num(:,time_col);
        %Step index vector [-]
        Step_Index_full_vec_k1_LFP35degC(1:length(num(:,step_index_col)),n) = num(:,step_index_col);
        %Current vector [A]
        I_full_vec_k1_LFP35degC(1:length(num(:,current_col)),n) = - num(:,current_col);
        %Voltage vector [V]
        V_full_vec_k1_LFP35degC(1:length(num(:,voltage_col)),n) = num(:,voltage_col); 
        %Cell surface temperature vector [°C]
        surf_temp_full_vec_k1_LFP35degC(1:length(num(:,T_surf_col)),n) = num(:,T_surf_col); 
        
end
%-------------------------------------------------------------------------%
%Cell 2
%-------------------------------------------------------------------------%
%Extract data from the slowest C-rate experiment (n = 1)
[curr,~,~] = xlsread(Filename_k2_LFP35degC{1},1);
%Initialize signal matrix
t_full_vec_k2_LFP35degC = zeros(length(curr(:,time_col)),length(Filename_k2_LFP35degC));
Step_Index_full_vec_k2_LFP35degC = zeros(length(curr(:,time_col)),length(Filename_k2_LFP35degC));
I_full_vec_k2_LFP35degC = zeros(length(curr(:,time_col)),length(Filename_k2_LFP35degC));
V_full_vec_k2_LFP35degC = zeros(length(curr(:,time_col)),length(Filename_k2_LFP35degC));
surf_temp_full_vec_k2_LFP35degC = zeros(length(curr(:,time_col)),length(Filename_k2_LFP35degC));
%Read each .xls file and extract data in Matlab Workspace  
for n = 1:length(Filename_k2_LFP35degC)    
        
        %Get .xls file worksheet names
        [~,sheets] = xlsfinfo(Filename_k2_LFP35degC{n});
        %Read data from curr worksheet
        [num, curr_txt, curr_raw] = xlsread(Filename_k2_LFP35degC{n},1);
               
        %Time vector [s]
        t_full_vec_k2_LFP35degC(1:length(num(:,time_col)),n) = num(:,time_col);
        %Step index vector [-]
        Step_Index_full_vec_k2_LFP35degC(1:length(num(:,step_index_col)),n) = num(:,step_index_col);
        %Current vector [A]
        I_full_vec_k2_LFP35degC(1:length(num(:,current_col)),n) = - num(:,current_col);
        %Voltage vector [V]
        V_full_vec_k2_LFP35degC(1:length(num(:,voltage_col)),n) = num(:,voltage_col); 
        %Cell surface temperature vector [°C]
        surf_temp_full_vec_k2_LFP35degC(1:length(num(:,T_surf_col)),n) = num(:,T_surf_col); 
        
end
%-------------------------------------------------------------------------%
%Cell 3
%-------------------------------------------------------------------------%
%Extract data from the slowest C-rate experiment (n = 1)
[curr,~,~] = xlsread(Filename_k3_LFP35degC{1},1);
%Initialize signal matrix
t_full_vec_k3_LFP35degC = zeros(length(curr(:,time_col)),length(Filename_k3_LFP35degC));
Step_Index_full_vec_k3_LFP35degC = zeros(length(curr(:,time_col)),length(Filename_k3_LFP35degC));
I_full_vec_k3_LFP35degC = zeros(length(curr(:,time_col)),length(Filename_k3_LFP35degC));
V_full_vec_k3_LFP35degC = zeros(length(curr(:,time_col)),length(Filename_k3_LFP35degC));
surf_temp_full_vec_k3_LFP35degC = zeros(length(curr(:,time_col)),length(Filename_k3_LFP35degC));
%Read each .xls file and extract data in Matlab Workspace  
for n = 1:length(Filename_k3_LFP35degC)    
        
        %Get .xls file worksheet names
        [~,sheets] = xlsfinfo(Filename_k3_LFP35degC{n});
        %Read data from curr worksheet
        [num, curr_txt, curr_raw] = xlsread(Filename_k3_LFP35degC{n},1);
               
        %Time vector [s]
        t_full_vec_k3_LFP35degC(1:length(num(:,time_col)),n) = num(:,time_col);
        %Step index vector [-]
        Step_Index_full_vec_k3_LFP35degC(1:length(num(:,step_index_col)),n) = num(:,step_index_col);
        %Current vector [A]
        I_full_vec_k3_LFP35degC(1:length(num(:,current_col)),n) = - num(:,current_col);
        %Voltage vector [V]
        V_full_vec_k3_LFP35degC(1:length(num(:,voltage_col)),n) = num(:,voltage_col); 
        %Cell surface temperature vector [°C]
        surf_temp_full_vec_k3_LFP35degC(1:length(num(:,T_surf_col)),n) = num(:,T_surf_col); 
        
end
%-------------------------------------------------------------------------%
%Cell 4
%-------------------------------------------------------------------------%
%Extract data from the slowest C-rate experiment (n = 1)
[curr,~,~] = xlsread(Filename_k4_LFP35degC{1},1);
%Initialize signal matrix
t_full_vec_k4_LFP35degC = zeros(length(curr(:,time_col)),length(Filename_k4_LFP35degC));
Step_Index_full_vec_k4_LFP35degC = zeros(length(curr(:,time_col)),length(Filename_k4_LFP35degC));
I_full_vec_k4_LFP35degC = zeros(length(curr(:,time_col)),length(Filename_k4_LFP35degC));
V_full_vec_k4_LFP35degC = zeros(length(curr(:,time_col)),length(Filename_k4_LFP35degC));
surf_temp_full_vec_k4_LFP35degC = zeros(length(curr(:,time_col)),length(Filename_k4_LFP35degC));
%Read each .xls file and extract data in Matlab Workspace  
for n = 1:length(Filename_k4_LFP35degC)    
        
        %Get .xls file worksheet names
        [~,sheets] = xlsfinfo(Filename_k4_LFP35degC{n});
        %Read data from curr worksheet
        [num, curr_txt, curr_raw] = xlsread(Filename_k4_LFP35degC{n},1);
               
        %Time vector [s]
        t_full_vec_k4_LFP35degC(1:length(num(:,time_col)),n) = num(:,time_col);
        %Step index vector [-]
        Step_Index_full_vec_k4_LFP35degC(1:length(num(:,step_index_col)),n) = num(:,step_index_col);
        %Current vector [A]
        I_full_vec_k4_LFP35degC(1:length(num(:,current_col)),n) = - num(:,current_col);
        %Voltage vector [V]
        V_full_vec_k4_LFP35degC(1:length(num(:,voltage_col)),n) = num(:,voltage_col); 
        %Cell surface temperature vector [°C]
        surf_temp_full_vec_k4_LFP35degC(1:length(num(:,T_surf_col)),n) = num(:,T_surf_col); 
        
end
%-------------------------------------------------------------------------%
%Cell 5
%-------------------------------------------------------------------------%
%Extract data from the slowest C-rate experiment (n = 1)
[curr,~,~] = xlsread(Filename_k5_LFP35degC{1},1);
%Initialize signal matrix
t_full_vec_k5_LFP35degC = zeros(length(curr(:,time_col)),length(Filename_k5_LFP35degC));
Step_Index_full_vec_k5_LFP35degC = zeros(length(curr(:,time_col)),length(Filename_k5_LFP35degC));
I_full_vec_k5_LFP35degC = zeros(length(curr(:,time_col)),length(Filename_k5_LFP35degC));
V_full_vec_k5_LFP35degC = zeros(length(curr(:,time_col)),length(Filename_k5_LFP35degC));
surf_temp_full_vec_k5_LFP35degC = zeros(length(curr(:,time_col)),length(Filename_k5_LFP35degC));
%Read each .xls file and extract data in Matlab Workspace  
for n = 1:length(Filename_k5_LFP35degC)    
        
        %Get .xls file worksheet names
        [~,sheets] = xlsfinfo(Filename_k5_LFP35degC{n});
        %Read data from curr worksheet
        [num, curr_txt, curr_raw] = xlsread(Filename_k5_LFP35degC{n},1);
               
        %Time vector [s]
        t_full_vec_k5_LFP35degC(1:length(num(:,time_col)),n) = num(:,time_col);
        %Step index vector [-]
        Step_Index_full_vec_k5_LFP35degC(1:length(num(:,step_index_col)),n) = num(:,step_index_col);
        %Current vector [A]
        I_full_vec_k5_LFP35degC(1:length(num(:,current_col)),n) = - num(:,current_col);
        %Voltage vector [V]
        V_full_vec_k5_LFP35degC(1:length(num(:,voltage_col)),n) = num(:,voltage_col); 
        %Cell surface temperature vector [°C]
        surf_temp_full_vec_k5_LFP35degC(1:length(num(:,T_surf_col)),n) = num(:,T_surf_col); 
        
end
%-------------------------------------------------------------------------%
%Cell 6
%-------------------------------------------------------------------------%
%Extract data from the slowest C-rate experiment (n = 1)
[curr,~,~] = xlsread(Filename_k6_LFP35degC{1},1);
%Initialize signal matrix
t_full_vec_k6_LFP35degC = zeros(length(curr(:,time_col)),length(Filename_k6_LFP35degC));
Step_Index_full_vec_k6_LFP35degC = zeros(length(curr(:,time_col)),length(Filename_k6_LFP35degC));
I_full_vec_k6_LFP35degC = zeros(length(curr(:,time_col)),length(Filename_k6_LFP35degC));
V_full_vec_k6_LFP35degC = zeros(length(curr(:,time_col)),length(Filename_k6_LFP35degC));
surf_temp_full_vec_k6_LFP35degC = zeros(length(curr(:,time_col)),length(Filename_k6_LFP35degC));
%Read each .xls file and extract data in Matlab Workspace  
for n = 1:length(Filename_k6_LFP35degC)    
        
        %Get .xls file worksheet names
        [~,sheets] = xlsfinfo(Filename_k6_LFP35degC{n});
        %Read data from curr worksheet
        [num, curr_txt, curr_raw] = xlsread(Filename_k6_LFP35degC{n},1);
               
        %Time vector [s]
        t_full_vec_k6_LFP35degC(1:length(num(:,time_col)),n) = num(:,time_col);
        %Step index vector [-]
        Step_Index_full_vec_k6_LFP35degC(1:length(num(:,step_index_col)),n) = num(:,step_index_col);
        %Current vector [A]
        I_full_vec_k6_LFP35degC(1:length(num(:,current_col)),n) = - num(:,current_col);
        %Voltage vector [V]
        V_full_vec_k6_LFP35degC(1:length(num(:,voltage_col)),n) = num(:,voltage_col); 
        %Cell surface temperature vector [°C]
        surf_temp_full_vec_k6_LFP35degC(1:length(num(:,T_surf_col)),n) = num(:,T_surf_col); 
        
end

     
%% EXTRACT CONSTANT CURRENT DISCHARGE DATA

%-------------------------------------------------------------------------%        
%-------------------------------------------------------------------------%
%How to recognize when the constant discharge has begun ?
%When the step_index value is equal to 5.
step_index_dis = 5;
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%

%-------------------------------------------------------------------------%
%Cell 1
%-------------------------------------------------------------------------%
%Variables initialization
L_k1_LFP35degC = zeros(1,length(Filename_k1_LFP35degC));
T_Dis_k1_LFP35degC = zeros(max(L_k1_LFP35degC),length(Filename_k1_LFP35degC));
I_Dis_k1_LFP35degC = zeros(max(L_k1_LFP35degC),length(Filename_k1_LFP35degC));
V_Dis_k1_LFP35degC = zeros(max(L_k1_LFP35degC),length(Filename_k1_LFP35degC));
Tsurf_Dis_k1_LFP35degC = zeros(max(L_k1_LFP35degC),length(Filename_k1_LFP35degC));
Energy_k1_LFP35degC = zeros(1,length(Filename_k1_LFP35degC)); 
Energy_spec_k1_LFP35degC = zeros(1,length(Filename_k1_LFP35degC)); 
Power_spec_k1_LFP35degC = zeros(1,length(Filename_k1_LFP35degC)); 
for n = 1:length(Filename_k1_LFP35degC)
    
    %Extract data in the constant discharge interval
    Dis_Index_pre = find(Step_Index_full_vec_k1_LFP35degC(:,n) == step_index_dis);
    Dis_Index = vertcat(Dis_Index_pre(1)-1, Dis_Index_pre);

    %Store the length of data vector for each C-rate
    L_k1_LFP35degC(1,n) = length(Dis_Index);
    
    %Extract time, current and voltage data during constant discharge interval
    T_Dis_k1_LFP35degC(1:L_k1_LFP35degC(1,n),n) = t_full_vec_k1_LFP35degC(Dis_Index,n);
    I_Dis_k1_LFP35degC(1:L_k1_LFP35degC(1,n),n) = I_full_vec_k1_LFP35degC(Dis_Index,n);
    V_Dis_k1_LFP35degC(1:L_k1_LFP35degC(1,n),n) = V_full_vec_k1_LFP35degC(Dis_Index,n);
    Tsurf_Dis_k1_LFP35degC(1:L_k1_LFP35degC(1,n),n) = surf_temp_full_vec_k1_LFP35degC(Dis_Index,n);
    
    %Time vector starting from zero with 1s delta for each data point [s]
    T_Dis_k1_LFP35degC(1:L_k1_LFP35degC(1,n),n) = 0:length(T_Dis_k1_LFP35degC(1:L_k1_LFP35degC(1,n),n))-1;
    
    %Compute total Energy [Wh]
    Energy_k1_LFP35degC(1,n) = trapz(T_Dis_k1_LFP35degC(1:L_k1_LFP35degC(1,n),n), I_Dis_k1_LFP35degC(1:L_k1_LFP35degC(1,n),n).*V_Dis_k1_LFP35degC(1:L_k1_LFP35degC(1,n),n))/3600;
    %Compute Specific Energy [Wh/kg]
    Energy_spec_k1_LFP35degC(1,n) = Energy_k1_LFP35degC(1,n)/ESS_technical_data.Cell_Weight_kg('NCA');
    %Compute Specific Power [W/kg]
    Power_spec_k1_LFP35degC(1,n) = Energy_spec_k1_LFP35degC(1,n)/((T_Dis_k1_LFP35degC(L_k1_LFP35degC(1,n),n) - T_Dis_k1_LFP35degC(1,n))/3600);
    
end
%Replace all 0 values in data with NaN: improve the plot
T_Dis_k1_LFP35degC(T_Dis_k1_LFP35degC(2:end) == 0) = NaN;
V_Dis_k1_LFP35degC(V_Dis_k1_LFP35degC(2:end) == 0) = NaN;
I_Dis_k1_LFP35degC(V_Dis_k1_LFP35degC(2:end) == 0) = NaN;

%-------------------------------------------------------------------------%
%Cell 2
%-------------------------------------------------------------------------%
%Variables initialization
L_k2_LFP35degC = zeros(1,length(Filename_k2_LFP35degC));
T_Dis_k2_LFP35degC = zeros(max(L_k2_LFP35degC),length(Filename_k2_LFP35degC));
I_Dis_k2_LFP35degC = zeros(max(L_k2_LFP35degC),length(Filename_k2_LFP35degC));
V_Dis_k2_LFP35degC = zeros(max(L_k2_LFP35degC),length(Filename_k2_LFP35degC));
Tsurf_Dis_k2_LFP35degC = zeros(max(L_k2_LFP35degC),length(Filename_k2_LFP35degC));
Energy_k2_LFP35degC = zeros(1,length(Filename_k2_LFP35degC)); 
Energy_spec_k2_LFP35degC = zeros(1,length(Filename_k2_LFP35degC)); 
Power_spec_k2_LFP35degC = zeros(1,length(Filename_k2_LFP35degC)); 
for n = 1:length(Filename_k2_LFP35degC)
    
    %Extract data in the constant discharge interval
    Dis_Index_pre = find(Step_Index_full_vec_k2_LFP35degC(:,n) == step_index_dis);
    Dis_Index = vertcat(Dis_Index_pre(1)-1, Dis_Index_pre);
    %Store the length of data vector for each C-rate
    L_k2_LFP35degC(1,n) = length(Dis_Index);
    
    %Extract time, current and voltage data during constant discharge interval
    T_Dis_k2_LFP35degC(1:L_k2_LFP35degC(1,n),n) = t_full_vec_k2_LFP35degC(Dis_Index,n);
    I_Dis_k2_LFP35degC(1:L_k2_LFP35degC(1,n),n) = I_full_vec_k2_LFP35degC(Dis_Index,n);
    V_Dis_k2_LFP35degC(1:L_k2_LFP35degC(1,n),n) = V_full_vec_k2_LFP35degC(Dis_Index,n);
    Tsurf_Dis_k2_LFP35degC(1:L_k2_LFP35degC(1,n),n) = surf_temp_full_vec_k2_LFP35degC(Dis_Index,n);

    %Time vector starting from zero with 1s delta for each data point [s]
    T_Dis_k2_LFP35degC(1:length(t_full_vec_k2_LFP35degC(Dis_Index,n)),n) = 0:length(T_Dis_k2_LFP35degC(1:length(t_full_vec_k2_LFP35degC(Dis_Index,n)),n))-1;

    %Compute total Energy [Wh]
    Energy_k2_LFP35degC(1,n) = trapz(T_Dis_k2_LFP35degC(1:L_k2_LFP35degC(1,n),n), I_Dis_k2_LFP35degC(1:L_k2_LFP35degC(1,n),n).*V_Dis_k2_LFP35degC(1:L_k2_LFP35degC(1,n),n))/3600;
    %Compute Specific Energy [Wh/kg]
    Energy_spec_k2_LFP35degC(1,n) = Energy_k2_LFP35degC(1,n)/ESS_technical_data.Cell_Weight_kg('NCA');
    %Compute Specific Power [W/kg]
    Power_spec_k2_LFP35degC(1,n) = Energy_spec_k2_LFP35degC(1,n)/((T_Dis_k2_LFP35degC(L_k2_LFP35degC(1,n),n) - T_Dis_k2_LFP35degC(1,n))/3600);
    
end
%Replace all 0 values in data with NaN: improve the plot
T_Dis_k2_LFP35degC(T_Dis_k2_LFP35degC(2:end) == 0) = NaN;
V_Dis_k2_LFP35degC(V_Dis_k2_LFP35degC(2:end) == 0) = NaN;
I_Dis_k2_LFP35degC(V_Dis_k2_LFP35degC(2:end) == 0) = NaN;

%-------------------------------------------------------------------------%
%Cell 3
%-------------------------------------------------------------------------%
%Variables initialization
L_k3_LFP35degC = zeros(1,length(Filename_k3_LFP35degC));
T_Dis_k3_LFP35degC = zeros(max(L_k3_LFP35degC),length(Filename_k3_LFP35degC));
I_Dis_k3_LFP35degC = zeros(max(L_k3_LFP35degC),length(Filename_k3_LFP35degC));
V_Dis_k3_LFP35degC = zeros(max(L_k3_LFP35degC),length(Filename_k3_LFP35degC));
Tsurf_Dis_k3_LFP35degC = zeros(max(L_k3_LFP35degC),length(Filename_k3_LFP35degC));
Energy_k3_LFP35degC = zeros(1,length(Filename_k3_LFP35degC)); 
Energy_spec_k3_LFP35degC = zeros(1,length(Filename_k3_LFP35degC)); 
Power_spec_k3_LFP35degC = zeros(1,length(Filename_k3_LFP35degC)); 
for n = 1:length(Filename_k3_LFP35degC)
    
    %Extract data in the constant discharge interval
    Dis_Index_pre = find(Step_Index_full_vec_k3_LFP35degC(:,n) == step_index_dis);
    Dis_Index = vertcat(Dis_Index_pre(1)-1, Dis_Index_pre);
    %Store the length of data vector for each C-rate
    L_k3_LFP35degC(1,n) = length(Dis_Index);
    
    %Extract time, current and voltage data during constant discharge interval
    T_Dis_k3_LFP35degC(1:L_k3_LFP35degC(1,n),n) = t_full_vec_k3_LFP35degC(Dis_Index,n);
    I_Dis_k3_LFP35degC(1:L_k3_LFP35degC(1,n),n) = I_full_vec_k3_LFP35degC(Dis_Index,n);
    V_Dis_k3_LFP35degC(1:L_k3_LFP35degC(1,n),n) = V_full_vec_k3_LFP35degC(Dis_Index,n);
    Tsurf_Dis_k3_LFP35degC(1:L_k3_LFP35degC(1,n),n) = surf_temp_full_vec_k3_LFP35degC(Dis_Index,n);

    %Time vector starting from zero with 1s delta for each data point [s]
    T_Dis_k3_LFP35degC(1:L_k3_LFP35degC(1,n),n) = 0:length(T_Dis_k3_LFP35degC(1:L_k3_LFP35degC(1,n),n))-1;
    
    %Compute total Energy [Wh]
    Energy_k3_LFP35degC(1,n) = trapz(T_Dis_k3_LFP35degC(1:L_k3_LFP35degC(1,n),n), I_Dis_k3_LFP35degC(1:L_k3_LFP35degC(1,n),n).*V_Dis_k3_LFP35degC(1:L_k3_LFP35degC(1,n),n))/3600;
    %Compute Specific Energy [Wh/kg]
    Energy_spec_k3_LFP35degC(1,n) = Energy_k3_LFP35degC(1,n)/ESS_technical_data.Cell_Weight_kg('NCA');
    %Compute Specific Power [W/kg]
    Power_spec_k3_LFP35degC(1,n) = Energy_spec_k3_LFP35degC(1,n)/((T_Dis_k3_LFP35degC(L_k3_LFP35degC(1,n),n) - T_Dis_k3_LFP35degC(1,n))/3600);
    
end
%Replace all 0 values in data with NaN: improve the plot
T_Dis_k3_LFP35degC(T_Dis_k3_LFP35degC(2:end) == 0) = NaN;
V_Dis_k3_LFP35degC(V_Dis_k3_LFP35degC(2:end) == 0) = NaN;
I_Dis_k3_LFP35degC(V_Dis_k3_LFP35degC(2:end) == 0) = NaN;

%-------------------------------------------------------------------------%
%Cell 4
%-------------------------------------------------------------------------%
%Variables initialization
L_k4_LFP35degC = zeros(1,length(Filename_k4_LFP35degC));
T_Dis_k4_LFP35degC = zeros(max(L_k4_LFP35degC),length(Filename_k4_LFP35degC));
I_Dis_k4_LFP35degC = zeros(max(L_k4_LFP35degC),length(Filename_k4_LFP35degC));
V_Dis_k4_LFP35degC = zeros(max(L_k4_LFP35degC),length(Filename_k4_LFP35degC));
Tsurf_Dis_k4_LFP35degC = zeros(max(L_k4_LFP35degC),length(Filename_k4_LFP35degC));
Energy_k4_LFP35degC = zeros(1,length(Filename_k4_LFP35degC)); 
Energy_spec_k4_LFP35degC = zeros(1,length(Filename_k4_LFP35degC)); 
Power_spec_k4_LFP35degC = zeros(1,length(Filename_k4_LFP35degC)); 
for n = 1:length(Filename_k4_LFP35degC)
    
    %Extract data in the constant discharge interval
    Dis_Index_pre = find(Step_Index_full_vec_k4_LFP35degC(:,n) == step_index_dis);
    Dis_Index = vertcat(Dis_Index_pre(1)-1, Dis_Index_pre);
    %Store the length of data vector for each C-rate
    L_k4_LFP35degC(1,n) = length(Dis_Index);
    
    %Extract time, current and voltage data during constant discharge interval
    T_Dis_k4_LFP35degC(1:L_k4_LFP35degC(1,n),n) = t_full_vec_k4_LFP35degC(Dis_Index,n);
    I_Dis_k4_LFP35degC(1:L_k4_LFP35degC(1,n),n) = I_full_vec_k4_LFP35degC(Dis_Index,n);
    V_Dis_k4_LFP35degC(1:L_k4_LFP35degC(1,n),n) = V_full_vec_k4_LFP35degC(Dis_Index,n);
    Tsurf_Dis_k4_LFP35degC(1:L_k4_LFP35degC(1,n),n) = surf_temp_full_vec_k4_LFP35degC(Dis_Index,n);

    %Time vector starting from zero with 1s delta for each data point [s]
    T_Dis_k4_LFP35degC(1:L_k4_LFP35degC(1,n),n) = 0:length(T_Dis_k4_LFP35degC(1:L_k4_LFP35degC(1,n),n))-1;
    
    %Compute total Energy [Wh]
    Energy_k4_LFP35degC(1,n) = trapz(T_Dis_k4_LFP35degC(1:L_k4_LFP35degC(1,n),n), I_Dis_k4_LFP35degC(1:L_k4_LFP35degC(1,n),n).*V_Dis_k4_LFP35degC(1:L_k4_LFP35degC(1,n),n))/3600;
    %Compute Specific Energy [Wh/kg]
    Energy_spec_k4_LFP35degC(1,n) = Energy_k4_LFP35degC(1,n)/ESS_technical_data.Cell_Weight_kg('NCA');
    %Compute Specific Power [W/kg]
    Power_spec_k4_LFP35degC(1,n) = Energy_spec_k4_LFP35degC(1,n)/((T_Dis_k4_LFP35degC(L_k4_LFP35degC(1,n),n) - T_Dis_k4_LFP35degC(1,n))/3600);
    
end
%Replace all 0 values in data with NaN: improve the plot
T_Dis_k4_LFP35degC(T_Dis_k4_LFP35degC(2:end) == 0) = NaN;
V_Dis_k4_LFP35degC(V_Dis_k4_LFP35degC(2:end) == 0) = NaN;
I_Dis_k4_LFP35degC(V_Dis_k4_LFP35degC(2:end) == 0) = NaN;

%-------------------------------------------------------------------------%
%Cell 5
%-------------------------------------------------------------------------%
%Variables initialization
L_k5_LFP35degC = zeros(1,length(Filename_k5_LFP35degC));
T_Dis_k5_LFP35degC = zeros(max(L_k5_LFP35degC),length(Filename_k5_LFP35degC));
I_Dis_k5_LFP35degC = zeros(max(L_k5_LFP35degC),length(Filename_k5_LFP35degC));
V_Dis_k5_LFP35degC = zeros(max(L_k5_LFP35degC),length(Filename_k5_LFP35degC));
Tsurf_Dis_k5_LFP35degC = zeros(max(L_k5_LFP35degC),length(Filename_k5_LFP35degC));
Energy_k5_LFP35degC = zeros(1,length(Filename_k5_LFP35degC)); 
Energy_spec_k5_LFP35degC = zeros(1,length(Filename_k5_LFP35degC)); 
Power_spec_k5_LFP35degC = zeros(1,length(Filename_k5_LFP35degC)); 
for n = 1:length(Filename_k5_LFP35degC)
    
    %Extract data in the constant discharge interval
    Dis_Index_pre = find(Step_Index_full_vec_k5_LFP35degC(:,n) == step_index_dis);
    Dis_Index = vertcat(Dis_Index_pre(1)-1, Dis_Index_pre);
    %Store the length of data vector for each C-rate
    L_k5_LFP35degC(1,n) = length(Dis_Index);
    
    %Extract time, current and voltage data during constant discharge interval
    T_Dis_k5_LFP35degC(1:L_k5_LFP35degC(1,n),n) = t_full_vec_k5_LFP35degC(Dis_Index,n);
    I_Dis_k5_LFP35degC(1:L_k5_LFP35degC(1,n),n) = I_full_vec_k5_LFP35degC(Dis_Index,n);
    V_Dis_k5_LFP35degC(1:L_k5_LFP35degC(1,n),n) = V_full_vec_k5_LFP35degC(Dis_Index,n);
    Tsurf_Dis_k5_LFP35degC(1:L_k5_LFP35degC(1,n),n) = surf_temp_full_vec_k5_LFP35degC(Dis_Index,n);

    %Time vector starting from zero with 1s delta for each data point [s]
    T_Dis_k5_LFP35degC(1:L_k5_LFP35degC(1,n),n) = 0:length(T_Dis_k5_LFP35degC(1:L_k5_LFP35degC(1,n),n))-1;
    
    %Compute total Energy [Wh]
    Energy_k5_LFP35degC(1,n) = trapz(T_Dis_k5_LFP35degC(1:L_k5_LFP35degC(1,n),n), I_Dis_k5_LFP35degC(1:L_k5_LFP35degC(1,n),n).*V_Dis_k5_LFP35degC(1:L_k5_LFP35degC(1,n),n))/3600;
    %Compute Specific Energy [Wh/kg]
    Energy_spec_k5_LFP35degC(1,n) = Energy_k5_LFP35degC(1,n)/ESS_technical_data.Cell_Weight_kg('NCA');
    %Compute Specific Power [W/kg]
    Power_spec_k5_LFP35degC(1,n) = Energy_spec_k5_LFP35degC(1,n)/((T_Dis_k5_LFP35degC(L_k5_LFP35degC(1,n),n) - T_Dis_k5_LFP35degC(1,n))/3600);
    
end
%Replace all 0 values in data with NaN: improve the plot
T_Dis_k5_LFP35degC(T_Dis_k5_LFP35degC(2:end) == 0) = NaN;
V_Dis_k5_LFP35degC(V_Dis_k5_LFP35degC(2:end) == 0) = NaN;
I_Dis_k5_LFP35degC(V_Dis_k5_LFP35degC(2:end) == 0) = NaN;

%-------------------------------------------------------------------------%
%Cell 6
%-------------------------------------------------------------------------%
%Variables initialization
L_k6_LFP35degC = zeros(1,length(Filename_k6_LFP35degC));
T_Dis_k6_LFP35degC = zeros(max(L_k6_LFP35degC),length(Filename_k6_LFP35degC));
I_Dis_k6_LFP35degC = zeros(max(L_k6_LFP35degC),length(Filename_k6_LFP35degC));
V_Dis_k6_LFP35degC = zeros(max(L_k6_LFP35degC),length(Filename_k6_LFP35degC));
Tsurf_Dis_k6_LFP35degC = zeros(max(L_k6_LFP35degC),length(Filename_k6_LFP35degC));
Energy_k6_LFP35degC = zeros(1,length(Filename_k6_LFP35degC)); 
Energy_spec_k6_LFP35degC = zeros(1,length(Filename_k6_LFP35degC)); 
Power_spec_k6_LFP35degC = zeros(1,length(Filename_k6_LFP35degC)); 
for n = 1:length(Filename_k6_LFP35degC)
    
    %Extract data in the constant discharge interval
    Dis_Index_pre = find(Step_Index_full_vec_k6_LFP35degC(:,n) == step_index_dis);
    Dis_Index = vertcat(Dis_Index_pre(1)-1, Dis_Index_pre);
    %Store the length of data vector for each C-rate
    L_k6_LFP35degC(1,n) = length(Dis_Index);
    
    %Extract time, current and voltage data during constant discharge interval
    T_Dis_k6_LFP35degC(1:L_k6_LFP35degC(1,n),n) = t_full_vec_k6_LFP35degC(Dis_Index,n);
    I_Dis_k6_LFP35degC(1:L_k6_LFP35degC(1,n),n) = I_full_vec_k6_LFP35degC(Dis_Index,n);
    V_Dis_k6_LFP35degC(1:L_k6_LFP35degC(1,n),n) = V_full_vec_k6_LFP35degC(Dis_Index,n);
    Tsurf_Dis_k6_LFP35degC(1:L_k6_LFP35degC(1,n),n) = surf_temp_full_vec_k6_LFP35degC(Dis_Index,n);

    %Time vector starting from zero with 1s delta for each data point [s]
    T_Dis_k6_LFP35degC(1:L_k6_LFP35degC(1,n),n) = 0:length(T_Dis_k6_LFP35degC(1:L_k6_LFP35degC(1,n),n))-1;
    
    %Compute total Energy [Wh]
    Energy_k6_LFP35degC(1,n) = trapz(T_Dis_k6_LFP35degC(1:L_k6_LFP35degC(1,n),n), I_Dis_k6_LFP35degC(1:L_k6_LFP35degC(1,n),n).*V_Dis_k6_LFP35degC(1:L_k6_LFP35degC(1,n),n))/3600;
    %Compute Specific Energy [Wh/kg]
    Energy_spec_k6_LFP35degC(1,n) = Energy_k6_LFP35degC(1,n)/ESS_technical_data.Cell_Weight_kg('NCA');
    %Compute Specific Power [W/kg]
    Power_spec_k6_LFP35degC(1,n) = Energy_spec_k6_LFP35degC(1,n)/((T_Dis_k6_LFP35degC(L_k6_LFP35degC(1,n),n) - T_Dis_k6_LFP35degC(1,n))/3600);
    
end
%Replace all 0 values in data with NaN: improve the plot
T_Dis_k6_LFP35degC(T_Dis_k6_LFP35degC(2:end) == 0) = NaN;
V_Dis_k6_LFP35degC(V_Dis_k6_LFP35degC(2:end) == 0) = NaN;
I_Dis_k6_LFP35degC(V_Dis_k6_LFP35degC(2:end) == 0) = NaN;


%% PLOT VOLTAGE VS. TIME

figure;
hold on;
% Cell 1
c_rate1 = plot(T_Dis_k1_LFP35degC(:,1)/3600,V_Dis_k1_LFP35degC(:,1),'Color',color_c_rate1,'Linewidth',4);
c_rate2 = plot(T_Dis_k1_LFP35degC(:,2)/3600,V_Dis_k1_LFP35degC(:,2),'Color',color_c_rate2,'Linewidth',4);
c_rate3 = plot(T_Dis_k1_LFP35degC(:,3)/3600,V_Dis_k1_LFP35degC(:,3),'Color',color_c_rate3,'Linewidth',4);
c_rate4 = plot(T_Dis_k1_LFP35degC(:,4)/3600,V_Dis_k1_LFP35degC(:,4),'Color',color_c_rate4,'Linewidth',4);
c_rate5 = plot(T_Dis_k1_LFP35degC(:,5)/3600,V_Dis_k1_LFP35degC(:,5),'Color',color_c_rate5,'Linewidth',4);
c_rate6 = plot(T_Dis_k1_LFP35degC(:,6)/3600,V_Dis_k1_LFP35degC(:,6),'Color',color_c_rate6,'Linewidth',4);
c_rate7 = plot(T_Dis_k1_LFP35degC(:,7)/3600,V_Dis_k1_LFP35degC(:,7),'Color',color_c_rate7,'Linewidth',4);
c_rate8 = plot(T_Dis_k1_LFP35degC(:,8)/3600,V_Dis_k1_LFP35degC(:,8),'Color',color_c_rate8,'Linewidth',4);
% Cell 2
plot(T_Dis_k2_LFP35degC(:,1)/3600,V_Dis_k2_LFP35degC(:,1),'Color',color_c_rate1,'Linewidth',4);
plot(T_Dis_k2_LFP35degC(:,2)/3600,V_Dis_k2_LFP35degC(:,2),'Color',color_c_rate2,'Linewidth',4);
plot(T_Dis_k2_LFP35degC(:,3)/3600,V_Dis_k2_LFP35degC(:,3),'Color',color_c_rate3,'Linewidth',4);
plot(T_Dis_k2_LFP35degC(:,4)/3600,V_Dis_k2_LFP35degC(:,4),'Color',color_c_rate4,'Linewidth',4);
plot(T_Dis_k2_LFP35degC(:,5)/3600,V_Dis_k2_LFP35degC(:,5),'Color',color_c_rate5,'Linewidth',4);
plot(T_Dis_k2_LFP35degC(:,6)/3600,V_Dis_k2_LFP35degC(:,6),'Color',color_c_rate6,'Linewidth',4);
plot(T_Dis_k2_LFP35degC(:,7)/3600,V_Dis_k2_LFP35degC(:,7),'Color',color_c_rate7,'Linewidth',4);
plot(T_Dis_k2_LFP35degC(:,8)/3600,V_Dis_k2_LFP35degC(:,8),'Color',color_c_rate8,'Linewidth',4);
% Cell 3
plot(T_Dis_k3_LFP35degC(:,1)/3600,V_Dis_k3_LFP35degC(:,1),'Color',color_c_rate1,'Linewidth',4);
plot(T_Dis_k3_LFP35degC(:,2)/3600,V_Dis_k3_LFP35degC(:,2),'Color',color_c_rate2,'Linewidth',4);
plot(T_Dis_k3_LFP35degC(:,3)/3600,V_Dis_k3_LFP35degC(:,3),'Color',color_c_rate3,'Linewidth',4);
plot(T_Dis_k3_LFP35degC(:,4)/3600,V_Dis_k3_LFP35degC(:,4),'Color',color_c_rate4,'Linewidth',4);
plot(T_Dis_k3_LFP35degC(:,5)/3600,V_Dis_k3_LFP35degC(:,5),'Color',color_c_rate5,'Linewidth',4);
plot(T_Dis_k3_LFP35degC(:,6)/3600,V_Dis_k3_LFP35degC(:,6),'Color',color_c_rate6,'Linewidth',4);
plot(T_Dis_k3_LFP35degC(:,7)/3600,V_Dis_k3_LFP35degC(:,7),'Color',color_c_rate7,'Linewidth',4);
plot(T_Dis_k3_LFP35degC(:,8)/3600,V_Dis_k3_LFP35degC(:,8),'Color',color_c_rate8,'Linewidth',4);
% Cell 4
plot(T_Dis_k4_LFP35degC(:,1)/3600,V_Dis_k4_LFP35degC(:,1),'Color',color_c_rate1,'Linewidth',4);
plot(T_Dis_k4_LFP35degC(:,2)/3600,V_Dis_k4_LFP35degC(:,2),'Color',color_c_rate2,'Linewidth',4);
plot(T_Dis_k4_LFP35degC(:,3)/3600,V_Dis_k4_LFP35degC(:,3),'Color',color_c_rate3,'Linewidth',4);
plot(T_Dis_k4_LFP35degC(:,4)/3600,V_Dis_k4_LFP35degC(:,4),'Color',color_c_rate4,'Linewidth',4);
plot(T_Dis_k4_LFP35degC(:,5)/3600,V_Dis_k4_LFP35degC(:,5),'Color',color_c_rate5,'Linewidth',4);
plot(T_Dis_k4_LFP35degC(:,6)/3600,V_Dis_k4_LFP35degC(:,6),'Color',color_c_rate6,'Linewidth',4);
plot(T_Dis_k4_LFP35degC(:,7)/3600,V_Dis_k4_LFP35degC(:,7),'Color',color_c_rate7,'Linewidth',4);
plot(T_Dis_k4_LFP35degC(:,8)/3600,V_Dis_k4_LFP35degC(:,8),'Color',color_c_rate8,'Linewidth',4);
% Cell 5
plot(T_Dis_k5_LFP35degC(:,1)/3600,V_Dis_k5_LFP35degC(:,1),'Color',color_c_rate1,'Linewidth',4);
plot(T_Dis_k5_LFP35degC(:,2)/3600,V_Dis_k5_LFP35degC(:,2),'Color',color_c_rate2,'Linewidth',4);
plot(T_Dis_k5_LFP35degC(:,3)/3600,V_Dis_k5_LFP35degC(:,3),'Color',color_c_rate3,'Linewidth',4);
plot(T_Dis_k5_LFP35degC(:,4)/3600,V_Dis_k5_LFP35degC(:,4),'Color',color_c_rate4,'Linewidth',4);
plot(T_Dis_k5_LFP35degC(:,5)/3600,V_Dis_k5_LFP35degC(:,5),'Color',color_c_rate5,'Linewidth',4);
plot(T_Dis_k5_LFP35degC(:,6)/3600,V_Dis_k5_LFP35degC(:,6),'Color',color_c_rate6,'Linewidth',4);
plot(T_Dis_k5_LFP35degC(:,7)/3600,V_Dis_k5_LFP35degC(:,7),'Color',color_c_rate7,'Linewidth',4);
plot(T_Dis_k5_LFP35degC(:,8)/3600,V_Dis_k5_LFP35degC(:,8),'Color',color_c_rate8,'Linewidth',4);
% Cell 6
plot(T_Dis_k6_LFP35degC(:,1)/3600,V_Dis_k6_LFP35degC(:,1),'Color',color_c_rate1,'Linewidth',4);
plot(T_Dis_k6_LFP35degC(:,2)/3600,V_Dis_k6_LFP35degC(:,2),'Color',color_c_rate2,'Linewidth',4);
plot(T_Dis_k6_LFP35degC(:,3)/3600,V_Dis_k6_LFP35degC(:,3),'Color',color_c_rate3,'Linewidth',4);
plot(T_Dis_k6_LFP35degC(:,4)/3600,V_Dis_k6_LFP35degC(:,4),'Color',color_c_rate4,'Linewidth',4);
plot(T_Dis_k6_LFP35degC(:,5)/3600,V_Dis_k6_LFP35degC(:,5),'Color',color_c_rate5,'Linewidth',4);
plot(T_Dis_k6_LFP35degC(:,6)/3600,V_Dis_k6_LFP35degC(:,6),'Color',color_c_rate6,'Linewidth',4);
plot(T_Dis_k6_LFP35degC(:,7)/3600,V_Dis_k6_LFP35degC(:,7),'Color',color_c_rate7,'Linewidth',4);
plot(T_Dis_k6_LFP35degC(:,8)/3600,V_Dis_k6_LFP35degC(:,8),'Color',color_c_rate8,'Linewidth',4);

xlim([0 1.2]);
ylim([2 3.8]);
xlabel('time [h]','Interpreter','latex');
ylabel('voltage [V]','Interpreter','latex');
H = legend([c_rate1, c_rate2, c_rate3, c_rate4, c_rate5, c_rate6, c_rate7, c_rate8],...
           {'C/20','1C','2C','3C','5C','10C','15C','20C'},...
           'Location','northeast','Interpreter','latex');
figure_setup(H);


%% PLOT VOLTAGE VS. DISCHARGE CAPACITY

%Cell 1 - Compute discharge capacity
C_dis_k1_LFP35degC = zeros(max(L_k1_LFP35degC),length(Filename_k1_LFP35degC));
for n = 1:length(Filename_k1_LFP35degC)
    C_dis_k1_LFP35degC(1:L_k1_LFP35degC(1,n),n) = cumtrapz(T_Dis_k1_LFP35degC(1:L_k1_LFP35degC(1,n),n), I_Dis_k1_LFP35degC(1:L_k1_LFP35degC(1,n),n))/3600;
end
%Cell 2 - Compute discharge capacity
C_dis_k2_LFP35degC = zeros(max(L_k2_LFP35degC),length(Filename_k2_LFP35degC));
for n = 1:length(Filename_k2_LFP35degC)
    C_dis_k2_LFP35degC(1:L_k2_LFP35degC(1,n),n) = cumtrapz(T_Dis_k2_LFP35degC(1:L_k2_LFP35degC(1,n),n), I_Dis_k2_LFP35degC(1:L_k2_LFP35degC(1,n),n))/3600;
end
%Cell 3 - Compute discharge capacity
C_dis_k3_LFP35degC = zeros(max(L_k3_LFP35degC),length(Filename_k3_LFP35degC));
for n = 1:length(Filename_k3_LFP35degC)
    C_dis_k3_LFP35degC(1:L_k3_LFP35degC(1,n),n) = cumtrapz(T_Dis_k3_LFP35degC(1:L_k3_LFP35degC(1,n),n), I_Dis_k3_LFP35degC(1:L_k3_LFP35degC(1,n),n))/3600;
end
%Cell 4 - Compute discharge capacity
C_dis_k4_LFP35degC = zeros(max(L_k4_LFP35degC),length(Filename_k4_LFP35degC));
for n = 1:length(Filename_k4_LFP35degC)
    C_dis_k4_LFP35degC(1:L_k4_LFP35degC(1,n),n) = cumtrapz(T_Dis_k4_LFP35degC(1:L_k4_LFP35degC(1,n),n), I_Dis_k4_LFP35degC(1:L_k4_LFP35degC(1,n),n))/3600;
end
%Cell 5 - Compute discharge capacity
C_dis_k5_LFP35degC = zeros(max(L_k5_LFP35degC),length(Filename_k5_LFP35degC));
for n = 1:length(Filename_k5_LFP35degC)
    C_dis_k5_LFP35degC(1:L_k5_LFP35degC(1,n),n) = cumtrapz(T_Dis_k5_LFP35degC(1:L_k5_LFP35degC(1,n),n), I_Dis_k5_LFP35degC(1:L_k5_LFP35degC(1,n),n))/3600;
end
%Cell 6 - Compute discharge capacity
C_dis_k6_LFP35degC = zeros(max(L_k6_LFP35degC),length(Filename_k6_LFP35degC));
for n = 1:length(Filename_k6_LFP35degC)
    C_dis_k6_LFP35degC(1:L_k6_LFP35degC(1,n),n) = cumtrapz(T_Dis_k6_LFP35degC(1:L_k6_LFP35degC(1,n),n), I_Dis_k6_LFP35degC(1:L_k6_LFP35degC(1,n),n))/3600;
end

figure;
hold on;
%Cell 1
c_rate1 = plot(C_dis_k1_LFP35degC(1:L_k1_LFP35degC(1,1),1),V_Dis_k1_LFP35degC(:,1),'Color',color_c_rate1,'Linewidth',5);
c_rate2 = plot(C_dis_k1_LFP35degC(1:L_k1_LFP35degC(1,1),2),V_Dis_k1_LFP35degC(:,2),'Color',color_c_rate2,'Linewidth',5);
c_rate3 = plot(C_dis_k1_LFP35degC(1:L_k1_LFP35degC(1,1),3),V_Dis_k1_LFP35degC(:,3),'Color',color_c_rate3,'Linewidth',5);
c_rate4 = plot(C_dis_k1_LFP35degC(1:L_k1_LFP35degC(1,1),4),V_Dis_k1_LFP35degC(:,4),'Color',color_c_rate4,'Linewidth',5);
c_rate5 = plot(C_dis_k1_LFP35degC(1:L_k1_LFP35degC(1,1),5),V_Dis_k1_LFP35degC(:,5),'Color',color_c_rate5,'Linewidth',5);
c_rate6 = plot(C_dis_k1_LFP35degC(1:L_k1_LFP35degC(1,1),6),V_Dis_k1_LFP35degC(:,6),'Color',color_c_rate6,'Linewidth',5);
c_rate7 = plot(C_dis_k1_LFP35degC(1:L_k1_LFP35degC(1,1),7),V_Dis_k1_LFP35degC(:,7),'Color',color_c_rate7,'Linewidth',5);
c_rate8 = plot(C_dis_k1_LFP35degC(1:L_k1_LFP35degC(1,1),8),V_Dis_k1_LFP35degC(:,8),'Color',color_c_rate8,'Linewidth',5);
%Cell 2
plot(C_dis_k2_LFP35degC(1:L_k2_LFP35degC(1,1),1),V_Dis_k2_LFP35degC(:,1),'Color',color_c_rate1,'Linewidth',5);
plot(C_dis_k2_LFP35degC(1:L_k2_LFP35degC(1,1),2),V_Dis_k2_LFP35degC(:,2),'Color',color_c_rate2,'Linewidth',5);
plot(C_dis_k2_LFP35degC(1:L_k2_LFP35degC(1,1),3),V_Dis_k2_LFP35degC(:,3),'Color',color_c_rate3,'Linewidth',5);
plot(C_dis_k2_LFP35degC(1:L_k2_LFP35degC(1,1),4),V_Dis_k2_LFP35degC(:,4),'Color',color_c_rate4,'Linewidth',5);
plot(C_dis_k2_LFP35degC(1:L_k2_LFP35degC(1,1),5),V_Dis_k2_LFP35degC(:,5),'Color',color_c_rate5,'Linewidth',5);
plot(C_dis_k2_LFP35degC(1:L_k2_LFP35degC(1,1),6),V_Dis_k2_LFP35degC(:,6),'Color',color_c_rate6,'Linewidth',5);
plot(C_dis_k2_LFP35degC(1:L_k2_LFP35degC(1,1),7),V_Dis_k2_LFP35degC(:,7),'Color',color_c_rate7,'Linewidth',5);
plot(C_dis_k2_LFP35degC(1:L_k2_LFP35degC(1,1),8),V_Dis_k2_LFP35degC(:,8),'Color',color_c_rate8,'Linewidth',5);
%Cell 3
plot(C_dis_k3_LFP35degC(1:L_k3_LFP35degC(1,1),1),V_Dis_k3_LFP35degC(:,1),'Color',color_c_rate1,'Linewidth',5);
plot(C_dis_k3_LFP35degC(1:L_k3_LFP35degC(1,1),2),V_Dis_k3_LFP35degC(:,2),'Color',color_c_rate2,'Linewidth',5);
plot(C_dis_k3_LFP35degC(1:L_k3_LFP35degC(1,1),3),V_Dis_k3_LFP35degC(:,3),'Color',color_c_rate3,'Linewidth',5);
plot(C_dis_k3_LFP35degC(1:L_k3_LFP35degC(1,1),4),V_Dis_k3_LFP35degC(:,4),'Color',color_c_rate4,'Linewidth',5);
plot(C_dis_k3_LFP35degC(1:L_k3_LFP35degC(1,1),5),V_Dis_k3_LFP35degC(:,5),'Color',color_c_rate5,'Linewidth',5);
plot(C_dis_k3_LFP35degC(1:L_k3_LFP35degC(1,1),6),V_Dis_k3_LFP35degC(:,6),'Color',color_c_rate6,'Linewidth',5);
plot(C_dis_k3_LFP35degC(1:L_k3_LFP35degC(1,1),7),V_Dis_k3_LFP35degC(:,7),'Color',color_c_rate7,'Linewidth',5);
plot(C_dis_k3_LFP35degC(1:L_k3_LFP35degC(1,1),8),V_Dis_k3_LFP35degC(:,8),'Color',color_c_rate8,'Linewidth',5);
%Cell 4
plot(C_dis_k4_LFP35degC(1:L_k4_LFP35degC(1,1),1),V_Dis_k4_LFP35degC(:,1),'Color',color_c_rate1,'Linewidth',5);
plot(C_dis_k4_LFP35degC(1:L_k4_LFP35degC(1,1),2),V_Dis_k4_LFP35degC(:,2),'Color',color_c_rate2,'Linewidth',5);
plot(C_dis_k4_LFP35degC(1:L_k4_LFP35degC(1,1),3),V_Dis_k4_LFP35degC(:,3),'Color',color_c_rate3,'Linewidth',5);
plot(C_dis_k4_LFP35degC(1:L_k4_LFP35degC(1,1),4),V_Dis_k4_LFP35degC(:,4),'Color',color_c_rate4,'Linewidth',5);
plot(C_dis_k4_LFP35degC(1:L_k4_LFP35degC(1,1),5),V_Dis_k4_LFP35degC(:,5),'Color',color_c_rate5,'Linewidth',5);
plot(C_dis_k4_LFP35degC(1:L_k4_LFP35degC(1,1),6),V_Dis_k4_LFP35degC(:,6),'Color',color_c_rate6,'Linewidth',5);
plot(C_dis_k4_LFP35degC(1:L_k4_LFP35degC(1,1),7),V_Dis_k4_LFP35degC(:,7),'Color',color_c_rate7,'Linewidth',5);
plot(C_dis_k4_LFP35degC(1:L_k4_LFP35degC(1,1),8),V_Dis_k4_LFP35degC(:,8),'Color',color_c_rate8,'Linewidth',5);
%Cell 5
plot(C_dis_k5_LFP35degC(1:L_k5_LFP35degC(1,1),1),V_Dis_k5_LFP35degC(:,1),'Color',color_c_rate1,'Linewidth',5);
plot(C_dis_k5_LFP35degC(1:L_k5_LFP35degC(1,1),2),V_Dis_k5_LFP35degC(:,2),'Color',color_c_rate2,'Linewidth',5);
plot(C_dis_k5_LFP35degC(1:L_k5_LFP35degC(1,1),3),V_Dis_k5_LFP35degC(:,3),'Color',color_c_rate3,'Linewidth',5);
plot(C_dis_k5_LFP35degC(1:L_k5_LFP35degC(1,1),4),V_Dis_k5_LFP35degC(:,4),'Color',color_c_rate4,'Linewidth',5);
plot(C_dis_k5_LFP35degC(1:L_k5_LFP35degC(1,1),5),V_Dis_k5_LFP35degC(:,5),'Color',color_c_rate5,'Linewidth',5);
plot(C_dis_k5_LFP35degC(1:L_k5_LFP35degC(1,1),6),V_Dis_k5_LFP35degC(:,6),'Color',color_c_rate6,'Linewidth',5);
plot(C_dis_k5_LFP35degC(1:L_k5_LFP35degC(1,1),7),V_Dis_k5_LFP35degC(:,7),'Color',color_c_rate7,'Linewidth',5);
plot(C_dis_k5_LFP35degC(1:L_k5_LFP35degC(1,1),8),V_Dis_k5_LFP35degC(:,8),'Color',color_c_rate8,'Linewidth',5);
%Cell 6
plot(C_dis_k6_LFP35degC(1:L_k6_LFP35degC(1,1),1),V_Dis_k6_LFP35degC(:,1),'Color',color_c_rate1,'Linewidth',5);
plot(C_dis_k6_LFP35degC(1:L_k6_LFP35degC(1,1),2),V_Dis_k6_LFP35degC(:,2),'Color',color_c_rate2,'Linewidth',5);
plot(C_dis_k6_LFP35degC(1:L_k6_LFP35degC(1,1),3),V_Dis_k6_LFP35degC(:,3),'Color',color_c_rate3,'Linewidth',5);
plot(C_dis_k6_LFP35degC(1:L_k6_LFP35degC(1,1),4),V_Dis_k6_LFP35degC(:,4),'Color',color_c_rate4,'Linewidth',5);
plot(C_dis_k6_LFP35degC(1:L_k6_LFP35degC(1,1),5),V_Dis_k6_LFP35degC(:,5),'Color',color_c_rate5,'Linewidth',5);
plot(C_dis_k6_LFP35degC(1:L_k6_LFP35degC(1,1),6),V_Dis_k6_LFP35degC(:,6),'Color',color_c_rate6,'Linewidth',5);
plot(C_dis_k6_LFP35degC(1:L_k6_LFP35degC(1,1),7),V_Dis_k6_LFP35degC(:,7),'Color',color_c_rate7,'Linewidth',5);
plot(C_dis_k6_LFP35degC(1:L_k6_LFP35degC(1,1),8),V_Dis_k6_LFP35degC(:,8),'Color',color_c_rate8,'Linewidth',5);
%Nominal Capacity Value
C_nom = plot(ESS_technical_data.Nominal_Capacity_Ah('LFP'), 2, 'gs','LineWidth',3,'MarkerSize',24,...
          'MarkerEdgeColor','k','MarkerFaceColor',[0.8902    0.5922         0]);

xlim([0 3]);
ylim([2 3.8]);
xlabel('discharge capacity [Ah]','Interpreter','latex');
ylabel('voltage [V]','Interpreter','latex'); 
H = legend([c_rate1, c_rate2, c_rate3, c_rate4, c_rate5, c_rate6, c_rate7, c_rate8],...
           {'C/20','1C','2C','3C','5C','10C','15C','20C'},...
           'Location','northeast','Interpreter','latex');
figure_setup(H);


%% PLOT SURFACE TEMPERATURE VS. DISCHARGE CAPACITY

figure;
hold on;
%Cell 1
c_rate1 = plot(C_dis_k1_LFP35degC(1:L_k1_LFP35degC(1,1),1),Tsurf_Dis_k1_LFP35degC(:,1),'Color',color_c_rate1,'Linewidth',5);
c_rate2 = plot(C_dis_k1_LFP35degC(1:L_k1_LFP35degC(1,1),2),Tsurf_Dis_k1_LFP35degC(:,2),'Color',color_c_rate2,'Linewidth',5);
c_rate3 = plot(C_dis_k1_LFP35degC(1:L_k1_LFP35degC(1,1),3),Tsurf_Dis_k1_LFP35degC(:,3),'Color',color_c_rate3,'Linewidth',5);
c_rate4 = plot(C_dis_k1_LFP35degC(1:L_k1_LFP35degC(1,1),4),Tsurf_Dis_k1_LFP35degC(:,4),'Color',color_c_rate4,'Linewidth',5);
c_rate5 = plot(C_dis_k1_LFP35degC(1:L_k1_LFP35degC(1,1),5),Tsurf_Dis_k1_LFP35degC(:,5),'Color',color_c_rate5,'Linewidth',5);
c_rate6 = plot(C_dis_k1_LFP35degC(1:L_k1_LFP35degC(1,1),6),Tsurf_Dis_k1_LFP35degC(:,6),'Color',color_c_rate6,'Linewidth',5);
c_rate7 = plot(C_dis_k1_LFP35degC(1:L_k1_LFP35degC(1,1),7),Tsurf_Dis_k1_LFP35degC(:,7),'Color',color_c_rate7,'Linewidth',5);
c_rate8 = plot(C_dis_k1_LFP35degC(1:L_k1_LFP35degC(1,1),8),Tsurf_Dis_k1_LFP35degC(:,8),'Color',color_c_rate8,'Linewidth',5);
%Cell 2
plot(C_dis_k2_LFP35degC(1:L_k2_LFP35degC(1,1),1),Tsurf_Dis_k2_LFP35degC(:,1),'Color',color_c_rate1,'Linewidth',5);
plot(C_dis_k2_LFP35degC(1:L_k2_LFP35degC(1,1),2),Tsurf_Dis_k2_LFP35degC(:,2),'Color',color_c_rate2,'Linewidth',5);
plot(C_dis_k2_LFP35degC(1:L_k2_LFP35degC(1,1),3),Tsurf_Dis_k2_LFP35degC(:,3),'Color',color_c_rate3,'Linewidth',5);
plot(C_dis_k2_LFP35degC(1:L_k2_LFP35degC(1,1),4),Tsurf_Dis_k2_LFP35degC(:,4),'Color',color_c_rate4,'Linewidth',5);
plot(C_dis_k2_LFP35degC(1:L_k2_LFP35degC(1,1),5),Tsurf_Dis_k2_LFP35degC(:,5),'Color',color_c_rate5,'Linewidth',5);
plot(C_dis_k2_LFP35degC(1:L_k2_LFP35degC(1,1),6),Tsurf_Dis_k2_LFP35degC(:,6),'Color',color_c_rate6,'Linewidth',5);
plot(C_dis_k2_LFP35degC(1:L_k2_LFP35degC(1,1),7),Tsurf_Dis_k2_LFP35degC(:,7),'Color',color_c_rate7,'Linewidth',5);
plot(C_dis_k2_LFP35degC(1:L_k2_LFP35degC(1,1),8),Tsurf_Dis_k2_LFP35degC(:,8),'Color',color_c_rate8,'Linewidth',5);
%Cell 3
plot(C_dis_k3_LFP35degC(1:L_k3_LFP35degC(1,1),1),Tsurf_Dis_k3_LFP35degC(:,1),'Color',color_c_rate1,'Linewidth',5);
plot(C_dis_k3_LFP35degC(1:L_k3_LFP35degC(1,1),2),Tsurf_Dis_k3_LFP35degC(:,2),'Color',color_c_rate2,'Linewidth',5);
plot(C_dis_k3_LFP35degC(1:L_k3_LFP35degC(1,1),3),Tsurf_Dis_k3_LFP35degC(:,3),'Color',color_c_rate3,'Linewidth',5);
plot(C_dis_k3_LFP35degC(1:L_k3_LFP35degC(1,1),4),Tsurf_Dis_k3_LFP35degC(:,4),'Color',color_c_rate4,'Linewidth',5);
plot(C_dis_k3_LFP35degC(1:L_k3_LFP35degC(1,1),5),Tsurf_Dis_k3_LFP35degC(:,5),'Color',color_c_rate5,'Linewidth',5);
plot(C_dis_k3_LFP35degC(1:L_k3_LFP35degC(1,1),6),Tsurf_Dis_k3_LFP35degC(:,6),'Color',color_c_rate6,'Linewidth',5);
plot(C_dis_k3_LFP35degC(1:L_k3_LFP35degC(1,1),7),Tsurf_Dis_k3_LFP35degC(:,7),'Color',color_c_rate7,'Linewidth',5);
plot(C_dis_k3_LFP35degC(1:L_k3_LFP35degC(1,1),8),Tsurf_Dis_k3_LFP35degC(:,8),'Color',color_c_rate8,'Linewidth',5);
%Cell 4
plot(C_dis_k4_LFP35degC(1:L_k4_LFP35degC(1,1),1),Tsurf_Dis_k4_LFP35degC(:,1),'Color',color_c_rate1,'Linewidth',5);
plot(C_dis_k4_LFP35degC(1:L_k4_LFP35degC(1,1),2),Tsurf_Dis_k4_LFP35degC(:,2),'Color',color_c_rate2,'Linewidth',5);
plot(C_dis_k4_LFP35degC(1:L_k4_LFP35degC(1,1),3),Tsurf_Dis_k4_LFP35degC(:,3),'Color',color_c_rate3,'Linewidth',5);
plot(C_dis_k4_LFP35degC(1:L_k4_LFP35degC(1,1),4),Tsurf_Dis_k4_LFP35degC(:,4),'Color',color_c_rate4,'Linewidth',5);
plot(C_dis_k4_LFP35degC(1:L_k4_LFP35degC(1,1),5),Tsurf_Dis_k4_LFP35degC(:,5),'Color',color_c_rate5,'Linewidth',5);
plot(C_dis_k4_LFP35degC(1:L_k4_LFP35degC(1,1),6),Tsurf_Dis_k4_LFP35degC(:,6),'Color',color_c_rate6,'Linewidth',5);
plot(C_dis_k4_LFP35degC(1:L_k4_LFP35degC(1,1),7),Tsurf_Dis_k4_LFP35degC(:,7),'Color',color_c_rate7,'Linewidth',5);
plot(C_dis_k4_LFP35degC(1:L_k4_LFP35degC(1,1),8),Tsurf_Dis_k4_LFP35degC(:,8),'Color',color_c_rate8,'Linewidth',5);
%Cell 5
plot(C_dis_k5_LFP35degC(1:L_k5_LFP35degC(1,1),1),Tsurf_Dis_k5_LFP35degC(:,1),'Color',color_c_rate1,'Linewidth',5);
plot(C_dis_k5_LFP35degC(1:L_k5_LFP35degC(1,1),2),Tsurf_Dis_k5_LFP35degC(:,2),'Color',color_c_rate2,'Linewidth',5);
plot(C_dis_k5_LFP35degC(1:L_k5_LFP35degC(1,1),3),Tsurf_Dis_k5_LFP35degC(:,3),'Color',color_c_rate3,'Linewidth',5);
plot(C_dis_k5_LFP35degC(1:L_k5_LFP35degC(1,1),4),Tsurf_Dis_k5_LFP35degC(:,4),'Color',color_c_rate4,'Linewidth',5);
plot(C_dis_k5_LFP35degC(1:L_k5_LFP35degC(1,1),5),Tsurf_Dis_k5_LFP35degC(:,5),'Color',color_c_rate5,'Linewidth',5);
plot(C_dis_k5_LFP35degC(1:L_k5_LFP35degC(1,1),6),Tsurf_Dis_k5_LFP35degC(:,6),'Color',color_c_rate6,'Linewidth',5);
plot(C_dis_k5_LFP35degC(1:L_k5_LFP35degC(1,1),7),Tsurf_Dis_k5_LFP35degC(:,7),'Color',color_c_rate7,'Linewidth',5);
plot(C_dis_k5_LFP35degC(1:L_k5_LFP35degC(1,1),8),Tsurf_Dis_k5_LFP35degC(:,8),'Color',color_c_rate8,'Linewidth',5);
%Cell 6
plot(C_dis_k6_LFP35degC(1:L_k6_LFP35degC(1,1),1),Tsurf_Dis_k6_LFP35degC(:,1),'Color',color_c_rate1,'Linewidth',5);
plot(C_dis_k6_LFP35degC(1:L_k6_LFP35degC(1,1),2),Tsurf_Dis_k6_LFP35degC(:,2),'Color',color_c_rate2,'Linewidth',5);
plot(C_dis_k6_LFP35degC(1:L_k6_LFP35degC(1,1),3),Tsurf_Dis_k6_LFP35degC(:,3),'Color',color_c_rate3,'Linewidth',5);
plot(C_dis_k6_LFP35degC(1:L_k6_LFP35degC(1,1),4),Tsurf_Dis_k6_LFP35degC(:,4),'Color',color_c_rate4,'Linewidth',5);
plot(C_dis_k6_LFP35degC(1:L_k6_LFP35degC(1,1),5),Tsurf_Dis_k6_LFP35degC(:,5),'Color',color_c_rate5,'Linewidth',5);
plot(C_dis_k6_LFP35degC(1:L_k6_LFP35degC(1,1),6),Tsurf_Dis_k6_LFP35degC(:,6),'Color',color_c_rate6,'Linewidth',5);
plot(C_dis_k6_LFP35degC(1:L_k6_LFP35degC(1,1),7),Tsurf_Dis_k6_LFP35degC(:,7),'Color',color_c_rate7,'Linewidth',5);
plot(C_dis_k6_LFP35degC(1:L_k6_LFP35degC(1,1),8),Tsurf_Dis_k6_LFP35degC(:,8),'Color',color_c_rate8,'Linewidth',5);

xlim([0 3]);
ylim([30 70]);
xlabel('discharge capacity [Ah]','Interpreter','latex');
ylabel('surface temperature [$^\circ$C]','Interpreter','latex'); 
H = legend([c_rate1, c_rate2, c_rate3, c_rate4, c_rate5, c_rate6, c_rate7, c_rate8],...
           {'C/20','1C','2C','3C','5C','10C','15C','20C'},...
           'Location','northwest','Interpreter','latex');
figure_setup(H);


%% COMPUTE AVERAGE CAPACITY, SPECIFIC ENERGY, SPECIFIC POWER AND DISCHARGE EFFICIENCY

%Compute the capacity mean value across all cell samples [Ah]
mean_vec_LFP35degC(1) = mean([C_dis_k1_LFP35degC(L_k1_LFP35degC(1,1)-1,1); C_dis_k2_LFP35degC(L_k2_LFP35degC(1,1)-1,1); ...
                              C_dis_k3_LFP35degC(L_k3_LFP35degC(1,1)-1,1); C_dis_k4_LFP35degC(L_k4_LFP35degC(1,1)-1,1); ...
                              C_dis_k5_LFP35degC(L_k5_LFP35degC(1,1)-1,1); C_dis_k6_LFP35degC(L_k6_LFP35degC(1,1)-1,1)]);
mean_vec_LFP35degC(2) = mean([C_dis_k1_LFP35degC(L_k1_LFP35degC(1,2)-1,2); C_dis_k2_LFP35degC(L_k2_LFP35degC(1,2)-1,2); ...
                              C_dis_k3_LFP35degC(L_k3_LFP35degC(1,2)-1,2); C_dis_k4_LFP35degC(L_k4_LFP35degC(1,2)-1,2); ...
                              C_dis_k5_LFP35degC(L_k5_LFP35degC(1,2)-1,2); C_dis_k6_LFP35degC(L_k6_LFP35degC(1,2)-1,2)]);
mean_vec_LFP35degC(3) = mean([C_dis_k1_LFP35degC(L_k1_LFP35degC(1,3)-1,3); C_dis_k2_LFP35degC(L_k2_LFP35degC(1,3)-1,3); ...
                              C_dis_k3_LFP35degC(L_k3_LFP35degC(1,3)-1,3); C_dis_k4_LFP35degC(L_k4_LFP35degC(1,3)-1,3); ...
                              C_dis_k5_LFP35degC(L_k5_LFP35degC(1,3)-1,3); C_dis_k6_LFP35degC(L_k6_LFP35degC(1,3)-1,3)]);
mean_vec_LFP35degC(4) = mean([C_dis_k1_LFP35degC(L_k1_LFP35degC(1,4)-1,4); C_dis_k2_LFP35degC(L_k2_LFP35degC(1,4)-1,4); ...
                              C_dis_k3_LFP35degC(L_k3_LFP35degC(1,4)-1,4); C_dis_k4_LFP35degC(L_k4_LFP35degC(1,4)-1,4); ...
                              C_dis_k5_LFP35degC(L_k5_LFP35degC(1,4)-1,4); C_dis_k6_LFP35degC(L_k6_LFP35degC(1,4)-1,4)]);
mean_vec_LFP35degC(5) = mean([C_dis_k1_LFP35degC(L_k1_LFP35degC(1,5)-1,5); C_dis_k2_LFP35degC(L_k2_LFP35degC(1,5)-1,5); ...
                              C_dis_k3_LFP35degC(L_k3_LFP35degC(1,5)-1,5); C_dis_k4_LFP35degC(L_k4_LFP35degC(1,5)-1,5); ...
                              C_dis_k5_LFP35degC(L_k5_LFP35degC(1,5)-1,5); C_dis_k6_LFP35degC(L_k6_LFP35degC(1,5)-1,5)]);
mean_vec_LFP35degC(6) = mean([C_dis_k1_LFP35degC(L_k1_LFP35degC(1,6)-1,6); C_dis_k2_LFP35degC(L_k2_LFP35degC(1,6)-1,6); ...
                              C_dis_k3_LFP35degC(L_k3_LFP35degC(1,6)-1,6); C_dis_k4_LFP35degC(L_k4_LFP35degC(1,6)-1,6); ...
                              C_dis_k5_LFP35degC(L_k5_LFP35degC(1,6)-1,6); C_dis_k6_LFP35degC(L_k6_LFP35degC(1,6)-1,6)]);
mean_vec_LFP35degC(7) = mean([C_dis_k1_LFP35degC(L_k1_LFP35degC(1,7)-1,7); C_dis_k2_LFP35degC(L_k2_LFP35degC(1,7)-1,7); ...
                              C_dis_k3_LFP35degC(L_k3_LFP35degC(1,7)-1,7); C_dis_k4_LFP35degC(L_k4_LFP35degC(1,7)-1,7); ...
                              C_dis_k5_LFP35degC(L_k5_LFP35degC(1,7)-1,7); C_dis_k6_LFP35degC(L_k6_LFP35degC(1,7)-1,7)]);
mean_vec_LFP35degC(8) = mean([C_dis_k1_LFP35degC(L_k1_LFP35degC(1,8)-1,8); C_dis_k2_LFP35degC(L_k2_LFP35degC(1,8)-1,8); ...
                              C_dis_k3_LFP35degC(L_k3_LFP35degC(1,8)-1,8); C_dis_k4_LFP35degC(L_k4_LFP35degC(1,8)-1,8); ...
                              C_dis_k5_LFP35degC(L_k5_LFP35degC(1,8)-1,8); C_dis_k6_LFP35degC(L_k6_LFP35degC(1,8)-1,8)]);

%Compute the released energy mean value across all cell samples [Wh]                                        
Energy_LFP35degC = mean([Energy_k1_LFP35degC;...
                         Energy_k2_LFP35degC;...
                         Energy_k3_LFP35degC;...
                         Energy_k4_LFP35degC;...
                         Energy_k5_LFP35degC;...
                         Energy_k6_LFP35degC]); 
                     
%Compute the specific energy mean value across all cell samples [Wh/kg] 
Energy_spec_LFP35degC = mean([Energy_spec_k1_LFP35degC;...
                              Energy_spec_k2_LFP35degC;...
                              Energy_spec_k3_LFP35degC;...
                              Energy_spec_k4_LFP35degC;...
                              Energy_spec_k5_LFP35degC;...
                              Energy_spec_k6_LFP35degC]);
                          
%Compute the specific power mean value across all cell samples [W/kg] 
Power_spec_LFP35degC = mean([Power_spec_k1_LFP35degC;...
                             Power_spec_k2_LFP35degC;...
                             Power_spec_k3_LFP35degC;...
                             Power_spec_k4_LFP35degC;...
                             Power_spec_k5_LFP35degC;...
                             Power_spec_k6_LFP35degC]);

%Baseline case is when the energy in discharge is max --> C/20
baseline_case = Energy_LFP35degC(1);
%Percentage of discharge efficiency wrt baseline case [%]
Efficiency_LFP35degC = (Energy_LFP35degC/baseline_case)*100;
    
           
%% BATTERY DISCHARGE CAPACITY

figure
hold on
p = plot(1, ESS_technical_data.Nominal_Capacity_Ah('LFP'), 'gs','LineWidth',3,'MarkerSize',24,...
          'MarkerEdgeColor','k','MarkerFaceColor',[0.8902    0.5922         0]);
plot(1:1:length(C_rate_vec_LFP35degC), mean_vec_LFP35degC','s-','Color',color_LFP35degC,'Linewidth',6);
ylabel('discharge capacity [Ah]','Interpreter','latex','FontSize',32);
xticks(1:1:length(C_rate_vec_LFP35degC))
xticklabels({'C/20','1C','2C','3C','5C','10C','15C','20C'});
xlabel('C-rate [1/h]','Interpreter','latex','FontSize',32);
xlim([0.55,8.45])
h1 = legend('nominal capacity','Interpreter','latex','Location','southwest');
figure_setup(h1)


%% PLOT SPECIFIC ENERGY VS. C-RATE

figure;
hold on;
plot(1:1:length(C_rate_vec_LFP35degC), Energy_spec_LFP35degC','s-','Color',color_LFP35degC,'Linewidth',6);
ylabel('specific energy [Wh/kg]','Interpreter','latex','FontSize',32);
xticks(1:1:length(C_rate_vec_LFP35degC))
xticklabels({'C/20','1C','2C','3C','5C','10C','15C','20C'});
xlabel('C-rate [1/h]','Interpreter','latex','FontSize',32);
xlim([0.55,8.45]);
set(gca, 'YScale', 'log');
figure_setup('');


%% SPECIFIC POWER VS. C-RATE

figure;
hold on;
plot(1:1:length(C_rate_vec_LFP35degC), Power_spec_LFP35degC','s-','Color',color_LFP35degC,'Linewidth',6);
ylabel('specific power [W/kg]','Interpreter','latex','FontSize',32);
xticks(1:1:length(C_rate_vec_LFP35degC))
xticklabels({'C/20','1C','2C','3C','5C','10C','15C','20C'});
xlabel('C-rate [1/h]','Interpreter','latex','FontSize',32);
xlim([0.55,8.45]);
set(gca, 'YScale', 'log');
figure_setup('');


%% PLOT DISCHARGE EFFICIENCY VS. C-RATE

figure;
hold on;
plot(1:1:length(C_rate_vec_LFP35degC), Efficiency_LFP35degC','s-','Color',color_LFP35degC,'Linewidth',6);
xticks(1:1:length(C_rate_vec_LFP35degC))
xticklabels({'C/20','1C','2C','3C','5C','10C','15C','20C'});
xlabel('C-rate [1/h]','Interpreter','latex','FontSize',32);
xlim([0.55,8.45]);
ylabel('discharge efficiency [$\%$]','Interpreter','latex','FontSize',32);
xlabel('C-rate [1/h]','Interpreter','latex','FontSize',32);
figure_setup('');


%% FUNCTIONS

%-------------------------------------------------------------------------%
function load_data_ESS()

%Current folder directory
current_folder = pwd;

%Project main (parent) folder name
project_parent_folder_name = 'galvanostatic_discharge_test';

%Automatically search the directory of the Project main (parent) folder
for i=1:length(current_folder)-length(project_parent_folder_name)
    s1 = project_parent_folder_name; 
    s2 = current_folder(i:i+length(project_parent_folder_name)-1);
    if strcmp(s1,s2) == 1 %Verify if the two string are equal
        project_parent_folder = current_folder(1:i+length(project_parent_folder_name));
    end
end

%Directory from the Project main (parent) folder to the Data folder
driving_cycle_address = 'table_datasheet';

%Concatenate the Project main (parent) folder with the Data folder address
d = strcat(project_parent_folder,driving_cycle_address);

%Add this this directory to the current folder: all files in the directory are now accessible
addpath(d)

end


%-------------------------------------------------------------------------%
function figure_setup(L)
%Legend setup - Fontsize, Linewidth and Interpreter
set(L,'fontsize',27)
set(L,'LineWidth',0.8)
set(L,'Interpreter','latex');

%Chart setup - Fontsize, Linewidth and background color
set(gca,'Fontsize',33);
set(gca,'linewidth',1)
set(gca,'color','w');

%Figure position on the screen 
set(gcf, 'Position', get(0, 'Screensize'));
%Figure color out of the chart 
set(gcf,'color','w');

%Grid and box setup
grid on
grid minor
box on
end


