%% Creates Path

clear;

localDataPath = setLocalDataPath(1);
%% Copies and sorts images into folders based on my spreadsheet labels
%Create folders before running this
%This just copies and sorts the images into the folders you want

for kk = 1:height(InteractionLabels)
    
    %Path to images
    sourceImage = fullfile(localDataPath.im, FolderLabels.stimulus_id{kk});
    
    %Path to folders
    donuts = fullfile(localDataPath.stimuli, 'Donuts');
    humanAnimal = fullfile(localDataPath.stimuli, 'HumanAnimal');
    sweet = fullfile(localDataPath.stimuli, 'Sweet');
    mix = fullfile(localDataPath.stimuli, 'MixHumanHumanAnimal');
    fruit = fullfile(localDataPath.stimuli, 'Fruit');
    humanHumanAnimal = fullfile(localDataPath.stimuli, 'HumanHumanAnimal');
    food = fullfile(localDataPath.stimuli, 'Food');
    interaction = fullfile(localDataPath.stimuli, 'Interactions');
    
    foodCentered = fullfile(localDataPath.stimuli, 'FoodCentered');
    random = fullfile(localDataPath.stimuli, 'Random');
    
    smallFoodCentered = fullfile(localDataPath.stimuli, 'FoodCentered30');
    smallRandom = fullfile(localDataPath.stimuli, 'Random30');
    
    %Loops to copy and move images to specific folder
    %Specific comparison folders
    if FolderLabels.Donuts(kk) == 1
        status = copyfile(sourceImage, donuts); 
    end
    if FolderLabels.HumanAnimal(kk) == 1
        status = copyfile(sourceImage, humanAnimal); 
    end
    if FolderLabels.Sweet(kk) == 1
        status = copyfile(sourceImage, sweet); 
    end
    if FolderLabels.MixHumanHumanAnimal(kk) == 1
        status = copyfile(sourceImage, mix); 
    end
    if FolderLabels.Fruit(kk) == 1
        status = copyfile(sourceImage, fruit); 
    end
    if FolderLabels.HumanHumanAnimal(kk) == 1
        status = copyfile(sourceImage, humanHumanAnimal); 
    end
    if FolderLabels.Food(kk) == 1
        status = copyfile(sourceImage, food); 
    end
    if FolderLabels.Interactions(kk) == 1
        status = copyfile(sourceImage, interaction); 
    end
    
    %Inital food vs random comparison folders
    if FolderLabels.FoodCentered(kk) == 1
        status = copyfile(sourceImage, foodCentered); 
    end
    if FolderLabels.Random(kk) == 1
        status = copyfile(sourceImage, random); 
    end
    
    %Smaller food vs random comparisons - on poster
    if FolderLabels.FoodCentered30(kk) == 1
        status = copyfile(sourceImage, smallFoodCentered); 
    end
    if FolderLabels.Random30(kk) == 1
        status = copyfile(sourceImage, smallRandom); 
    end

end
