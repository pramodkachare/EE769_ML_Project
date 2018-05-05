function [CatVar, Categories] = isCatVar(data, missMap)
%% Function to identify categorical variables (numeric and string)
% INPUTS: data = Contains the mixed data (# observations by # features)
%         missMap = Boolean map of missing values in data (missing = 1)
% OUTPUT: CatVar = Boolean flag to identify Categorical variables (1 by #features)
%         Categories = Cell array of categories for Categorical variables (1 by #features)

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data = data(sum(missMap, 2) == 0, :);
num = cellfun(@(x) isnumeric(x), data(1,:));
CatVar = zeros(1, length(data(1, :)));
Categories = cell(1, length(data(1, :)));
for i = 1:length(CatVar)
    if num(i)
        if size(data, 1)*0.1 > length(unique(cell2mat(data(:, i))));
            CatVar(i) = 1;
            Categories(i) = {num2cell(unique(cell2mat(data(:, i))))};
        end
    else
        if size(data, 1)*0.1 > length(unique(data(:, i)));
            CatVar(i) = 1;
            Categories(i) = {unique(data(:, i))};
        end
    end
end

%% END OF isCatVar.m