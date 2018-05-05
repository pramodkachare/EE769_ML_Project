function [data, head] = load_data()
%% Function to load data
% OUTPUT: data = Cell array of mixed data with numeric and string values
%         head = cell array of features headers (names)
%                If headers are not specified in file dummy named are
%                created.
        
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
try
    [fname, pname, idx] = uigetfile({'*.csv', 'CSV File';...
                               '*.xls', 'Excel 97-2000';...
                               '*.xlsx', 'Excel file'}, 'Load data file', cd);
    if ~isequal(fname, 0)
        dlg = questdlg('Use first row as header', 'Header', 'Yes', 'No', 'Yes');
        waitfor(dlg)
        h = waitbar(0, 'Loading data');
        if idx < 2
            fid = fopen(fullfile(pname, fname),'r');
            if isequal(dlg, 'Yes')
                head = textscan(fgetl(fid), '%s', 'delimiter', ',');
                head = head{1}';
            end
            waitbar(0.25, h, 'Loading data');
            rows = 1;
            line = fgetl(fid);
            while ~isequal(line, -1)
                temp = textscan(line, '%s', 'delimiter',',');
                data(rows, :) = temp{1}';
                rows = rows + 1;
                line = fgetl(fid);
            end
            waitbar(0.5, h, 'Loading data');
            fclose(fid);
            temp = cellfun(@(x) str2double(x), data, 'UniformOutput', false);
            ind = find(cellfun(@(x) isnan(x), temp)==0);
            for i = 1:length(ind)
                data(ind(i)) = temp(ind(i));
                waitbar(0.5+0.5*(i/length(ind)), h, 'Loading data');
            end
        else
            [num, data] = xlsread(fullfile(pname, fname));
            if isequal(dlg, 'Yes')
                head = data(1,:);
                data(1, :) = [];
            end
            ind = find(~isnan(num));
            for i = 1:length(ind)
                data(ind(i)) = {num(ind(i))};
                waitbar((i/length(ind)), h, 'Loading data');
            end
        end
        if ~exist('head', 'var')
            head = cell(1, length(data(1,:)));
            for i = 1:length(head)
                head{i} = ['Var' num2str(i)];
            end
        end
        delete(h)
    else
        warndlg('Action terminated by User.', 'Load warning')
    end
catch
    data = [];
    head = [];
    errordlg('Unexpected error occurred.', 'Load error');
end
% Seperate processing allows Catergorical and Numeric variable
% identification easier

%% END OF load_data.m