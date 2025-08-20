
%This simplifies newFolderAverageBBfunction to skip plotting things
%For DPrimeTTestPValue

function [meanavgBB,peakavgBB, dMean, vari, tsize, meanImages] = meanfunction(localDataPath, ...
    nameFolder, subjectcurrent, channelcurrent, dmin, dmax, ...
    meanttmin, meanttmax, notf, meanBB, ...
    tt, all_channels, eventsST, New_Mbb_Norm)
%% Establishes needed data for given electrode and folder

    lclDataPath = localDataPath;
    folderName = nameFolder; %folder to be averaged
    subject=subjectcurrent; %Subject to be used
    channel = channelcurrent; %Channel to be used
    NotFolder = notf; % 0 for all images in folder, 1 for all images in the 1000 besides what is in this folder,
    
    %takes mean from meanttmin to meanttmax
    findmean = meanBB; % 1 to find the mean of BB values over 0 to 0.2, 0 to skip
    sel_events = eventsST;

    % extract relevant information from events file:
    [events_status,nsd_idx,shared_idx,nsd_repeats] = ieeg_nsdParseEvents(sel_events);
  
    AllBBValues = squeeze(New_Mbb_Norm(channelcurrent, :, :));
%% Loads Variables  (Not needed if loading variables outside of this function)  
 %{
    subjects = {subject};%0654
    % Choose an analysis type:
    desc_label = 'preprocCARBB';
     
    ss = 1;
    subj = subjects{ss};

   

    % Load NSD-iEEG-broadband data
    % dataFitName = fullfile(['sub-' subj],['sub-' subj '_desc-' desc_label '_ieeg.mat']);
    dataFitName = fullfile(lclDataPath,'derivatives','preproc-car', ['sub-' subject],...
    ['sub-' subject '_desc-' desc_label '_ieeg.mat']);
    load(dataFitName)
    %}


%% The actual folderAverageBB process
    %Gets list of the indexes of the images within the folder   
    sharedimageidxs = folder_idxs(folderName);
    
   
    %The following sets the image index to all the images not in the folder
    isNotInFolder = ones(1,1000);
    for k=1:length(sharedimageidxs)
        isNotInFolder(sharedimageidxs)=0;
    end
    notIndex = find(isNotInFolder);
    if NotFolder == 1
        sharedimageidxs = notIndex;
    end

    % finds the first repeat of the images
    Special1000idx = find(nsd_repeats <= 1);
    shared_idx1000 = shared_idx(Special1000idx);
    
    %Removes repeats from AllBBValues table
    AllBBValuesReduced = AllBBValues(:, Special1000idx);
    
    %Finds the shared_idx in the order of images shown
    imageNumberShown = find((ismember(shared_idx1000', sharedimageidxs)));
    

    %Calculates the mean
    if findmean == 1
        
        %Same as above to pull needed broadband responses
        BBvalues = [];
        for i = 1:length(imageNumberShown)
            BBvalues(:, i) = AllBBValuesReduced(:,imageNumberShown(i));
        end
        
        %Creates average BB over whole folder
        avgBB = mean(BBvalues, 2, 'omitnan');
        
        %Takes mean over input window
        ttavgBB = avgBB(tt>=meanttmin & tt<=meanttmax);
    
        %Returns the mean
        meanavgBB=mean(ttavgBB, 'omitnan');
        
        %Returns peak BB
        peakavgBB = max(ttavgBB');

    end
    
    %Calculates values needed for d' and t values
    %Mean each image over all time points desired
    currentImages = AllBBValuesReduced(:, imageNumberShown);
    ttcurrentImages = currentImages(find(tt>=dmin & tt<=dmax), :);
    meanImages = mean(ttcurrentImages, 1, 'omitnan');
    
    %Calculates variance and single mean value
    vari = var(meanImages, 1, 'omitnan');
    dMean = mean(meanImages, 'omitnan');
    
    %Size of folders for ttest
    tsize = length(meanImages);
  
  
end