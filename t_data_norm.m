function data = t_data_norm(data, CatVar, stats)
%% Function to normalize testing data according to training data
% INPUTS: data = Contains the TESTING data (# observations by # features)
%         CatVar = Boolean flag to identify Categorical variables (1 by #features) 
%         stats = Normalization object
%             Contains: normtype = Type of normalization applied
%                       mu = Mean of numeric variables
%                       v  = Std. dev. of numeric variables
%                       m  = Max value of numeric variables
%                       n  = Min value of numeric variables
% OUTPUT: data = Normalized test data with numeric value 

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
D = data(:, CatVar == 0);
stats.type = normtype; 
switch normtype
    case 1 % Mean = 0
        mu = stats.mu;
        for i = 1:size(D, 2)
            D(:, i) = cellfun(@(x) {x-mu(i)}, D(:, i));
        end
        
    case 2 % Std. dev. = 1
        v = stats.v;
        for i = 1:size(D, 2)
            D(:, i) = cellfun(@(x) {x/v(i)}, D(:, i));
        end
        
    case 3 % Mean = 0  & Std. dev. = 1
        mu = stats.mu;
        v = stats.v;
        for i = 1:size(D, 2)
            D(:, i) = cellfun(@(x) {(x-mu(i))/v(i)}, D(:, i));
        end

    case 4 % 'minmax' [0 1]
        m = stats.m;
        n = stats.n;
        for i = 1:size(D, 2)
            D(:, i) = cellfun(@(x) {(x-n(i))/(m(i)-n(i))}, D(:, i));
        end
end

data(:, CatVar == 0) = D;

%% END OF t_data_norm.m