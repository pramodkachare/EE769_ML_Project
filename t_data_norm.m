function data = t_data_norm(data, CatVar, stats)
% It is assumed that missing value problem is solved.
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