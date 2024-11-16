function varargout = Interface_espectrofotometro_v1(varargin)
% INTERFACE_ESPECTROFOTOMETRO_V1 MATLAB code for Interface_espectrofotometro_v1.fig
%      INTERFACE_ESPECTROFOTOMETRO_V1, by itself, creates a new INTERFACE_ESPECTROFOTOMETRO_V1 or raises the existing
%      singleton*.
%
%      H = INTERFACE_ESPECTROFOTOMETRO_V1 returns the handle to a new INTERFACE_ESPECTROFOTOMETRO_V1 or the handle to
%      the existing singleton*.
%₢
%      INTERFACE_ESPECTROFOTOMETRO_V1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERFACE_ESPECTROFOTOMETRO_V1.M with the given input arguments.
%
%      INTERFACE_ESPECTROFOTOMETRO_V1('Property','Value',...) creates a new INTERFACE_ESPECTROFOTOMETRO_V1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Interface_espectrofotometro_v1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Interface_espectrofotometro_v1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Interface_espectrofotometro_v1

% Last Modified by GUIDE v2.5 27-Feb-2024 14:03:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Interface_espectrofotometro_v1_OpeningFcn, ...
                   'gui_OutputFcn',  @Interface_espectrofotometro_v1_OutputFcn, ...
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


% --- Executes just before Interface_espectrofotometro_v1 is made visible.
function Interface_espectrofotometro_v1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Interface_espectrofotometro_v1 (see VARARGIN)

% Choose default command line output for Interface_espectrofotometro_v1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Interface_espectrofotometro_v1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);
clear all
global ard wavelength count AA BB passostotais x steps slit pararmedida parargoto tempo countlamp countfiltro;
tempo = 0.1; % tempo de 0.1 segundos para nao ficar tao rapido o plot da intensidade.
AA = -0.783;
BB = 1151.9738;
passostotais = 1216;
slit = 1;
x(1,1) = 1;
x(2,1) = 2;
ports = serialportlist; 
ard = serialport('COM3',9600);
%ard.Timeout = 1; 
clear ports;
pause(2); % time to boot
configureTerminator(ard,"CR");
flush(ard);

write(ard,'i','char');
tic  % delete later
while(true)
    numBytes = ard.NumBytesAvailable;
    toc  % delete later
    if numBytes > 0
        break
    end
end
count = 0;
steps = 0;
wavelength = AA*count + BB;
pararmedida = 0;
parargoto = 0;
countlamp = 0;
countfiltro = 0;
flush(ard);





% --- Outputs from this function are returned to the command line.
function varargout = Interface_espectrofotometro_v1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function IntensityEdit_Callback(hObject, eventdata, handles)
% hObject    handle to IntensityEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of IntensityEdit as text
%        str2double(get(hObject,'String')) returns contents of IntensityEdit as a double


% --- Executes during object creation, after setting all properties.
function IntensityEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to IntensityEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function WavelengthEdit_Callback(hObject, eventdata, handles)
% hObject    handle to WavelengthEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of WavelengthEdit as text
%        str2double(get(hObject,'String')) returns contents of WavelengthEdit as a double


% --- Executes during object creation, after setting all properties.
function WavelengthEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WavelengthEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in GoToButton.
function GoToButton_Callback(hObject, eventdata, handles)
% hObject    handle to GoToButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ard wavelength count AA BB passostotais vapara steps tempo countlamp time countfiltro;
flush(ard);
set(handles.StartAquisitionButton,'Enable','off');
set(handles.IntensityButton,'Enable','off');
set(handles.GoToButton,'Enable','off');
message = 'Going to desired wavelength!';
set(handles.MessageEdit, 'String', message);

mensagem = 0;
wavelength = AA*count + BB;
set(handles.WavelengthEdit, 'String', wavelength);
vapara = str2num(get(handles.GoToEdit, 'String'));
steps = ((vapara -BB)/AA)-count; % colocar ponto e virgula no futuro
stepsard = abs(steps);
formatSpec = 'j%.0f\r';
send = sprintf(formatSpec,stepsard);
write(ard,send,'char');

pause(tempo);                              	%Melhor deixar este pause para garantir
while(true)                                 %deletar no futuro, so para conferir se esta ok.
    numBytes = ard.NumBytesAvailable;
    if numBytes > 0
        break
    end
end                                         %deletar no futuro, so para conferir se esta ok.
retorno = read(ard,numBytes,"String")       %deletar no futuro, so para conferir se esta ok.


if steps > 0 && count+steps<passostotais
    write(ard,'g','char');
    count = count+round(steps);
    while(true)  % Este while é para esperar o motor chegar até a posiçao final.
        numBytes = ard.NumBytesAvailable;
        if numBytes > 0
            break
        end
    end
    retorno = read(ard,numBytes,"String")
elseif steps < 0 && count+steps>0
    write(ard,'h','char');
    count = count+round(steps);
    while(true) % Este while é para esperar o motor chegar até a posiçao final.
        numBytes = ard.NumBytesAvailable;
        if numBytes > 0
            break
        end
    end
    retorno = read(ard,numBytes,"String") 
else
    message = 'Check wavelength!';
    set(handles.MessageEdit, 'String', message);
    mensagem = 1;
end

wavelength = (AA*count) + BB;
set(handles.WavelengthEdit, 'String', wavelength);
% implementando a troca de lampada
    if wavelength < 300 && countlamp == 0
        write(ard,'e','char');
        pause(time);
        write(ard,'u','char');
        countlamp=1;
    elseif wavelength > 300 && countlamp == 1
        write(ard,'c','char');
        pause(time);
        write(ard,'v','char');
        countlamp=0;
    end
% finalizando a troca de lampada

    if wavelength > 470 && wavelength < 815 && countfiltro == 0
        write(ard,'f','char');
        pause(10);
        countfiltro=1;
    elseif wavelength < 470 && countfiltro == 1 || wavelength > 815 && countfiltro == 1
        write(ard,'f','char');
        pause(10);
        countfiltro=0;
    end

set(handles.StartAquisitionButton,'Enable','on');
set(handles.IntensityButton,'Enable','on');
set(handles.GoToButton,'Enable','on');
if (mensagem == 0)
    message = 'Ready!';
    set(handles.MessageEdit, 'String', message);
end





function GoToEdit_Callback(hObject, eventdata, handles)
% hObject    handle to GoToEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gotowavelength = str2double(get(handles.GoToEdit,'String'));
assignin('base','gotowavelength',gotowavelength);
% Hints: get(hObject,'String') returns contents of GoToEdit as text
%        str2double(get(hObject,'String')) returns contents of GoToEdit as a double


% --- Executes during object creation, after setting all properties.
function GoToEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GoToEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FilenameEdit_Callback(hObject, eventdata, handles)
% hObject    handle to FilenameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FilenameEdit as text
%        str2double(get(hObject,'String')) returns contents of FilenameEdit as a double


% --- Executes during object creation, after setting all properties.
function FilenameEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FilenameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SaveButton.
function SaveButton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;
handles.Filename = get(handles.FilenameEdit, 'String');
if x(1,1) > x(2,1)
    x = flipud(x);
end
out = x;
save (handles.Filename, 'out', '-ascii', '-append');



function FromEdit_Callback(hObject, eventdata, handles)
% hObject    handle to FromEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FromEdit as text
%        str2double(get(hObject,'String')) returns contents of FromEdit as a double


% --- Executes during object creation, after setting all properties.
function FromEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FromEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ToEdit_Callback(hObject, eventdata, handles)
% hObject    handle to ToEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ToEdit as text
%        str2double(get(hObject,'String')) returns contents of ToEdit as a double


% --- Executes during object creation, after setting all properties.
function ToEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ToEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in StartAquisitionButton.
function StartAquisitionButton_Callback(hObject, eventdata, handles)
% hObject    handle to StartAquisitionButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ard wavelength count AA BB passostotais x steps tempo pararmedida linha countlamp countfiltro;
flush(ard);
pararmedida = 0;
set(handles.StartAquisitionButton,'Enable','off');
set(handles.IntensityButton,'Enable','off');
set(handles.GoToButton,'Enable','off');

    
wavelength = (AA*count) + BB;
set(handles.WavelengthEdit, 'String', wavelength);

start = str2double(get(handles.FromEdit, 'String'));
final = str2double(get(handles.ToEdit, 'String'));
integrationtime = str2double(get(handles.NumberAquisitionEdit, 'String'));

formatSpec = 'p%.0f\r';
send = sprintf(formatSpec,integrationtime);
write(ard,send,'char');

while(true)                                 %deletar no futuro, so para conferir se esta ok. colocar pause tempo.
    numBytes = ard.NumBytesAvailable;           
    if numBytes > 0
        break
    end
end
retorno = read(ard,numBytes,"String")       %deletar no futuro, so para conferir se esta ok. colocar pause tempo.

startcount = ((-BB + start)/AA);
finalcount = ((-BB + final)/AA);

steps = startcount-count % colocar ponto e virgula no futuro.
stepsard = abs(steps);
formatSpec = 'j%.0f\r';
send = sprintf(formatSpec,stepsard);
write(ard,send,'char');

while(true)                                 %deletar no futuro, so para conferir se esta ok. colocar pause tempo.
    numBytes = ard.NumBytesAvailable;           
    if numBytes > 0
        break
    end
end
retorno = read(ard,numBytes,"String")       %deletar no futuro, so para conferir se esta ok. colocar pause tempo

message = 'Going to starting wavelength!';
set(handles.MessageEdit, 'String', message);
pause(tempo);

if steps > 0 && count+steps<passostotais
    write(ard,'g','char');
    count = count+round(steps);
    while(true)  % Este while é para esperar o motor chegar até a posiçao final.
        numBytes = ard.NumBytesAvailable;
        if numBytes > 0
            break
        end
    end
    retorno = read(ard,numBytes,"String")

elseif steps < 0 && count+steps>0
    write(ard,'h','char');
    count = count+round(steps);
    while(true) % Este while é para esperar o motor chegar até a posiçao final.
        numBytes = ard.NumBytesAvailable;
        if numBytes > 0
            break
        end
    end
    retorno = read(ard,numBytes,"String") 
else
    message = 'Check wavelength range!';
    set(handles.MessageEdit, 'String', message);
end

% terminou de ir para posição inicial de aquisição. Agora começa a medida


message = 'Acquiring!';
set(handles.MessageEdit, 'String', message);


steps = finalcount - count % colocar ponto e virgula no futuro


if steps > 0 && count+steps<passostotais
    linha = 1;
    for k=1:1:abs(round(steps))
        write(ard,'m','char');
        pause(tempo);
        count = count+1;
        while(true)
            numBytes = ard.NumBytesAvailable;
            if numBytes > 0
                break
            end
        end
        wavelength = (AA*count) + BB;
        set(handles.WavelengthEdit, 'String', wavelength);
        % implementando a troca de lampada para o UV
        if wavelength > 300 && countlamp==1
            write(ard,'c','char');
            pause(tempo);
            write(ard,'v','char');
            pause(10); %colocar tempo de estabilizaçao para aquecimento da lampada
            countlamp=0;
        end
        if wavelength < 300 && countlamp==0
            write(ard,'e','char');
            pause(tempo);
            write(ard,'u','char');
            pause(10); %colocar tempo de estabilizaçao para aquecimento da lampada
            countlamp=1;
        end
        % finalizando a troca de lampada
        
                % implementando a entrada do filtro de ND
        if wavelength < 815 && wavelength > 470 && countfiltro==0
            write(ard,'f','char');
            pause(10);
            countfiltro=1;
        end
        if wavelength < 470 && countfiltro==1
            write(ard,'f','char');
            pause(10);
            countfiltro=0;
        end
        % finalizando a entrada do filtro de ND
        
        intensity = str2num(read(ard,numBytes,'String'));
        set(handles.IntensityEdit, 'String', intensity);
         % ------------------------------------------------------
        write(ard,'a','char');
        pause(tempo);
        while(true)
            numBytes = ard.NumBytesAvailable;
            if numBytes > 0
                break
            end
        end
        intensity2 = str2num(read(ard,numBytes,'String'));
        set(handles.Intensity2Edit, 'String', intensity2);
%         % ------------------------------------------------------
%         PlotData = plot(wavelength, intensity, 'bo', wavelength, intensity2, 'ro');
% 	    hold on;
% 	    %axis([0 10 0 260]);
% 	    xlabel('Wavelength (nm)');
%         ylabel('Intensity (a.u.)');
%         % ------------------------------------------------------
        intensity3 = intensity/intensity2;
        %PlotData = plot(wavelength, intensity3, 'bo');
        PlotData = plot(wavelength, intensity, 'bo', wavelength, intensity2, 'ro');
        hold on;
        xlabel('Wavelength (nm)');
        ylabel('Intensity (a.u.)');
        x(linha,1) = wavelength;
        x(linha,2) = intensity;
        x(linha,3) = intensity2;
        x(linha,4) = intensity3;
        linha=linha+1;
        if pararmedida == 1
            break
        end
    end
end

if steps < 0 && count+steps>0
    linha = 1;
    for k=1:1:abs(round(steps))
        write(ard,'n','char');
        pause(tempo);
        count = count-1;
        while(true)
            numBytes = ard.NumBytesAvailable;
            if numBytes > 0
                break
            end
        end
        intensity = str2num(read(ard,numBytes,'String'));
        set(handles.IntensityEdit, 'String', intensity);
        wavelength = (AA*count) + BB;
        set(handles.WavelengthEdit, 'String', wavelength);
        % implementando a troca de lampada para o visivel
        if wavelength < 300 && countlamp==0
            write(ard,'e','char');
            pause(tempo);
            write(ard,'u','char');
            pause(10); %colocar tempo de estabilizaçao para aquecimento da lampada
            countlamp=1;
        end
        if wavelength > 300 && countlamp==1
            write(ard,'c','char');
            pause(tempo);
            write(ard,'v','char');
            pause(10); %colocar tempo de estabilizaçao para aquecimento da lampada
            countlamp=0;
        end
    	% finalizando a troca de lampada
        
          % implementando a entrada do filtro de ND
        if wavelength > 470 && wavelength < 815 && countfiltro==0
            write(ard,'f','char');
            pause(10);
            countfiltro=1;
        end
        if wavelength > 815 && countfiltro==1
            write(ard,'f','char');
            pause(10);
            countfiltro=0;
        end
        % finalizando a entrada do filtro de ND
        %---------------------------------------------------------------
        write(ard,'b','char');
        pause(tempo);
        while(true)
            numBytes = ard.NumBytesAvailable;
            if numBytes > 0
                break
            end
        end
        intensity2 = str2num(read(ard,numBytes,'String'));
        set(handles.Intensity2Edit, 'String', intensity2);
%         % ------------------------------------------------------
%         PlotData = plot(wavelength, intensity, 'bo', wavelength, intensity2, 'ro');
% 	    hold on;
%         xlabel('Wavelength (nm)');
%         ylabel('Intensity (a.u.)');
%         % ------------------------------------------------------
        intensity3 = intensity/intensity2;
        PlotData = plot(wavelength, intensity, 'bo', wavelength, intensity2, 'ro');
        hold on;
        xlabel('Wavelength (nm)');
        ylabel('Intensity (a.u.)');
        x(linha,1) = wavelength;
        x(linha,2) = intensity;
        x(linha,3) = intensity2;
        x(linha,4) = intensity3;
        linha = linha+1;
        if pararmedida == 1
            break
        end
    end
end

%delisgando o motor
write(ard,'d','char');

set(handles.StartAquisitionButton,'Enable','on');
set(handles.IntensityButton,'Enable','on');
set(handles.GoToButton,'Enable','on');
message = 'Ready!';
set(handles.MessageEdit, 'String', message);





% --- Executes on button press in StopAquisitionButton.
function StopAquisitionButton_Callback(hObject, eventdata, handles)
% hObject    handle to StopAquisitionButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pararmedida;
pararmedida = 1;



function NumberAquisitionEdit_Callback(hObject, eventdata, handles)
% hObject    handle to NumberAquisitionEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NumberAquisitionEdit as text
%        str2double(get(hObject,'String')) returns contents of NumberAquisitionEdit as a double


% --- Executes during object creation, after setting all properties.
function NumberAquisitionEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumberAquisitionEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PortEdit_Callback(hObject, eventdata, handles)
% hObject    handle to PortEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PortEdit as text
%        str2double(get(hObject,'String')) returns contents of PortEdit as a double


% --- Executes during object creation, after setting all properties.
function PortEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PortEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function StatusEdit_Callback(hObject, eventdata, handles)
% hObject    handle to StatusEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StatusEdit as text
%        str2double(get(hObject,'String')) returns contents of StatusEdit as a double


% --- Executes during object creation, after setting all properties.
function StatusEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StatusEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SlitButton.
function SlitButton_Callback(hObject, eventdata, handles)
% hObject    handle to SlitButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global slit ard
% Mudando a fenda

write(ard,'f','char');
slit = slit + 1;
if slit > 7
    slit = 1;
end
set(handles.SlitEdit, 'String', slit);



function SlitEdit_Callback(hObject, eventdata, handles)
% hObject    handle to SlitEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SlitEdit as text
%        str2double(get(hObject,'String')) returns contents of SlitEdit as a double


% --- Executes during object creation, after setting all properties.
function SlitEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SlitEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in StopGoToButton.
function StopGoToButton_Callback(hObject, eventdata, handles)
% hObject    handle to StopGoToButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global parargoto;
parargoto = 1;

% --- Executes on button press in ClearButton.
function ClearButton_Callback(hObject, eventdata, handles)
% hObject    handle to ClearButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;
x=0;
x(1,1) = 1;
x(2,1) = 2;
cla(handles.axes);


% --- Executes on button press in IntensityButton.
function IntensityButton_Callback(hObject, eventdata, handles)
% hObject    handle to IntensityButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ard parargoto count AA BB tempo x;
flush(ard);
parargoto = 0;
set(handles.StartAquisitionButton,'Enable','off');
set(handles.IntensityButton,'Enable','off');
set(handles.GoToButton,'Enable','off');
message = 'Acquiring Intensity!';
set(handles.MessageEdit, 'String', message);

wavelength = (AA*count) + BB;
set(handles.WavelengthEdit, 'String', wavelength);

integrationtime = str2num(get(handles.NumberAquisitionEdit, 'String'));

formatSpec = 'p%.0f\r';
send = sprintf(formatSpec,integrationtime);
write(ard,send,'char');


while(true) % deixar um pause pause(tempo); no local deste while.
    numBytes = ard.NumBytesAvailable;
    if numBytes > 0
        break
    end
end
retorno = read(ard,numBytes,"String") % Vamos ter que eliminar essa e as 6 linhas acima. Era so para conferir se esta retornando ok.


linha=1;
numBytes = 0;
tic
while (parargoto == 0)
    write(ard,'x','char');
    pause(tempo) % pause para nao ficar tao rapido o plot
  while(true)
    numBytes = ard.NumBytesAvailable;
    if numBytes > 0
        break
    end
  end
    intensity = str2num(read(ard,numBytes,'String'));
    set(handles.IntensityEdit, 'String', intensity);
    tempo1 = toc;
    

    write(ard,'z','char');
    pause(tempo) % pause para nao ficar tao rapido o plot
   while(true)
    numBytes = ard.NumBytesAvailable;
    if numBytes > 0
        break
    end
  end
    intensity2 = str2num(read(ard,numBytes,'String'));
    set(handles.Intensity2Edit, 'String', intensity2);
    tempo2 = toc;
    PlotData = plot(tempo1, intensity, 'bo', tempo2, intensity2, 'ro');
    hold on;
	%axis([0 10 0 260]);
	xlabel('Time(seconds)');
    ylabel('Intensity (a.u.)'); 
    x(linha,1) = tempo1;
    x(linha,2) = intensity;
    x(linha,3) = tempo2;
    x(linha,4) = intensity2;
    linha=linha+1;
end

set(handles.StartAquisitionButton,'Enable','on');
set(handles.IntensityButton,'Enable','on');
set(handles.GoToButton,'Enable','on');
message = 'Ready!';
set(handles.MessageEdit, 'String', message);



function MessageEdit_Callback(hObject, eventdata, handles)
% hObject    handle to MessageEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MessageEdit as text
%        str2double(get(hObject,'String')) returns contents of MessageEdit as a double


% --- Executes during object creation, after setting all properties.
function MessageEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MessageEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Intensity2Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Intensity2Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Intensity2Edit as text
%        str2double(get(hObject,'String')) returns contents of Intensity2Edit as a double


% --- Executes during object creation, after setting all properties.
function Intensity2Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Intensity2Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
