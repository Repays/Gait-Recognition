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

% Last Modified by GUIDE v2.5 24-May-2017 21:19:12

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


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
imagesPaths = [];
elements = guidata(hObject);

folders = uipickfiles;
if(iscell(folders) == 1)
imagesPaths = cell2mat(folders(:));
%%guidata(hObject,imagesPaths);
if isfield(elements,'net')
    guidata(hObject,struct('images',imagesPaths,'net',elements.net));
else
guidata(hObject,struct('images',imagesPaths));
end
end



% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt = {'Ktora klasa:'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'1'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans); 
elements = guidata(hObject);
imagesPaths = elements.images;
X = [];
A = [];
B = [];
T =[];
TF =[];
if isfield(elements,'net')
net = elements.net;
else
net = narxnet(1:2,1:2,20);  
end
if(isempty(imagesPaths) ~= 1)
    for i=1:size(imagesPaths)
      imm = imread(imagesPaths(i,:));
      rec = calculateRectangle(imm);
       A = [rec(3)];
       X = [X ; A];
       B = str2double(answer);
       T = [T ; B];
       TF = [TF ; i];
    end  
    X = transpose(X);
    T = transpose(T);
    TF = transpose(TF);
    X1 = num2cell(X);
    T1 = num2cell(T);
    T2 = num2cell(TF);
    [Xs,Xi,Ai,Ts] = preparets(net,X1,{},T2);
    net = train(net,Xs,Ts,Xi,Ai);
    view(net)
    Y = net(Xs,Xi,Ai);
    perf = perform(net,Ts,Y)
    
    guidata(hObject,struct('net',net));
end




% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)

elements = guidata(hObject);
if isfield(elements,'net')
    net = elements.net;
else
Disp('Nie nauczono sieci');
return
end
if isfield(elements,'images')
  imagesPaths = elements.images;
else
Disp('Nie wybrano zdjêæ');
return
end
X = [];
A = [];
T =[];

if(isempty(imagesPaths) ~= 1)
    for i=1:size(imagesPaths)
      imm = imread(imagesPaths(i,:));
      rec = calculateRectangle(imm);
       A = [rec(3)];
       X = [X ; A];
       T = [T ; i];
    end  
 
end
   
X = transpose(X);
T = transpose(T);
X1 = num2cell(X);
T = num2cell(T);
netc = closeloop(net);
view(netc)
[Xs,Xi,Ai,Ts] = preparets(netc,X1,{},T);
y = netc(Xs,Xi,Ai);
y




function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Edit,'String',num_class);



% Hints: get(hObject,'String') returns contents of Edit as text
%        str2double(get(hObject,'String')) returns contents of Edit as a double


% --- Executes during object creation, after setting all properties.
function Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function test1_Callback(hObject, eventdata, handles)
% hObject    handle to test1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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
