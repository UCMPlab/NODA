function varargout = w2spectrum(varargin)
% W2SPECTRUM MATLAB code for w2spectrum.fig
%      W2SPECTRUM, by itself, creates a new W2SPECTRUM or raises the existing
%      singleton*.
%
%      H = W2SPECTRUM returns the handle to a new W2SPECTRUM or the handle to
%      the existing singleton*.
%
%      W2SPECTRUM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in W2SPECTRUM.M with the given input arguments.
%
%      W2SPECTRUM('Property','Value',...) creates a new W2SPECTRUM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before w2spectrum_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to w2spectrum_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help w2spectrum

% Last Modified by GUIDE v2.5 12-Feb-2016 17:08:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @w2spectrum_OpeningFcn, ...
    'gui_OutputFcn',  @w2spectrum_OutputFcn, ...
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

% --- Executes just before w2spectrum is made visible.
function w2spectrum_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to w2spectrum (see VARARGIN)

% Choose default command line output for w2spectrum
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
clearvars -global __ d;
clearvars -global __ spec;

% UIWAIT makes w2spectrum wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = w2spectrum_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in selectfolder.
function selectfolder_Callback(hObject, eventdata, handles)
% hObject    handle to selectfolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% p=uigetdir('C:\Users\Hossein\Dropbox\2016\01jan\25\w2');
global p;
global d;

p='C:\Users\Hossein\Dropbox\2016\01jan\25\';
p=uigetdir(p);
tmp=DA.readspec([p '\']);
name=strsplit(p,'\');
name=name{end};
d.(name)=tmp;
names=fieldnames(d);
set(handles.popupmenu1,'String',names);
for i=1:length(names)
    if strcmp(names{i},name)
        value = i;
    end
end

set(handles.popupmenu1,'Value',value);
updateplot_Callback(hObject, eventdata, handles)

function startindex_Callback(hObject,eventdata,handles)
handles.edit2data=str2double(get(hObject,'String'));
guidata(hObject,handles);
updateplot_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function startindex_CreateFcn(hObject, eventdata, handles)
% hObject    handle to startindex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function endindex_Callback(hObject, eventdata, handles)
% hObject    handle to endindex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of endindex as text
%        str2double(get(hObject,'String')) returns contents of endindex as a double
handles.edit3data=str2double(get(hObject,'String'));
guidata(hObject,handles);
updateplot_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function endindex_CreateFcn(hObject, eventdata, handles)
% hObject    handle to endindex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function data_index_Callback(hObject, eventdata, handles)
% hObject    handle to data_index (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of data_index as text
%        str2double(get(hObject,'String')) returns contents of data_index as a double
handles.dataindex=str2double(get(hObject,'String'));
guidata(hObject,handles);
updateplot_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function data_index_CreateFcn(hObject, eventdata, handles)
% hObject    handle to data_index (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in updateplot.
function updateplot_Callback(hObject, eventdata, handles)
% hObject    handle to updateplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global d;
start=str2double(get(handles.startindex,'String'));
end1=str2double(get(handles.endindex,'String'));
i=str2double(get(handles.data_index,'String'));
IP=str2double(get(handles.IP,'String'));
delta=str2double(get(handles.delta,'String'));
correction=str2double(get(handles.correction,'String'));
nmin=str2double(get(handles.n_min,'String'));
nmax=str2double(get(handles.n_max,'String'));
lineson = get(handles.lineson,'Value');

name = get(handles.popupmenu1,'String');
popmenu = get(handles.popupmenu1,'Value');
spec = d.(name{popmenu});
set(handles.text1,'String',['max=' num2str(length(spec))]);

ind=start:end1;
s=sum(spec(i).data(:,ind),2);
s=s-min(s);
s=s/max(s);
wl=spec(i).wl(:,1);
wl=vacuumcorrection(wl/2)*2;
Ryd=cons.Ryd/100;
ns=nmin:nmax;
wlscalc=2e7./(correction+IP-Ryd./(ns-delta).^2);
ax1=handles.axes1;
axes(ax1);
imagesc(wl,ind,spec(i).data(:,ind)');
ylim([start end1]);
set(ax1,'xtick',[]);
title(ax1,preptitle(spec(i).name));
ax2=handles.axes2;
plot(ax2,wl,s,'linewidth',1.5,'color','k')

xlabel(ax2,'Vacuum Wavelength (nm)','fontsize',11,'fontweight','bold');
set(ax2,'fontsize',11,'fontweight','bold','ytick',[]);
xlim(ax2,[min(wl) max(wl)]);
if lineson
    for i=1:length(ns)
        line([1 1]*wlscalc(i),[0,1],'color','r','parent',ax2);
    end
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
handles.name=get(hObject,'String');
guidata(hObject,handles);
updateplot_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function IP_Callback(hObject, eventdata, handles)
% hObject    handle to IP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of IP as text
%        str2double(get(hObject,'String')) returns contents of IP as a double
% handles.IP=get(hObject,'String');
guidata(hObject,handles);
updateplot_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function IP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to IP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function correction_Callback(hObject, eventdata, handles)
% hObject    handle to correction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of correction as text
%        str2double(get(hObject,'String')) returns contents of correction as a double
% handles.correction=get(hObject,'String');
guidata(hObject,handles);
updateplot_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function correction_CreateFcn(hObject, eventdata, handles)
% hObject    handle to correction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function delta_Callback(hObject, eventdata, handles)
% hObject    handle to delta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of delta as text
%        str2double(get(hObject,'String')) returns contents of delta as a double
% handles.delta=get(hObject,'String');
guidata(hObject,handles);
updateplot_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function delta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to delta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function n_min_Callback(hObject, eventdata, handles)
% hObject    handle to n_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of n_min as text
%        str2double(get(hObject,'String')) returns contents of n_min as a double
% handles.nmin=get(hObject,'String');
guidata(hObject,handles);
updateplot_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function n_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to n_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function n_max_Callback(hObject, eventdata, handles)
% hObject    handle to n_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of n_max as text
%        str2double(get(hObject,'String')) returns contents of n_max as a double
% handles.nmax=get(hObject,'String');
guidata(hObject,handles);
updateplot_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function n_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to n_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cleardata.
function cleardata_Callback(hObject, eventdata, handles)
% hObject    handle to cleardata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clearvars -global __ d;
clearvars -global __ spec;
cla(handles.axes1);
cla(handles.axes2);
delete(findall(findall(gcf,'Type','axe'),'Type','text'))
set(handles.popupmenu1,'String','no data');


% --- Executes on button press in lineson.
function lineson_Callback(hObject, eventdata, handles)
% hObject    handle to lineson (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lineson
guidata(hObject,handles);
updateplot_Callback(hObject, eventdata, handles)
