function data = handle_CatVar(data, CatVar, Categories, enctype)
h = waitbar(0, 'Encoding features');
switch enctype
    case 1 %'dummy'
        for i = 1 :size(data, 2)
            waitbar(i/size(data, 2), h, 'Encoding features');
            if CatVar(i)
                for j = 1:length(Categories{i});
                    data(cellfun(@(x) isequal(x, Categories{i}{j}), data(:, i))==1, i) = {j};
                end
            end
        end
    case 2 %'onehot'
        for i = 1 :size(data, 2)
            waitbar(i/size(data, 2), h, 'Encoding features');
            if CatVar(i)
                for j = 1:length(Categories{i});
                    data(cellfun(@(x) isequal(x, Categories{i}{j}), data(:, i))==1, i) = {full(ind2vec(j, length(Categories{i})))'};
                end
            end
        end
end
delete(h)