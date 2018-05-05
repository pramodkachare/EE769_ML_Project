function [Nmiss, missMap] = missing_value(data)
% Missing values in numbers will be blanks
% Missing values in strings will be NA
missMap = cellfun(@(x) isempty(x), data) + cellfun(@(x) isequal(x, 'NA'), data);
Nmiss = sum(sum(missMap,1),2);
% display(Nmiss);