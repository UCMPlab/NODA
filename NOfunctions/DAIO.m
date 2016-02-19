classdef DAIO
    %DAIO Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Static=true)
        function [dat,wf,t,wl] = readdat(path, fname, ind)
            
            wf = DAIO.readwf(path, fname); % read the .wf files to get the parameters
            % filename should be imported as something .wf
            num_points = wf(3); % the 3rd parameter from .wf file is the # of points
            
            fname = regexprep(fname, '.wf', '.dat'); % now the file is the data file
            file = [path, fname];
            fid = fopen(file);
            rawdat = fread(fid, inf, 'uint16', 'b'); %the data is saved in int16 format...
            % rawdat = fread(fid, inf, 'int16', 'b'); %the data is saved in int16 format...
            fclose(fid);
            dat=DAIO.processdat(rawdat,num_points,wf,ind);
            t=DAIO.buildt(wf,num_points);
            wl=DAIO.wlfileuni(path,fname);
            fclose('all');
        end
        function t=buildt(wf,num_points)
            t0=wf(6);   % initial scope time
            tinc=wf(5); % time increment
            tf=tinc*num_points+t0;
            t=1e6*linspace(t0,tf,num_points);
        end
        function dat=processdat(rawdat,num_points,wf,ind)
            dat = reshape(rawdat, num_points, max(size(rawdat))/num_points); %just reshape it
            dat = double(dat'); %convert to double
            dat=-dat*wf(8); %convert to mV
            if ind>0
                dat=dat-mean(dat(:,1:ind),2)*ones(1,wf(3)); %substract back ground
            end
        end
        function wl=wlfile(fname,path,lines)
            fname = regexprep(fname, '.dat', '.wl');
            wl=importdata([path fname],'\t',lines);
            wl=wl.data(:,:);
        end
        function wf=readwf(path,fname)
            if isempty(fname)
                fdir=dir(path);
                for i=1:size(fdir)
                    if strfind(fdir(i).name,'.wf')
                        fname=[path fdir(i).name];
                    end
                end
            else
                fname=[path fname];
            end
            
            fID=fopen(fname);
            wf(1)=double(fread(fID,1,'int16=>int16','b'));
            wf(2)=fread(fID,1,'int16=>int16','b');
            wf(3)=fread(fID,1,'int32=>int32','b');
            wf(4)=fread(fID,1,'int32=>int32','b');
            wf(5)=fread(fID,1,'double=>double','b');
            wf(6)=fread(fID,1,'double=>double','b');
            wf(7)=fread(fID,1,'int32=>int32','b');
            wf(8)=fread(fID,1,'double=>double','b');
            wf(9)=fread(fID,1,'double=>double','b');
            wf(10)=fread(fID,1,'int32=>int32','b');
            fclose('all');
        end
        function [t,d,wf]=readwl(path,fname,lines)
            fname2=regexprep(fname,'.wf','.wl');
            d=importdata([path fname2],'\t',lines);
            wf=DAIO.readwf(path,fname)';
            d=d.data;
            t=(d(:,1)'+wf(6))*1e6;
            d=d(:,2)'*wf(8);
            fclose('all');
        end
        function wl=wlfileuni(path,fname)
            fname2=regexprep(fname,'.dat','.wl');
            fid=fopen([path fname2]);
            tline = fgetl(fid);
            while ~strcmp(tline,'#START')
                tline=fgetl(fid);
                if tline==-1
                    break;
                end
            end
            q=1;
            while ~feof(fid)
                tline=fgetl(fid);
                tline=strsplit(tline,'\t');
                wl(q,:)=str2double(tline);
                q=q+1;
            end
            fclose(fid);
            fclose('all');
        end
    end
    
end

