%Using this code to calculate a bunch of d', t, and p values at once

%Very similar to newSingleSubjwithDPrime
%This code runs the same and uses a very similar function, but it skips the
%plotting part
%This code is setup to calculate for all channels rather than a list


%% Creates Path

clear;

localDataPath = setLocalDataPath(1);

%% Set variables 


% 0 for all images in folder, 1 for all images in the 1000 besides what is in this folder
NotFolder = 0; 

% bounds for d' and ttest calculation
dmin = 0.4;
dmax = 0.8;

% 1 to find the mean of BB values over 0 to 0.2, 0 to skip
findmean = 1; 
meanttmin = 0.4;
meanttmax = 0.8;

%folder to be averaged
folderName = {'Food', 'Interactions'};

%Subject to be used
subject = {'21'};                      

%Don't need this if calculating for all electrodes in a sub
%Channels to be tested
%channel = ["LC1", "LC2", "LC3", "LC4", "LC5"];

%Stores results, column 1 is avg and column 2 is peak
%results = zeros(length(channel), 2);
%meanresults = zeros(length(channel), length(folderName));
%peakresults = zeros(length(channel), length(folderName));

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
    
%% 

%Clears variables used in calculations so data doesn't get mixed
clearvars dMeanresults
clearvars variresults
clearvars Prime
clearvars rePrime
clearvars pvalue
clearvars repvalue
clearvars tvalue
clearvars retvalue
clearvars meanImages


for i = 1:length(all_channels.name) %Loop for electrodes
    %all_channel.name for all electrodes or channels for listed electrodes
    %channel for specific list

    for j = 1:length(folderName) %Loop for folders
        
        
        %Sets current folder to be input folderAverageBB
        currentFolder = folderName{j};

        % States which channel it is currently processing
        channel(i) = all_channels.name(i); %currentchannel
        channelIdx = find(ismember([all_channels.name],channel{i}));
         
        
        %finds the mean and peak value between meanttmin and meanttmax
        [meanbb, peakbb, dMean, vari, tsize, meanImages] = meanfunction(localDataPath, currentFolder,...
            currentsubject, channelIdx,  dmin, dmax, meanttmin, meanttmax, NotFolder, findmean, ...
            tt, all_channels, eventsST, Mbb_Norm_Run); %currentchannel
        
        %stdev = std(ttavgBB)
        %stdevresults(i, j, n) = stdev;
        
        %Stores and displays variance
        variresults(i, j) = vari;
        vari
        
        %Stores mean used for d' calculations
        dMeanresults(i, j) = dMean;
        
        %Stores information needed to use MATLAB built in ttest function
        if j == 1
            data1 = meanImages;
        elseif j == 2
            data2 = meanImages;
        end
        
    end 
    
    %Accounts for status of electrode
    if all_channels.status(i) == 0
         continue
    elseif all_channels.status(i) == 1
        %Calculates and prints d'
        [Dprime] = DPrimeTwoFolder(i, j, n, dMeanresults, variresults);
         Prime(i) = Dprime;
         
         %Completes ttest
        [h, p, ci, stats] = ttest(data1, data2);
        tvalue(i) = stats.tstat; %Store t value
        pvalue(i) = p; %Stores p value
        
    end
    
    %Calculates and prints d' for all electrodes
    %[Dprime] = CalcDPrime(i, j, n, dMeanresults, variresults);
     %Prime(i) = Dprime;
     
     %Flips vectors so they are easier to copy and paste
     rePrime = Prime';
     retvalue = tvalue';
     repvalue = pvalue';
end

        