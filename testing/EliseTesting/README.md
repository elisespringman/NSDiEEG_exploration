# NSDiEEG_exploration
Summer 2025

This is Elise Springman's testing folder to explore neural responses to food stimuli.

## Overview

    This project uses NSD data collected via electrodes to analyze responses  
to food stimuli. To do this, images were sorted according to various categories  
into folders. Subject information along with these folders was input into  
various programs that calculated and plotted average broadband signals as 
well as mean, peak, d prime, and ttest values.  

## Steps

    The general process for each comparison is the same. It only changes  
slightly if the goal is to plot the signal or do specific calculations.

    To start, I were given pre-processed data and corresponding inflated  
brains to show electrode positions.  

### Normalization

Code: NormbyRun  
  
Functions: ieeg_nsdParseEvents  

    This code loads the pre-processed data. The function then pulls important  
information from the events file. It takes the log base 10 of the Mbb file.  
Then the baseline is set. I primarily used a baseline of -0.1 to 0.  

    It creates a new matrix to fill. Then, the mean from the baseline is  
subtracted. This subtracts the single baseline from all broadband values for  
the run. For comparison, normalizing trial takes the baseline for an individual  
image for each trial and subtracts that from that images values.  

    Once the data is normalized, save the Mbb_Norm_Run, eventsST, all_channels,  
tt, and srate files. I usually save this to the same folder as the pre-processed  
data, but I give it a different name than the original.  

*Could also be normalized by trial using the NormbyTrial code  

### Folders

Code: HED (optional) or folders (optional)  

Functions: None  

Additional Materials: HED labels (with HED code) or FolderLabels table (with folders code)

    An important note to start: for the programs to run properly, you will  
need to have the folders already created. The programs just copy and sort  
the images into the correct folder. So before running the either program,  
create the empty folders.  

    Then, based on the desired comparisons, use of the image sorting programs  
can vary. The HED code will sort through the HED labels. You will need a table  
containing images numbers and the HED labels. The folders program creates the  
folders I used for many of my comparisons. You just will need the FolderLabels  
table. Also note, these folders were created from my own judgment, not some  
other organized labelling system.  
 
    Alternatively, you can create folders of your own depending on the desired  
comparison.  

    Also note, in order to calculate a t and p value using the MATLAB built  
in ttest function, the folders need to be the same size. This may not be the  
case when using the HED labels.

### Average Signal and Calculations

Code: newSingleSubjwithDPrime (single subject), newMultiSubjBBwithDPrime (multiple subjects),  
    or DPrimeTTestPvalue (single subject, no plotting)  

Functions: ieeg_nsdParseEvents (All), newFolderAverageBBfunction (SingleSubj and MultiSubj),  
    folder_idxs (SingleSubj and MultiSubj), shadedErrorBar (SingleSubj and MultiSubj),  
    DPrimeTwoFolder (All), meanfunction (DPrime)

    In the "set variables" section of each code, change the intervals to the  
desired ones. Turn on or off any plotting or calculation features you want.  
Input folder names and the subject number. Input a channel list, if needed.  
Finally, change the desc_label to match the title of your normalized data file.  

    Once all that information is input, the program should run. The MultiSubj  
and SingleSubj codes will plot the average broadband signals for input electrodes  
as well as calculate mean, peak, d prime, t-test, and p values. Additionally,  
the MultiSubj code will loop through multiple input subjects. It is built to  
skip any input electrodes not within the current subject, so you can input all  
electrode names desired across all subjects. It will fill zeros in the holes  
in output tables.  

    The DPrimeTTestPValue code will run the same, just using a slightly different  
function to skip the plotting. Currently, this code is also setup to run on all  
electrodes in a subject. This can be easily changed, however, to a list of   
electrodes. 

## Understanding the Primary Functions and Paths

### folder_idxs

    This function goes through the input folders of images and returns the  
shared index numbers. This is the beginning of the indexing process. This  
function is used in newFolderAverageBBfunction and meanfunction.  

### ieeg_nsdParseEvents

    This function was shared with me. Its purpose is to pull important data  
from the larger eventsST file. This function is used within the  
newFolderAverageBBfunction and meanfunction.  

### newFolderAverageBBfunction and meanfunction

    These are the two primary functions used to do the bulk of calculations.  
The first section renames some variables as needed and uses the ieeg_nsdParseEvents  
to pull important information.  

    The next used section is where all the calculation occur. This begins by  
reindexing the folders used. This uses folder_idxs to pull shared index numbers  
of the stimuli in the given folder. Then if you want to compare a folder to all  
other images, it reindexes all images left in the overall stimuli folder.  

    Then, it moves on to the overall index that lists all images in the order  
shown. The function removes all repeats and reindexes without them. It does the  
same with the matrix containing all of the broadband values for the given  
channel. Finally, it takes the image numbers in the input folder, finds them in  
the index of images in the order shown, and creates a new index of just the  
images in the folder in the order shown to match the matrix of broadband values.

    From there, the newFolderAverageBBfunction moves on to plotting while the  
meanfunction skips this. This creates a new matrix containing only broadband  
values for the images in the folder. Then, it cuts it down to the desired time  
window. Then, it calculates standard error, averages each time point across  
broadband values, and plots the traces.  

    The next section calculates the mean and peak values. It follows the same  
process to pull the broadband values for only the images in the folder. It  
averages the same way at each time point across images. It cuts this down to  
the correct time window. Then it finds the mean and peak of this averaged file.  

    The final block of code pulls the information needed to calculate d prime  
and ttest values. This takes the broadband values for only the images in the  
folder, cuts it down to the right time, and means it. However, this time the  
mean occurs for each image across time to find a single mean for each image  
rather than each time point like before. Then it calculates the variance,  
overall mean, and size of this file. These are used for later calculations.  
    
### DPrimeTwoFolder

   This function calculates d prime using the values calculated in the previous  
function. This compares two folders, so it may not work correctly if more than  
two folders are input into the original code. For the numerator, the two folder  
means calculated at the end of the previous function are subtracted. Then for  
the denominator, the variances are added, this is multiplied by one half, and  
the square root is taken. Then the numerator is divided by the denominator.  

*Can see the Jacques 2015 Corresponding ECoG and fMRI category-selective signals . 
in human ventral temporal cortex paper for more information on the formula

### Paths

    There are a couple of paths that I use throughout the programs. The first  
of the two main paths is the "input" one. This brings me to the overall folder  
for the project. Within it, I have a folder for stimuli, pre-preocessed data,  
code, etc. The second main path I use is the "stimuli" path. This one takes  
me one step further than the "input" one and goes into my stimuli folder. This  
is where I store my sorted folders, my overall 1000 images folder, etc. 


