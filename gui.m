function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 09-Sep-2014 08:35:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%__________________________________________________________________________
%                       SELECT STUDY SITE
%__________________________________________________________________________


% --- Executes on button press in browseHUCBasinBoundaryShapefileFilepath.
function browseHUCBasinBoundaryShapefileFilepath_Callback(hObject, ~,...
    handles)

% Get button status

browseHUCBasinBoundaryButtonStatus = get(hObject,'Value');

% Prompt user to select boundary shapefile

if browseHUCBasinBoundaryButtonStatus == 1

    [filename, pathname] = uigetfile('*.shp',...
        'Select HUC Basin Boundary Shapefile');
    basinBoundaryFilepath = [pathname,'/',filename];
    handles.hucCodeShapeStruct = shaperead(basinBoundaryFilepath,...
        'UseGeoCoords',true);
    
end

set(handles.textHUCBasinBoundaryShapefileFilepath,'String',...
    basinBoundaryFilepath);

% Update handles structure

guidata(hObject,handles);


% --- Executes on button press in browseStudySiteOverlayShapefileFilepath.
function browseStudySiteOverlayShapefileFilepath_Callback(hObject, ~, ...
    handles)

% Get button Status

browseStudySiteButtonStatus = get(hObject,'Value');

% Prompt user to select overlay shapefile

if browseStudySiteButtonStatus == 1
    
    [filename, pathname] = uigetfile('*.shp','Select Overlay Shapefile');
    overlayShapeFilepath = [pathname,'/',filename];
    handles.overlayShapeStruct = shaperead(overlayShapeFilepath,...
        'UseGeoCoords',true);
    
end

% Display filepath string

set(handles.textStudySiteOverlayShapefileFilepath,'String',...
    overlayShapeFilepath);

% Update handles structure

guidata(hObject,handles);


% --- Executes on button press in selectStudySiteLocationFromMap.
function selectStudySiteLocationFromMap_Callback(hObject, ~, handles)

% Get button status

selectStudySiteLocationButtonStatus = get(hObject,'Value');

if selectStudySiteLocationButtonStatus == 1
    
    [handles.hucCode, handles.hucIndex ] = getHucCodeFnc( ...
        handles.hucCodeShapeStruct, ...
        handles.overlayShapeStruct );
    
end

% Update handles structure

guidata(hObject,handles);

% Update Huc Code and Huc Index Strings

set(handles.inputHUCCode,'String',num2str(handles.hucCode));

% Update Handles structure

guidata(hObject,handles);


function inputHUCCode_Callback(hObject, ~, handles)

% Extract User input hucCode string

tmp = get(hObject,'String');
handles.hucCode = str2double(tmp);

% Update handles structure

guidata(hObject,handles);

% Find the matching hucIndex

hucField = str2double(extractfield(handles.hucCodeShapeStruct,'HUC10')');
handles.hucIndex = find(handles.hucCode == hucField);

% Update handles structure

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function inputHUCCode_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function inputGridDensity_Callback(hObject, ~, handles)

% Get user string inputs

tmp = get(hObject,'String');
handles.gridDensity = str2double(tmp);

% Update handles structure

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function inputGridDensity_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in extractGridMask.
function extractGridMask_Callback(hObject, ~, handles)

% Write default parameters

handles.gridDensity = 1116.99;

% Update handles structure

guidata(hObject,handles);

% Get button status

extractGridMaskButtonStatus = get(hObject,'Value');

% Plug in parameter values and extract the grid mask

if extractGridMaskButtonStatus == 1
    
    [handles.gridMask, ...
        handles.gridMaskGeoRasterRef ] = hucCode2GridMaskFnc( ...
        handles.hucCodeShapeStruct, ...
        handles.hucIndex, ...
        handles.gridDensity );
    
end

% Display Success message

set(handles.textExtractGridMaskSuccess,'String','Success!');

% Update handles structure

guidata(hObject,handles);


% --- Executes on button press in browseTopLevelRasterDataDirectoryPath.
function browseTopLevelRasterDataDirectoryPath_Callback(hObject, eventdata, handles)
% hObject    handle to browseTopLevelRasterDataDirectoryPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in browseTopLevelVectorDataDirectoryPath.
function browseTopLevelVectorDataDirectoryPath_Callback(hObject, eventdata, handles)
% hObject    handle to browseTopLevelVectorDataDirectoryPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in extractData.
function extractData_Callback(hObject, eventdata, handles)
% hObject    handle to extractData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
