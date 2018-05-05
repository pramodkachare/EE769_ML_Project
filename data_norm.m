function [data, stats] = data_norm(data, CatVar, normtype)
% It is assumed that missing value problem is solved.
D = data(:, CatVar == 0);
stats.type = normtype; 
switch normtype
    case 1 % Mean = 0
        mu = mean(cell2mat(D), 1);
        for i = 1:size(D, 2)
            D(:, i) = cellfun(@(x) {x-mu(i)}, D(:, i));
        end
        stats.mu = mu;
        
    case 2 % Std. dev. = 1
        v = std(cell2mat(D), 1, 1);
        for i = 1:size(D, 2)
            D(:, i) = cellfun(@(x) {x/v(i)}, D(:, i));
        end
        stats.v = v;
        
    case 3 % Mean = 0  & Std. dev. = 1
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