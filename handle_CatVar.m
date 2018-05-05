function data = handle_CatVar(data, CatVar, Categories, enctype)
%% Function to encode Categorical variables
% INPUTS: data = Contains the mixed data (# observations by # features)
%         CatVar = Boolean flag to identify Categorical variables (1 by #features) 
%         Categories = Cell array of categories for Categorical variables (1 by #features)
%         enctype = Type of encoding to be applied for Categorical variable
%             1 - Dummy encoding
%             2 - One-hot encoding
% OUTPUT: data = Mixed data with categorical variables encoded

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h = waitbar(0, 'Encoding features');
switch enctype
    case 1 %'dummy'
        for i = 1 :size(data, 2)
            waitbar(i/size(data, 2), h, 'Encoding features');
            if CatVar(i)
                for j = 1:length(Categories{i});
                    data(cellfun(@(x) isequal(x, Categories{i}{j}),...
                        data(:, i))==1, i) = {j};
                end
            end
        end
    case 2 %'onehot'
        for i = 1 :size(data, 2)
            waitbar(i/size(data, 2), h, 'Encoding features');
            if CatVar(i)
                for j = 1:length(Categories{i});
                    data(cellfun(@(x) isequal(x, Categories{i}{j}),...
                        data(:, i))==1, i) = {full(ind2vec(j, length(Categories{i})))'};
                end
            end
        end
end
delete(h)

%% END OF handle_CatVar.m