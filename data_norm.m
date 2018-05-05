function [data, stats] = data_norm(data, CatVar, normtype)
%% Function to normalize data. Normalization is applid only to numeric
% variables.(It is assumed that missing value problem is solved.)
% INPUTS: data = Contains the mixed data (# observations by # features)
%         CatVar = Boolean flag to identify Categorical variables (1 by #features) 
%         normtype = Type of normalization to be applied
%             1 - Mean normalization (mean = 0)
%             2 - Variance normalization (Std. dev. = 1)
%             3 - Statastical (i.e. Mean and Variance) normalization 
%             4 - Scale (Min. val. = 0 and Max. Val. = 1)normalization 
% OUTPUT: data = Mixed data with numeric value normalized
%         stats = Normalization object
%             Contains: normtype = Type of normalization applied
%                       mu = Mean of numeric variables
%                       v  = Std. dev. of numeric variables
%                       m  = Max value of numeric variables
%                       n  = Min value of numeric variables
        
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
D = data(:, CatVar == 0);
stats.type = normtype; 
switch normtype
    case 1 % Mean = 0
        mu = mean(cell2mat(D), 1);
        for i = 1:size(D, 2)
            D(:, i) = cellfun(@(x) {x-mu(i)}, D(:, i));
        end
        stats.mu = mu;
        
    case 2 % Variance = 1
        v = std(cell2mat(D), 1, 1);
        for i = 1:size(D, 2)
            D(:, i) = cellfun(@(x) {x/v(i)}, D(:, i));
        end
        stats.v = v;
        
    case 3 % Mean = 0  & Variance = 1
        mu = mean(cell2mat(D), 1);
        v = std(cell2mat(D), 1, 1);
        for i = 1:size(D, 2)
            D(:, i) = cellfun(@(x) {(x-mu(i))/v(i)}, D(:, i));
        end
        stats.mu = mu;
        stats.v = v;
        
    case 4 % 'minmax' [0 1]
        m = max(cell2mat(D), [], 1);
        n = min(cell2mat(D), [], 1);
        for i = 1:size(D, 2)
            D(:, i) = cellfun(@(x) {(x-n(i))/(m(i)-n(i))}, D(:, i));
        end
        stats.m = m;
        stats.n = n;
end

data(:, CatVar == 0) = D;

%% END OF data_norm.m
