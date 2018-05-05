function [Nmiss, missMap] = missing_value(data)
%% Function to identify missing values in data
% INPUT: data = Cell array of mixed data with numeric and string values
% OUTPUT: Nmiss = # total missing values in data
%         missMap = Boolean map of missing values in data (missing = 1)

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Missing values in numbers will be blanks
% Missing values in strings will be NA
missMap = cellfun(@(x) isempty(x), data) + cellfun(@(x) isequal(x, 'NA'), data);
Nmiss = sum(sum(missMap,1),2);

%% END OF missing_value().m