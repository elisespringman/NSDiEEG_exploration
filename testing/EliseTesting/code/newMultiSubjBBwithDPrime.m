%Original code written by Annika
%Some changes made by Elise Springman for my specific project

%Calculates and plots the average BB signal for a selected folder(s) of
%images and outputs mean, peak, and d'
%This variation loops through multiple subjects for comparison

%% Creates Path

clear;

localDataPath = setLocalDataPath(1);

%%

% 0 for all images in folder, 1 for all images in the 1000 besides what is in this folder
NotFolder = 0;  

% 0 for graphing electrodes on their own graph
allElectrode = 0;

% 1 to plot BB values, 0 to skip
plotBBvalues = 1;
graphttmin = -0.1;
graphttmax = 0.8;

% 1 to find the mean of BB values over 0 to 0.2, 0 to skip
findmean = 1; 
meanttmin = 0;
meanttmax = 0.8;

%folder to be averaged
folderName = {'Food5', 'Random5'};

%Subject to be used
subject = {'20', '02'};                      

%Channels to be tested
channel = ["LC2", "RC4", "LT2"];

%Establishes plot options
colors = {'-r', '-b', '-c', '-m'};
dashed = {'-+r', '-+b', '-+c', '-+m'};
legendColors = {[1 0 0], [0 0 1], [0 1 1], [1 0 1]};  % Red, blue, cyan, magenta
    
% "LOC3", "LOC4", "LOC5"};

%{
{"LG6", "LG7", "LG8", "LB6", "LB7", "LB8", "LC2" ...
    "LC6", "LC7", "LT6", "LT7", "LT8", "LT9", ...
    "LOC6", "LOC7", "LOC8" }; 
%}

%Stores results, column 1 is avg and column 2 is peak
%results = zeros(length(channel), 2);
meanresults = zeros(length(channel), length(folderName));
peakresults = zeros(length(channel), length(folderName));


% Maximum time to be plotted (mean is between 0 and 0.2)
%ttmax = 0.8;
%ttmin = -0.1;



    subjects = {subject};%0654
    % Choose an analysis type:
    desc_label = 'normalizedMbbPerRun';
     
    ss = 1;
    subj = subject{ss};
 
%% Calls the folderAverageBBfunction for each given electrode
%This code uses the new normalized data

for n = 1:length(subject) %Loop for subjects
    
    %Sets current subject
    currentsubject = subject{n};
    
    %Loads subject new normalized data - has to do this for each subject
    dataFitName = fullfile(localDataPath.input,'preproc-car', ['sub-' currentsubject],...
    ['sub-' currentsubject '_desc-' desc_label '_ieeg.mat']);
    load(dataFitName)
    
    for i = 1:length(channel) %Loop for electrodes
           
        currentchannel = channel{i};
        
        %Creates new graph for each electrode
        if (allElectrode == 0) && (plotBBvalues == 1) && (ismember(currentchannel, all_channels.name))
            figure;
        end
  
        for j = 1:length(folderName) %Loop for folders
        
            %Sets current folder to be input folderAverageBB
            currentFolder = folderName{j};
        
            %Skips electrodes listed not within current subject
            if ~contains(all_channels.name, currentchannel)
                continue;
            end
            
            %Sets line color and marking to distiguish folders
            if n == 1
                currentcolor = colors{j};
            elseif n == 2
                currentcolor = dashed{j};
            end
            

            % States which channel it is currently processing
            channelIdx = find(ismember([all_channels.name],currentchannel));

            %finds the mean and peak value between 0 and 0.2
            [meanbb, peakbb, dMean, vari] = newFolderAverageBBfunction(localDataPath, currentFolder,...
                currentsubject, channelIdx, graphttmin, graphttmax, meanttmin, meanttmax, NotFolder, plotBBvalues, findmean, ...
                tt, all_channels, eventsST, Mbb_Norm_Run, currentcolor, currentchannel);



            % Stores then prints the mean calculated above
            meanresults(i,j,n)   = meanbb;

            fprintf(append('The mean from ', num2str(meanttmin), ' to ', num2str(meanttmax), 'is:'));
            meanbb

            % Stores then prints the peak calculated above
            peakresults(i,j,n)   = peakbb;

            fprintf(append('The peak from ', num2str(meanttmin), ' to ', num2str(meanttmax), 'is:'));
            peakbb

            %stdev = std(ttavgBB)
            %stdevresults(i, j, n) = stdev;
            vari
            variresults(i, j, n) = vari;
            
            dMeanresults(i, j, n) = dMean;

        end
        
        %Calculates d' only for electrodes within the current subject
        if (ismember(currentchannel, all_channels.name))
            [Dprime] = DPrimeTwoFolder(i, j, n, dMeanresults, variresults);
            Prime(i, n) = Dprime;
        elseif (~ismember(currentchannel, all_channels.name))
            Prime(i, n) = 0;
        end
        
        
        %Add a legend to the plot
        if (allElectrode == 0) && (plotBBvalues == 1)
            % Create invisible dummy lines for the legend
        hold on;
        legendHandles = gobjects(length(folderName), 1);  % Preallocate graphics handles

        for j = 1:length(folderName)
            legendHandles(j) = plot(nan, nan, '-', 'Color', legendColors{j}, 'LineWidth', 2);
        end
        legend(legendHandles, folderName, 'Interpreter', 'none', 'FontSize', 20);
        end
        
    end
    
    %ilast = i - 1;
    %lastchannel = channel{ilast};
    
    %if ismember(lastchannel, all_channels.name)
        %Calculates and prints d'
        %[Dprime] = DPrimeTwoFolder(ilast, j, n, dMeanresults, variresults);
        %Prime(ilast) = Dprime;
        %rePrime = Prime';
    %end
    
    
end 

rePrime = Prime';

%Calculates d'
%[Dprime] = CalcDPrime(i, j, n, meanresults, variresults);
%Dprime

%Adds a legend
%if plotBBvalues == 1
    %legend(folderName)
%end

 %Add a legend to the plot - this doesn't always work right
    if (allElectrode == 0) && (plotBBvalues == 1)
        % Create invisible dummy lines for the legend
    hold on;
    legendHandles = gobjects(length(folderName), 1);  % Preallocate graphics handles

    for j = 1:length(folderName)
        legendHandles(j) = plot(nan, nan, '-', 'Color', legendColors{j}, 'LineWidth', 2);
    end
    
    legend(legendHandles, folderName, 'Interpreter', 'none', 'FontSize', 20);
    end 

    
    if (j == 2) && (ismember(currentchannel, all_channels.name))
        %Calculates and prints d'
        [Dprime] = DPrimeTwoFolder(i, j, n, dMeanresults, variresults);
        Prime(i, n) = Dprime;
    elseif (j == 2) && (~ismember(currentchannel, all_channels.name))
        Prime(i, n) = 0;
    end