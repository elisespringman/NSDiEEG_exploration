%Variation of the original CalcDPrime function
%Simplified for two item comparions

%This function calculates d' between two folders

%Can be adjusted to do comparisons between electrodes and subjects too by
%exchanging j's for i's or n's

function [Dprime] = DPrimeTwoFolder(i, j, n, dMeanresults, variresults)
%% Establish variables

%Information for the first mean - j
%Change these variables to match the subject, folder, and electrode you
%would like to look at
i_1 = i-1;
j_1 = j-1;
n_1 = n-1;

%Variance of first folder - j
vari_1 = variresults(i,j_1, n);

%% Calculations

%Calculates the numerator
numerator = dMeanresults(i, j_1, n) - dMeanresults(i, j, n);

%Calculates the denominator
denominator = sqrt(0.5*(vari_1 + variresults(i, j, n)));

%This calculates and outputs the values of d'
Dprime = numerator/denominator;
Dprime