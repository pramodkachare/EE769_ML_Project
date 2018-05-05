function [data] = handle_missing(data, missMap, CatVar, misshandle)


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
        [coeff1,score1] = pca(cell2mat(D),'algorithm','als');
        D1 = score1*coeff1' + repmat(mu1,13,1);
end

% [6] Ilin, A., and T. Raiko. “Practical Approaches to Principal Component 
% Analysis in the Presence of Missing Values.” J. Mach. Learn. Res.. 
% Vol. 11, August 2010, pp. 1957–2000.