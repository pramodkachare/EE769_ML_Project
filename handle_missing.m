function [data] = handle_missing(data, missMap, CatVar, misshandle)
%% Function to eliminate the mising values in the data
% INPUTS: data = Contains the mixed data (# observations by # features)
%         missMap = Boolean map of missing values in data (missing = 1)
%         CatVar = Boolean flag to identify Categorical variables (1 by #features) 
%         misshandle = Flag for procedue to select for missing values
%             'Exclude' - Exclude observatoins with missing values (works for small # missing values)
%             'Replace' - Replace missing values by PCA prediction
%                         (Required MATLAB 2018a as function behaviour changes) 
% OUTPUT: data = Mixed data with all missing values excluded or replaced

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch misshandle
    case 'Exclude' % Exclude the missing values
        ind = sum(missMap, 2)>0;
        data(ind == 1, :) = [];
    case 'Replace' % Incomplete
        % Doest not work in MATLAB lower than 2018.
        D = data(:, CatVar == 0);
        D(missMap(:, CatVar == 0)>0) = {NaN};
        d = cell2mat(D);
        md = mean(d(sum(isnan(d), 2)==0, :), 1);
        b = bsxfun(@minus, b, mb);
        [coeff1,score1] = pca(cell2mat(D),'algorithm','als'); % [1]
        D1 = score1*coeff1' + repmat(mu1,13,1);
end

% [1] Ilin, A., and T. Raiko. “Practical Approaches to Principal Component 
% Analysis in the Presence of Missing Values.” J. Mach. Learn. Res.. 
% Vol. 11, August 2010, pp. 1957–2000.

%% END OF handle_missing.m