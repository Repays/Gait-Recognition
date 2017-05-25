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
folders = uipickfiles;
if(iscell(folders) == 1)
imagesPaths = cell2mat(folders(:));
guidata(hObject,imagesPaths);
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
imagesPaths = guidata(hObject);

if(isempty(imagesPaths) ~= 1)
    for i=1:size(imagesPaths)
      imm = imread(handles(i,:));
      rec = calculateRectangle(imm);
       % todo dodac do bazy
       % parametry kwadratu.
      rec
      % klasa do której nale¿y dodaæ.
      answer
    end
end




% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
net=narxnet()
view(net);


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
