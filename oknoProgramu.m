function varargout = oknoProgramu(varargin)
% OKNOPROGRAMU MATLAB code for oknoProgramu.fig
%      OKNOPROGRAMU, by itself, creates a new OKNOPROGRAMU or raises the existing
%      singleton*.
%
%      H = OKNOPROGRAMU returns the handle to a new OKNOPROGRAMU or the handle to
%      the existing singleton*.
%
%      OKNOPROGRAMU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OKNOPROGRAMU.M with the given input arguments.
%
%      OKNOPROGRAMU('Property','Value',...) creates a new OKNOPROGRAMU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before oknoProgramu_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to oknoProgramu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help oknoProgramu

% Last Modified by GUIDE v2.5 13-Jun-2017 14:13:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @oknoProgramu_OpeningFcn, ...
                   'gui_OutputFcn',  @oknoProgramu_OutputFcn, ...
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


% --- Executes just before oknoProgramu is made visible.
function oknoProgramu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to oknoProgramu (see VARARGIN)

% Choose default command line output for oknoProgramu
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes oknoProgramu wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = oknoProgramu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% Pobranie zdjêæ
function pickPictures_Callback(hObject, eventdata, handles)
imagesPaths = [];
elements = guidata(hObject);
folders = uipickfiles;

    if(iscell(folders) == 1)
        imagesPaths = cell2mat(folders(:));
    if isfield(elements,'net') && isfield(elements,'H') && isfield(elements,'W') && isfield(elements,'T')
        guidata(hObject,struct('images',imagesPaths, 'net',elements.net, 'H', elements.H, 'W', elements.W,'T',elements.T));
    elseif isfield(elements,'H') && isfield(elements,'W') && isfield(elements,'T')
        guidata(hObject,struct('images',imagesPaths,'H', elements.H,'W',elements.W,'T',elements.T));
    elseif isfield(elements,'net')
        guidata(hObject,struct('net',elements.net,'images',imagesPaths));
    else
        guidata(hObject,struct('images',imagesPaths));
    end
end

% Dodanie zdjeæ do bazy danych
function addToDatabase_Callback(hObject, eventdata, handles)
prompt = {'Ktora klasa:'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'1'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans); 
elements = guidata(hObject);
imagesPaths = elements.images;

X = [];
H = [];
W = [];
A = [];
B = [];
T =[];

if(isempty(imagesPaths) ~= 1)
    for i=1:size(imagesPaths)
      imm = imread(imagesPaths(i,:));
      rec = calculateRectangle(imm);
       A = [rec(3)];
       H = [H ; A];
       A = [rec(4)];
       W = [W ; A];
       B = str2double(answer);
       T = [T ; B];
    end  
    
     if isfield(elements,'H') && isfield(elements,'W')
        H1 = elements.H;
        H = [H1 ; H];
        W1 = elements.W;
        W = [W1 ; W];
        T1 = elements.T;
        T = [T1 ; T];
     end
    
    if isfield(elements,'net')
        guidata(hObject,struct('net',elements.net,'H',H,'W',W,'T',T));
    else
        guidata(hObject,struct('H',H,'W',W,'T',T));
    end
end

% --- Usuniecie bazy obrazów
function deleteFromDatabase_Callback(hObject, eventdata, handles)
guidata(hObject,0);

% --- Rozpoznawanie obrazu
function recognize_Callback(hObject, eventdata, handles)

elements = guidata(hObject);

if isfield(elements,'net')
    net = elements.net;
else
    disp('Nie nauczono sieci');
return
end

if isfield(elements,'images')
  imagesPaths = elements.images;
else
    disp('Nie wybrano zdjêæ');
return
end

X = [];
A = [];
T =[];
W = [];
H = [];
if(isempty(imagesPaths) ~= 1)
    for i=1:size(imagesPaths)
      imm = imread(imagesPaths(i,:));
      rec = calculateRectangle(imm);
       T = [T ; i];
       A = [rec(3)];
       H = [H ; A];
       A = [rec(4)];
       W = [W ; A];
    end
    W = transpose(W);
    H = transpose(H);
    T = transpose(T);

    X = [W;H];
    X = transpose(X);
    T = num2cell(T);

    X1 = tonndata(X, false, false);
    netc = closeloop(net);
    view(netc)
    [Xs,Xi,Ai,Ts] = preparets(netc,X1,{},T);
    y = netc(Xs,Xi,Ai)
end

% Uczy sieæ z danych przechowywanych w bazie
function learnDatabase_Callback(hObject, eventdata, handles)
elements = guidata(hObject);
X = [];
X1 = [];
T1 = [];
net = narxnet(1:2,1:2,20);
net.divideFcn = 'dividerand';
W = elements.W;
H = elements.H;
T = elements.T;

W = transpose(W);
H = transpose(H);
T = transpose(T);

X = [W;H];
X = transpose(X);
T1 = num2cell(T);

X1 = tonndata(X, false, false);
[Xs,Xi,Ai,Ts] = preparets(net,X1,{},T1);

net = train(net,Xs,Ts,Xi,Ai);
netc = closeloop(net);
[Xs,Xi,Ai,Ts] = preparets(netc,X1,{},T1);
net = train(netc,Xs,Ts,Xi,Ai);
view(net)
Y = net(Xs,Xi,Ai);
guidata(hObject,struct('net',net));

function edit1_Callback(hObject, eventdata, handles)
set(handles.Edit,'String',num_class);

% --- Executes during object creation, after setting all properties.
function Edit_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function test1_Callback(hObject, eventdata, handles)

% Hints: get(hObject,'String') returns contents of test1 as text
%        str2double(get(hObject,'String')) returns contents of test1 as a double


% --- Executes during object creation, after setting all properties.
function test1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to test1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

