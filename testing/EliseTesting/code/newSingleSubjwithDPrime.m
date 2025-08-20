%Original code written by Annika
%Elise Springman made a few changes for my specific project

%Calculates and plots the average BB signal for a selected folder(s) of
%images and outputs mean, peak, and d'

%This variation loops through multiple subjects for comparison
%% Creates Path

clear;

localDataPath = setLocalDataPath(1);


%% Set variables 


% 0 for all images in folder, 1 for all images in the 1000 besides what is in this folder
NotFolder = 0; 

% 0 for graphing electrodes on their own graph
allElectrode = 0;

% 1 to plot BB values, 0 to skip
plotBBvalues = 1;
graphttmin = -2;
graphttmax = 2;

% 1 to find the mean of BB values over 0 to 0.2, 0 to skip
findmean = 1; 
meanttmin = 0.1;
meanttmax = 0.5;

%Sets bounds for d' and ttest calculations
dmin = 0;
dmax = 0.8;

%folder to be averaged
folderName = {'FaceTowardsHED', 'NonLivingHED'};

%Subject to be used
subject = {'06'};                      

%Channels to be tested
channel = ["ROC10"];
   

    %["LC2", "LT6", "LT7", "LT8", "LT9", "LB6", "LB7", "LB8", ...
    %"LC6", "LC7", "LG6", "LG7", "LG8", "LOC6", "LOC7", "LOC8", ...
    %"LOC1", "LOC2", "LOC3", "LOC4", "LOC5", "LT2", "LT3", "LT4",...
    %"LO4", "LO5", "LO6"]; %sub 02 ventral

    %["RPS1", "RPS2", "RPS3", "RPS4", "RPS5", "RPS6",...
    %"RC4", "RC5", "RC6", "RC7", "RC8", "ROC3", "ROC4", "ROC5"]; %sub 05
    %ventral
    
    %["RO1", "RO2", "RO3", "RO4", "RO5", "RO6", "RO7", "RO8", ...
    %"RO9", "RO10", "RO11", "RO12", "RO13", "RO14", "RO15", "RO16", ...
    %"RT1", "RT2", "RT3", "RT4", "RT5"]; %sub 12 ventral

    %["RT1", "RT2", "RT3", "RT4", "RT5", "RT6",...
    %"ROI5", "ROI6", "ROI7"]; %sub 13 ventral
    
    %["LO4", "LO5", "LO6", "LO7", "LOC5", "LOC6", "LOC7", "LOC8", ...
    %"LOC9", "LOC10", "LOC11", "LT1", "LT2", "LT3"]; %sub 17 ventral
    
    %["LC5", "LC6", "LT2", "LT3", "LT4", "LT5", "LT7", ...
    %"LOC6", "LOC7", "LOC8", "LOC9", "LO6", "LO7", "LO8"]; %sub 20 ventral
    
   %["LOT1", "LOT2", "LOT3", "LOT4", "LOT5", "LT1", "LT2", "LT3",...
    %"LT4", "LT5", "LT6", "LT7", "LT8", "LPO4", "LPO5", "LPO6", ...
    %"LB6", "LB7", "LO4", "LO5", "LO6", "LO7", "LO8", "LO9"]; %sub 21
    %ventral
    
%Establishes plot options
colors = {'-r', '-b', '-m', '-c'};
dashed = {'-+r', '-+b', '-+m', '-+c'};
legendColors = {[1 0 0], [0 0 1], [1 0 1], [0 1 1]};  % Red, blue, magenta, cyan

%Stores results, column 1 is avg and column 2 is peak
%results = zeros(length(channel), 2);
meanresults = zeros(length(channel), length(folderName));
peakresults = zeros(length(channel), length(folderName));

%n variable needed for DPrime function because this code uses one
%suject
n = 1;

%Set subject
    subjects = {subject};
    % Choose an analysis type:
    desc_label = 'normalizedMbbPerRun'; %new normalized data
     
    ss = 1;
    subj = subject{ss};
    currentsubject = subject{ss};

  
%% Loads the data for the subject
    % Load NSD-iEEG-broadband data
    % dataFitName = fullfile(['sub-' subj],['sub-' subj '_desc-' desc_label '_ieeg.mat']);
    
    %Loads old data to access all subject information
    %oldData = fullfile(localDataPath.input,'preproc-car', ['sub-' currentsubject],...
    %['sub-' currentsubject '_desc-preprocCARBB_ieeg.mat']);
    %load(oldData)
    
    %Loads new normalized data
    dataFitName = fullfile(localDataPath.input,'preproc-car', ['sub-' currentsubject],...
    ['sub-' currentsubject '_desc-' desc_label '_ieeg.mat']);
    load(dataFitName)
 
%% Calls the folderAverageBBfunction for each given electrode
%This code uses the new normalized data

%Clears variables used in calculations so data doesn't get mixed
clearvars dMeanresults
clearvars variresults
clearvars Prime
clearvars rePrime
clearvars tvalue
clearvars retvalue
clearvars pvalue
clearvars repvalue

for i = 1:length(channel) %Loop for electrodes

    %Creates new graph for each electrode
    if (allElectrode == 0) && (plotBBvalues == 1)
        figure;
    end

    for j = 1:length(folderName) %Loop for folders

        %Sets line color and marking to distiguish lines - this only
        %distigushes between folders
        currentcolor = colors{j};
        
        %Sets current folder to be input folderAverageBB
        currentFolder = folderName{j};

        % States which channel it is currently processing
        channel{i};
        channelIdx = find(ismember([all_channels.name],channel{i}));

        %finds the mean and peak values
        [meanbb, peakbb, dMean, vari, tsize, meanImages] = newFolderAverageBBfunction(localDataPath, currentFolder,...
            currentsubject, channelIdx, graphttmin, graphttmax, dmin, dmax, meanttmin, meanttmax, NotFolder, plotBBvalues, findmean, ...
            tt, all_channels, eventsST, Mbb_Norm_Run, currentcolor, channel(i), j);



        % Stores then prints the mean calculated above
        meanresults(i,j)   = meanbb;
        fprintf(append('The mean from ', num2str(meanttmin), ' to ', num2str(meanttmax), 'is:'));
        meanbb

        % Stores then prints the peak calculated above
        peakresults(i,j)   = peakbb;
        fprintf(append('The peak from ', num2str(meanttmin), ' to ', num2str(meanttmax), 'is:'));
        peakbb

        %Variance and mean for d' and t-test
        vari
        variresults(i, j) = vari;
        dMeanresults(i, j) = dMean;
        
        %size for t-test
        foldersize(i, j) = tsize;
        
        %Stores information needed to use MATLAB built in ttest function
        if j == 1
            data1 = meanImages;
        elseif j == 2
            data2 = meanImages;
        end

    end
    
    %Calculates and prints d'
    [DPrime] = DPrimeTwoFolder(i, j, n, dMeanresults, variresults);
    Prime(i) = DPrime;
    
    %Calculates t value - originally with my code
    %[t] = tTest(i, j, n, dMeanresults, variresults, foldersize);
    %tvalue(i) = t;
    %retvalue = tvalue';
    
    %Calculates t value using MATLAB function
    [h, p, ci, stats] = ttest(data1, data2);
    tvalue(i) = stats.tstat; %Store tvalue
    pvalue(i) = p; %Stores p value

    %Add a legend to the plot
    if (allElectrode == 0) && (plotBBvalues == 1)
        % Create invisible dummy lines for the legend
    hold on;
    legendHandles = gobjects(length(folderName), 1);  % Preallocate graphics handles

    for j = 1:length(folderName)
        legendHandles(j) = plot(nan, nan, '-', 'Color', legendColors{j}, 'LineWidth', 2);
    end
    
    %Creates legend
    legend(legendHandles, folderName, 'Interpreter', 'none', 'FontSize', 20);
    
    end
    
end

%Flips vectors so they are easier to copy and paste
rePrime = Prime';
retvalue = tvalue';
repvalue = pvalue';


%Add a legend to the plot - this doesn't always work right
if plotBBvalues == 1
    legend(folderName)
end


