function varargout = Easy_ML(varargin)
% EASY_ML MATLAB code for Easy_ML.fig
%      EASY_ML, by itself, creates a new EASY_ML or raises the existing
%      singleton*.
%
%      H = EASY_ML returns the handle to a new EASY_ML or the handle to
%      the existing singleton*.
%
%      EASY_ML('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EASY_ML.M with the given input arguments.
%
%      EASY_ML('Property','Value',...) creates a new EASY_ML or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Easy_ML_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Easy_ML_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Easy_ML

% Last Modified by GUIDE v2.5 05-May-2018 08:51:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Easy_ML_OpeningFcn, ...
                   'gui_OutputFcn',  @Easy_ML_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Easy_ML is made visible.
function Easy_ML_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Easy_ML (see VARARGIN)

% Choose default command line output for Easy_ML
handles.output = hObject;
set(handles.modeltag, 'String', {'Select Model', 'ANN', 'SVM'});
set(handles.cvtag, 'String', {'Cross-Validation', 'K-fold', 'Hold-Out'});
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Easy_ML wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Easy_ML_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in dataloadtag.
function dataloadtag_Callback(hObject, eventdata, handles)
% hObject    handle to dataloadtag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[data, head] = load_data();
msgbox('Data loaded successfully.', 'Success');
[Nmiss, missMap] = missing_value(data);
[CatVar, Categories] = isCatVar(data, missMap);

handles.data = data;
handles.head = head;
handles.org_data = data;
handles.org_head = head;
handles.Nmiss = Nmiss;
handles.missMap = missMap;
handles.CatVar = CatVar;
handles.Categories = Categories;

msg = {['# Observations = ' num2str(size(handles.data, 1))];...
        ['# missing values = ' num2str(handles.Nmiss)];...
        ['# Features = ' num2str(length(handles.CatVar))];...
        ['# Categorical = ' num2str(sum(handles.CatVar))];...
        ['# Numeric = ' num2str(sum(handles.CatVar==0))]};
set(handles.datatexttag, 'String', msg);
set(handles.featurenamelist, 'String', [{'Select feature'} handles.head]);
set(handles.targettag, 'String', [{'Select target'} handles.head]);
featurenamelist_Callback(hObject, eventdata, handles)
guidata(hObject, handles);



% --- Executes on selection change in featurenamelist.
function featurenamelist_Callback(hObject, eventdata, handles)
% hObject    handle to featurenamelist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns featurenamelist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from featurenamelist
ind = get(handles.featurenamelist, 'Value')-1;
if ind > 0
    if handles.CatVar(ind)
        msg = {['# Categories = ' num2str(length(handles.Categories{ind}))];...
                ['Missing Values = ' num2str(sum(handles.missMap(:, ind), 1))]};
        set(handles.ftexttag, 'String', msg);
        Data = handle_CatVar(handles.data(handles.missMap(:, ind)==0, ind),...
                handles.CatVar(ind), handles.Categories(ind), 1);
        histogram(cell2mat(Data), 'Normalization', 'pdf');
        xlabel('Categories')
        ylabel('PDF')
    else
        Data = cell2mat(handles.data(handles.missMap(:, ind)==0, ind));
        msg = {['Mean = ' num2str(mean(Data, 1))];...
                ['Std = ' num2str(std(Data))];...
                ['Missing Values = ' num2str(sum(handles.missMap(:, ind), 1))]};
        set(handles.ftexttag, 'String', msg);
        histogram(Data, 'Normalization', 'pdf');
        ylabel('PDF')
    end
    axis tight
    grid on;
else
    axis(handles.fhisttag)
    cla;
    set(handles.ftexttag, 'String', '');
end

% --- Executes during object creation, after setting all properties.
function featurenamelist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to featurenamelist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in fdelbtntag.
function fdelbtntag_Callback(hObject, eventdata, handles)
% hObject    handle to fdelbtntag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ind = get(handles.featurenamelist, 'Value')-1;
if ind > 0
    handles.data(:, ind) = [];
    handles.head(:, ind) = [];
    handles.missMap(:, ind) = [];
    handles.Nmiss = sum(sum(handles.missMap, 1), 2);
    handles.CatVar(:, ind) = [];
    handles.Categories(:, ind) = [];

    msg = {['# Observations = ' num2str(size(handles.data, 1))];...
        ['# missing values = ' num2str(handles.Nmiss)];...
        ['# Features = ' num2str(length(handles.CatVar))];...
        ['# Categorical = ' num2str(sum(handles.CatVar))];...
        ['# Numeric = ' num2str(sum(handles.CatVar==0))]};
    set(handles.datatexttag, 'String', msg);

    set(handles.featurenamelist, 'String', [{'Select feature'} handles.head]);
    set(handles.targettag, 'String', [{'Select target'} handles.head]);
    guidata(hObject, handles);
else
    warndlg('Please select feature to exclude.', 'Warning');
end
set(handles.featurenamelist, 'Value', 1);
featurenamelist_Callback(hObject, eventdata, handles)

% --- Executes on button press in resettag.
function resettag_Callback(hObject, eventdata, handles)
% hObject    handle to resettag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Nmiss, missMap] = missing_value(handles.org_data);
[CatVar, Categories] = isCatVar(handles.org_data, missMap);

handles.data = handles.org_data;
handles.head = handles.org_head;
handles.Nmiss = Nmiss;
handles.missMap = missMap;
handles.CatVar = CatVar;
handles.Categories = Categories;

msg = {['# Observations = ' num2str(size(handles.data, 1))];...
        ['# missing values = ' num2str(handles.Nmiss)];...
        ['# Features = ' num2str(length(handles.CatVar))];...
        ['# Categorical = ' num2str(sum(handles.CatVar))];...
        ['# Numeric = ' num2str(sum(handles.CatVar==0))]};
set(handles.datatexttag, 'String', msg);

set(handles.featurenamelist, 'String', [{'Select feature'} handles.head]);
set(handles.targettag, 'String', [{'Select target'} handles.head]);
guidata(hObject, handles);
set(handles.featurenamelist, 'Value', 1);
featurenamelist_Callback(hObject, eventdata, handles);

% --- Executes on button press in hmissbtntag.
function hmissbtntag_Callback(hObject, eventdata, handles)
% hObject    handle to hmissbtntag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
misshandle = questdlg('How to handle missing values', 'Handle missing values',...
                                        'Exclude', 'Replace', 'Exclude');
waitfor(misshandle);

data = handle_missing(handles.data, handles.missMap, handles.CatVar, misshandle);

handles.data = data;
handles.Nmiss = 0;
handles.missMap = zeros(size(handles.data));
handles.hmiss = misshandle;
msg = {['# Observations = ' num2str(size(handles.data, 1))];...
        ['# missing values = ' num2str(handles.Nmiss)];...
        ['# Features = ' num2str(length(handles.CatVar))];...
        ['# Categorical = ' num2str(sum(handles.CatVar))];...
        ['# Numeric = ' num2str(sum(handles.CatVar==0))]};

set(handles.datatexttag, 'String', msg);
set(handles.featurenamelist, 'Value', 1);
featurenamelist_Callback(hObject, eventdata, handles);
guidata(hObject, handles);


% --- Executes on selection change in targettag.
function targettag_Callback(hObject, eventdata, handles)
% hObject    handle to targettag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns targettag contents as cell array
%        contents{get(hObject,'Value')} returns selected item from targettag



% --- Executes during object creation, after setting all properties.
function targettag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to targettag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in modeltag.
function modeltag_Callback(hObject, eventdata, handles)
% hObject    handle to modeltag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns modeltag contents as cell array
%        contents{get(hObject,'Value')} returns selected item from modeltag

ind  = get(handles.modeltag, 'Value')-1;
switch ind
    case 1 % ANN
        Model.type = ind;
        set(handles.edit1tag, 'String', 'Array of hidden layers nodes');
        pop1 = {'Train Function', 'Scaled Conjugate Gradiant',...
                'Levenberg-Marquardt', 'Bayesian regularization',...
                'Gradient Descent'};
        set(handles.pop1tag, 'String', pop1);
        pop2 = {'Performance Function', 'crossentropy', 'Sum Absolute Error (L1)', 'Sum Squared Error (L2)'};
        set(handles.pop2tag, 'String', pop2);
    case 2 % SVM
        Model.type = ind;
        pop1 = {'Kernel Function', 'Linear', 'Polynomial', 'RBF', 'Sigmoid'};
        set(handles.pop1tag, 'String', pop1);
        pop2 = {'C-SVC', 'nu-SVC', 'one-class SVM', 'epsilon-SVR', 'nu-SVR'};
        set(handles.pop2tag, 'String', pop2);

end
handles.Model = Model;
guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function modeltag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to modeltag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1tag_Callback(hObject, eventdata, handles)
% hObject    handle to edit1tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1tag as text
%        str2double(get(hObject,'String')) returns contents of edit1tag as a double


% --- Executes during object creation, after setting all properties.
function edit1tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop1tag.
function pop1tag_Callback(hObject, eventdata, handles)
% hObject    handle to pop1tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop1tag contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop1tag
if get(handles.modeltag, 'Value')-1 == 2
    switch get(handles.pop1tag, 'Value')-1
        case 2
            set(handles.edit1tag, 'String', 'Polynomial degree');
        case 3
            set(handles.edit1tag, 'String', 'Gamma value');
        otherwise
            set(handles.edit1tag, 'String', 'C value');
    end
end
% --- Executes during object creation, after setting all properties.
function pop1tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop1tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop2tag.
function pop2tag_Callback(hObject, eventdata, handles)
% hObject    handle to pop2tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop2tag contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop2tag


% --- Executes during object creation, after setting all properties.
function pop2tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop2tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in traintag.
function traintag_Callback(hObject, eventdata, handles)
% hObject    handle to traintag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch handles.Model.type
    case 1 % ANN
        ind = get(handles.targettag, 'Value')-1;
        if handles.stats.enctype == 2
            T = cell2mat(handles.data(:, ind));
        else
            T = full(ind2vec(cell2mat(handles.data(:, ind))', length(handles.Categories(1, ind))));
        end
        handles.data(:, ind) = [];
        X = cell2mat(handles.data);
        pop1 = {'trainscg', 'trainlm', 'trainbr', 'traingd'};
        p1 = get(handles.pop1tag, 'Value')-1;
        pop2 = {'crossentropy', 'sae', 'sse'};
        p2 = get(handles.pop2tag, 'Value')-1;
        net = patternnet(str2num(get(handles.edit1tag, 'String')), pop1{p1}, pop2{p2});
        Model.mdl = train(net, X', T');
        
        save Model.mat Model
    case 2 % SVM
        ind = get(handles.targettag, 'Value')-1;
        if handles.stats.enctype == 1
            T = cell2mat(handles.data(:, ind));
        elseif handles.stats.enctype == 2
            T = sum(cell2mat(handles.data(:, end)), 2);
        end
        if get(handles.pop2tag, 'Value')==1
            T = cell2mat(handles.data(:, end));
        end
        handles.data(:, end) = [];
        X = cell2mat(handles.data);
%         -s svm_type : set type of SVM (default 0)
%     0 -- C-SVC
%     1 -- nu-SVC
%     2 -- one-class SVM
%     3 -- epsilon-SVR
%     4 -- nu-SVR
    %         t kernel_type : set type of kernel function (default 2)
    %     0 -- linear: u'*v
    %     1 -- polynomial: (gamma*u'*v + coef0)^degree
    %     2 -- radial basis function: exp(-gamma*|u-v|^2)
    %     3 -- sigmoid: tanh(gamma*u'*v + coef0)

        % -d degree : set degree in kernel function (default 3)
        % -g gamma : set gamma in kernel function (default 1/num_features)
        % -v n : n-fold cross validation

        param = ['-t ', num2str(get(handles.pop1tag, 'Value')-2) '-s ',...
            num2str(get(handles.pop2tag, 'Value')-1), '-v',get(handles.edit2tag, 'String')];
               
        switch get(handles.pop1tag, 'Value')
            case 1
                Model.mdl = svmtrain(T, X', param);
            case 3
                param = [param, '-d', get(handles.edit2tag, 'String')];
                Model.mdl = svmtrain(T, X, param);
            case 4
                param = [param, '-g', get(handles.edit2tag, 'String')];
                Model.mdl = svmtrain(T, X', param);
        end
end
handles.Model = Model;
guidata(hObject, handles);

% --- Executes on selection change in cvtag.
function cvtag_Callback(hObject, eventdata, handles)
% hObject    handle to cvtag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns cvtag contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cvtag


% --- Executes during object creation, after setting all properties.
function cvtag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cvtag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2tag_Callback(hObject, eventdata, handles)
% hObject    handle to edit2tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2tag as text
%        str2double(get(hObject,'String')) returns contents of edit2tag as a double


% --- Executes during object creation, after setting all properties.
function edit2tag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in fnormtag.
function fnormtag_Callback(hObject, eventdata, handles)
% hObject    handle to fnormtag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fnormtag contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fnormtag
normtype = get(handles.catenctag, 'Value')-1;
h = waitbar(0.25, 'Normalizing features');
[data, stats] = data_norm(handles.data, handles.CatVar, normtype);
waitbar(0.9, h, 'Normalizing features')
delete(h)
handles.data = data;
handles.stats = stats;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function fnormtag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fnormtag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in catenctag.
function catenctag_Callback(hObject, eventdata, handles)
% hObject    handle to catenctag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns catenctag contents as cell array
%        contents{get(hObject,'Value')} returns selected item from catenctag
enctype = get(handles.catenctag, 'Value')-1;
data = handle_CatVar(handles.data, handles.CatVar, handles.Categories, enctype);
handles.data = data;
handles.stats.enctype = enctype;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function catenctag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to catenctag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in tloadtag.
function tloadtag_Callback(hObject, eventdata, handles)
% hObject    handle to tloadtag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = load_data();
msgbox('Data loaded successfully.', 'Success');
[Nmiss, missMap] = missing_value(data);
data(:, 1) = [];
[CatVar, Categories] = isCatVar(data, missMap);
[data] = handle_missing(data, missMap, CatVar, handles.misshandle);

data = t_data_norm(data, CatVar, handles.stats);
data = handle_CatVar(data, CatVar, Categories, handles.stats.enctype);
msg = {['# Observations = ' num2str(size(handles.data, 1))]};
set(handles.text4, 'String', msg);
switch handles.Model.type
    case 1 % ANN
        handles.data(:, ind) = [];
        X = cell2mat(handles.data);
        y = Model.mdl(X');
        
    case 2 % SVM
        X = cell2mat(handles.data);
        y = svmpredict(Model.mdl, X');
end

% --- Executes on button press in tprctag.
function tprctag_Callback(hObject, eventdata, handles)
% hObject    handle to tprctag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in testtag.
function testtag_Callback(hObject, eventdata, handles)
% hObject    handle to testtag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
test_model(handles);
