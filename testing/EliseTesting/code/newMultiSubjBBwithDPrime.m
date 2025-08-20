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
plotBBvalues = 0;
graphttmin = -0.1;
graphttmax = 0.8;

% 1 to find the mean of BB values over 0 to 0.2, 0 to skip
findmean = 1; 
meanttmin = 0;
meanttmax = 0.8;

%Sets bounds for d' and ttest calculations
dmin = 0.4;
dmax = 0.8;

%folder to be averaged
folderName = {'Food_OG', 'Random_OG'};

%Subject to be used
subject = {'05', '12', '13'};                      

%Channels to be tested
channel = ["RA1", "RA2", "RA3", "RA4", "RA5", "RA6", "RA7", "RA8"...
    "RB1", "RB2", "RB3", "RB4", "RB5", "RB6", "RB7" ...
    "RC1", "RC2", "RC3", "RC4", "RC5", "RC6", ...
    "RD1", "RD2", "RD3", "RD4", "RD5", "RD6"];

%Establishes plot options
colors = {'-r', '-b', '-c', '-m'};
dashed = {'-+r', '-+b', '-+c', '-+m'};
legendColors = {[1 0 0], [0 0 1], [0 1 1], [1 0 1]};  % Red, blue, cyan, magenta

%Stores results, column 1 is avg and column 2 is peak
%results = zeros(length(channel), 2);
meanresults = zeros(length(channel), length(folderName));
peakresults = zeros(length(channel), length(folderName));



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
        
        %Sets current electrode
        currentchannel = channel{i};
        
        %Creates new graph for each electrode
        if (allElectrode == 0) && (plotBBvalues == 1) && (ismember(currentchannel, all_channels.name))
            figure;
        end
  
        for j = 1:length(folderName) %Loop for folders
        
            %Sets current folder to be input folderAverageBB
            currentFolder = folderName{j};
        
            %Skips if current electrode listed  is not within current subject
            if ~contains(all_channels.name, currentchannel)
                continue;
            end
            
            %Sets line color and marking to distiguish folders
            currentcolor = colors{j};
            

            % States which channel it is currently processing
            channelIdx = find(ismember([all_channels.name],currentchannel));

            %finds the mean and peak value between 0 and 0.2
            [meanbb, peakbb, dMean, vari, tsize, meanImages] = newFolderAverageBBfunction(localDataPath, currentFolder,...
                currentsubject, channelIdx, graphttmin, graphttmax, dmin, dmax, meanttmin, meanttmax, NotFolder, plotBBvalues, findmean, ...
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
            
            %Stores and prints variance results
            vari
            variresults(i, j, n) = vari;
            
            %Stores mean results used for d' calculation
            dMeanresults(i, j, n) = dMean;
            
            %Stores data needed for ttest
            if j == 1
                data1 = meanImages;
            elseif j == 2
                data2 = meanImages;
            end

        end
        
        %Calculates d' only for electrodes within the current subject
        if (ismember(currentchannel, all_channels.name))
            %Calculates d'
            [Dprime] = DPrimeTwoFolder(i, j, n, dMeanresults, variresults);
            Prime(i, n) = Dprime; %Stores d'
            
            %Calculates ttest
            [h, p, ci, stats] = ttest(data1, data2);
            tvalue(i, n) = stats.tstat; %Stores t value
            pvalue(i, n) = p; %Stores p value
        elseif (~ismember(currentchannel, all_channels.name))
            %Fills a zero is status is 0
            Prime(i, n) = 0;
            tvalue(i, n) = 0;
            pvalue(i, n) = 0;
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

%Flips vectors so they are easier to copy and paste
rePrime = Prime';
retvalue = tvalue';
repvalue = pvalue';