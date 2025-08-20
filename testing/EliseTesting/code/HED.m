%% Creates Path

clear;

localDataPath = setLocalDataPath(1);
%% Copies and sorts images into folders based on HED labels

% stimuli table
stimuliTable = readtable(fullfile(localDataPath.stimuli,'shared1000_HED.tsv'), 'FileType', 'text', 'Delimiter', '\t', 'TreatAsEmpty', 'n/a');
hed_names = {'faceTowards','Animal','Ingestible-object','Building','Item_count'};
hed_vector = zeros(height(stimuliTable),5);


for kk = 1:height(stimuliTable)
    
    %Path to images
    sourceImage = fullfile(localDataPath.im, stimuliTable.File_Name{kk});
    
    %Path to folders
    facing = fullfile(localDataPath.stimuli, 'FaceTowardsHED'); 
    bodies = fullfile(localDataPath.stimuli, 'BodiesHED');
    animals = fullfile(localDataPath.stimuli, 'AnimalsHED');
    nonliving = fullfile(localDataPath.stimuli, 'NonLivingHED');
    food = fullfile(localDataPath.stimuli, 'Food');

    
    % erase spaces
    thisStr = erase(stimuliTable.HED_short{kk}," ");

    
    %Check for annotations in HED table
    if contains(thisStr,'(Face,Towards)') %&& contains(thisStr,'(Face,Towards)') %&& ~contains(thisStr,'Animal') %person facing
        hed_vector(kk,1) = 1;
        status = copyfile(sourceImage, facing);
    elseif contains(thisStr,'Human') && ~contains(thisStr,'(Face,Towards)') %&& ~contains(thisStr,'Animal') %&& ~contains(thisStr,'Ingestible-object') %person not facing
        hed_vector(kk,2) = 1;
        status = copyfile(sourceImage, bodies);
    end
    if contains(thisStr,'Animal') %&& ~contains(thisStr,'Human')%animals
        hed_vector(kk,3) = 1;
        status = copyfile(sourceImage, animals); 
    end
    %if contains(thisStr,'Building') %&& ~contains(thisStr, 'Human') && ~contains(thisStr, 'Animal') %buildings
        %hed_vector(kk,4) = 1;
        %status = copyfile(sourceImage, nonliving);
    %end
    %if contains(thisStr,'Ingestible-object') %&& ~contains(thisStr, 'Human') && ~contains(thisStr, 'Animal') %ood
        %hed_vector(kk,5) = 1;
        %status = copyfile(sourceImage, food);
    %end
    
    if ~contains(thisStr,'Human') && ~contains(thisStr, 'Animal')
        hed_vector(kk,4) = 1;
        status = copyfile(sourceImage, nonliving); 
    end
    
    %Displays if images is copied
    if status
        disp('Image duplicated');
    else
        fprintf('Error');
    end
    
end

%% Trying something

if contains(thisStr,'Face, Towards') %&& contains(thisStr,'Towards') %&& ~contains(thisStr,'Animal') %person facing
        hed_vector(kk,1) = 1;
        status = copyfile(sourceImage, facing);
end

