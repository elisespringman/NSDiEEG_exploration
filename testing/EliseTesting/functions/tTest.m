%Original ttest code written before switching to matlab built in function

%May be incorrect - seemed like it may be but I haven't had time to double
%check
%No longer used

function [t] = tTest(i, j, n, dMeanresults, variresults, foldersize)
%% Establish variables

%Information for the first mean - j
%Change these variables to match the subject, folder, and electrode you
%would like to look at
i_1 = i-1;
j_1 = j-1;
n_1 = n-1;

%Variance of first folder - j
vari_1 = variresults(i,j_1, n);

%size of each folder
size_1 = foldersize(i, j_1);
size_2 = foldersize(i, j);

%% Calculations

%Calculates the numerator
numerator = dMeanresults(i, j_1, n) - dMeanresults(i, j, n);

%Calculates denominator
denominator = sqrt((variresults(i, j_1, n)/size_1) + (variresults(i, j, n)/size_2));

%Calculates and outputs t value
t = numerator/denominator;
t
