function varargout = Main(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Main_OpeningFcn, ...
                   'gui_OutputFcn',  @Main_OutputFcn, ...
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


% --- Executes just before Main is made visible.
function Main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Main (see VARARGIN)

% Choose default command line output for Main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clearvars -global;
global cam ;
cam = webcam('HP TrueVision HD Camera');
preview(cam);
set(handles.pushbutton5,'Visible','on');
set(handles.pushbutton5,'Enable','on');
guidata(hObject,handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clearvars -global;
global cam ;
% HP TrueVision HD Camera
% Logitech HD Pro Webcam C920
cam = webcam('HP TrueVision HD Camera');        
preview(cam);
fileID = fopen('numberDataBase.txt','r');
        n = fscanf(fileID,'%d');
        n = n+1;
        fileID = fopen('numberDataBase.txt','w');
        fprintf(fileID,'%d',n);
        %creating new row in attendance excel sheet
        data = xlsread('attendance.xlsx');
        new = zeros(1, size(data,2));
        new(2) = n;
        %new(size(data,2)) = 1;
        data = [data;new];
        xlswrite('attendance.xlsx',data);
        %create a directory for new worker and move to it
        mkdir(strcat('s',num2str(n)));
        global p;
        p = strcat('s',num2str(n));
        p = strcat(p,'/');
        %cd(strcat('s',num2str(n)));
        %taking images to database
        set(handles.text2,'String','We need 10 images of you');
        set(handles.pushbutton4,'Enable','on')
        set(handles.pushbutton4,'Visible','on')
        global x;
        x = 1;
        guidata(hObject,handles)
function dmessage_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function frequency_axes_Createfcn(varargin)

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;
global p;
global cam;
     if(x < 11)
            x = x+1;
            img = snapshot(cam);
            img = rgb2gray(img);
            img = imresize(img, [112,92]);
            imwrite(img,[strcat(p,num2str(x-1)),'.pgm']);
     else
        set(handles.pushbutton4,'Visible','off')
        set(handles.pushbutton4,'Enable','off')
        closePreview(cam);
        %cd ..
        set(handles.text2,'String','Added Successfully & Attendance Recorded'); 
     end
     guidata(hObject,handles)

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)   img = snapshot(cam);
global cam;
img = snapshot(cam);
    set(handles.pushbutton5,'Visible','off')
    set(handles.pushbutton5,'Enable','off')
    img = rgb2gray(img);
    img = imresize(img, [112,92]);
    closePreview(cam);
    x = faceRecognition(img);
    if(mod(x,10)==0)
        x = x/10;
    else
        x = floor(x/10) + 1;
    end
    %adding attendance of worker x in excel sheet
    data = xlsread('attendance.xlsx');
    data(x, size(data,2)) = 1;
    xlswrite('attendance.xlsx',data);
    if isempty(x)==0
        set(handles.text2,'String','Your Attendance Added Successfully');
    end
    clearvars -global;
    guidata(hObject,handles)
