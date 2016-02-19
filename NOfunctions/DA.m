% read NO class
classdef DA
    properties (Constant=true)
        titleflag=false;
        ylabelflag=false;
        fs=12;
        lw=1.3;
        fw='bold';
    end
    methods (Static)
        function initplot(psize)
            clf;clc;
            set(gcf,'PaperSize',psize,'PaperPosition',[0 0 psize(1) psize(2)]);
            hold on;
            set(gca,'fontsize',DA.fs,'fontweight',DA.fw,'linewidth',DA.lw/2);
        end
        function settitle(str)
            title(str,'fontsize',DA.fs,'fontweight',DA.fw);
        end
        function label(str,direction,visibility)
            if visibility
                if strcmp(direction,'x')
                    xlabel(str,'fontsize',DA.fs,'fontweight',DA.fw);
                elseif strcmp(direction,'y')
                    ylabel(str,'fontsize',DA.fs,'fontweight',DA.fw);
                end
            end
        end
        function path=preparepath(path)
            path1=['C:\Users\user\' path];
            path2=['D:\' path];
            path3=['C:\Users\hossein\' path];
            if exist(path1,'dir')
                path=path1;
            elseif exist(path2,'dir')
                path=path2;
            elseif exist(path3,'dir')
                path=path3;
            end
        end
        function d=readspec(path)
            path=DA.preparepath(path);
            f=dir(fullfile(path,'*.wf'));
            d=struct;
            for i=1:length(f)
                fprintf('%s\n',f(i).name);
                [d(i).data,d(i).wf,d(i).t,d(i).wl]=DAIO.readdat(path,f(i).name,0);
                d(i).name=f(i).name(13:end-3);
            end
        end
        function d=readPS(path, lines)
            path=DA.preparepath(path);
            f=dir(fullfile(path,'*.wf'));
            d=struct;
            for i=1:length(f)
                [d(i).t,d(i).v,d(i).wf]=DAIO.readwl(path,f(i).name, lines);
                d(i).v=d(i).v-d(i).v(1);
                d(i).name=f(i).name;
                d(i).EF=d(i).v;
                d(i).cf=fit(d(i).t(:),sort(d(i).EF(:)),fittype('smoothingspline'));
            end
        end
        function plotw1(spec,ind,xunit)
            if length(ind)>2
                y=sum(spec.data(:,ind),2);
            elseif length(ind)==2
                y=sum(spec.data(:,ind(1):ind(2)),2);
            end
            y=y-min(y);
            y=y/max(y);
            if strcmp(xunit,'nm')
                x=spec.wl;
                xstr='Wavelength (nm)';
            elseif strcmp(xunit,'cm-1') || strcmp(xunit,'wn')
                x=1e7./spec.wl;
                xstr='Wavenumber (cm^{-1})';
            end
            DA.initplot([8 6]);
            plot(x,y,'linewidth',DA.lw,'color','black');
            if DA.titleflag
                DA.settitle('Rotational Spectrum of NO');
            end
            xlim([min(x) max(x)]);
            DA.label(xstr,'x',true);
            DA.label('Intensity','y',DA.ylabelflag);
            set(gca,'ytick',[]);
            bg_color = get(gca,'Color');
            set(gca,'YColor',bg_color,'YTick',[])
            
            pbaspect([2,1,1]);
        end
        function plotpfi(spec,ind,ind2)
            y=sum(spec.data(:,ind(1):ind(2)),2);
            y2=sum(spec.data(:,ind2(1):ind2(2)),2);
            y=y-min(y);
            ymax=max(y);
            y=y/max(y);
            y2=y2-min(y2);
            y2=y2/ymax;
            x=1e6*spec.wl;
            x=x-x(1);
            xstr='Delay (us)';
            DA.initplot([8 6]);
            plot(x,y,'.','markersize',15*DA.lw,'color','black');
            plot(x,y2,'.','markersize',15*DA.lw,'color','red');
            if DA.titleflag
                DA.settitle('Delayed Pulsed Field');
            end
            xlim([min(x) max(x)]);
            DA.label(xstr,'x',true);
            DA.label('Intensity','y',DA.ylabelflag);
            set(gca,'ytick',[]);
            bg_color = get(gca,'Color');
            set(gca,'YColor',bg_color,'YTick',[])
            pbaspect([2,1,1]);
        end
        function plotpficompare(spec,ind)
            DA.initplot([8 6]);
            for i=1:length(spec)
                y=sum(spec(i).data(:,ind(1):ind(2)),2);
                y=y-min(y);
                y=y/max(y);
                x=1e6*spec(i).wl;
                x=x-x(1);
                xstr='Delay (us)';
                plot(x,y,'linewidth',DA.lw,'color',[i-1 i-1 i-1]/length(spec)/1.1);
                if DA.titleflag
                    DA.settitle('Delayed Pulsed Field');
                end
                xlim([min(x) max(x)]);
                DA.label(xstr,'x',true);
                DA.label('Intensity','y',DA.ylabelflag);
                set(gca,'ytick',[]);
                bg_color = get(gca,'Color');
                set(gca,'YColor',bg_color,'YTick',[])
                pbaspect([2,1,1]);
            end
        end
        function cc=plotw2(spec,ind,xunit,fitflag,cc)
            if fitflag
                cc=cons.fitgauss(spec.t,spec.data,ind,'fixed');
            end
            y=cc(:,1);
            y=y-min(y);
            y=y/max(y);
            if strcmp(xunit,'nm')
                x=spec.wl/2;
                xstr='Wavelength (nm)';
            elseif strcmp(xunit,'cm-1') || strcmp(xunit,'wn')
                x=2*1e7./spec.wl;
                xstr='Wavenumber (cm^{-1})';
            end
            DA.initplot([8 6]);
            plot(x,y,'linewidth',DA.lw,'color','black');
            if DA.titleflag
                DA.settitle('Rydberg Spectrum of NO');
            end
            xlim([min(x) max(x)]);
            ylim([-0.05 1.05]);
            DA.label(xstr,'x',true);
            DA.label('Intensity','y',DA.ylabelflag);
            set(gca,'ytick',[]);
            bg_color = get(gca,'Color');
            set(gca,'YColor',bg_color,'YTick',[])
            
            pbaspect([2,1,1]);
        end
        function [path, pathstem]=resultpath(originaldate,name)
            cl=datevec(originaldate);
            if exist('l:\','dir')
                pathstem=['L:\Matlab\NOresults\' num2str(cl(1)) ...
                    '\' num2str(cl(2)) '\' num2str(cl(3)) '\'];
            else
                pathstem=['d:\Matlab\NOresults\' num2str(cl(1)) ...
                    '\' num2str(cl(2)) '\' num2str(cl(3)) '\'];
            end
            path=[pathstem name '\'];
            if ~exist(path,'dir')
                mkdir(path);
            end
        end
        function saveplot(originaldate,name)
            resultpath=DA.resultpath(originaldate,name);
            name=[name '-' originaldate];
            print([resultpath name '-' cons.gettimedate() '.pdf'],'-dpdf','-r600');
            fclose('all');
        end
        function d=fixdatasize(d)
            if length(d)>1
                fprintf('One at a time!\n');
            else
                if size(d.databkp)~=0
                    fprintf('Make sure you''re not overwritting data\n');
                else
                    d.databkp=d.data;
                    [a,b]=size(d.data);
                    temp=reshape(d.data',[b*2,a/2])';
                    d.data=temp;
                    d.wfbkp=d.wf;
                    d.wf(3)=d.wf(3)*2;
                    d.wf(5)=d.wf(5)/2;
                    d.t=linspace(0,d.wf(5)*d.wf(3),d.wf(3))-d.wf(6);
                    if a/2~=length(d.wl)
                        minlen=min(a/2,length(d.wl));
                        d.wl=d.wl(1:minlen);
                        d.data=d.data(1:minlen,:);
                    end
                end
            end
        end
        function d=resetdatasize(d)
            d.data=d.databkp;
            d.wf=d.wfbkp;
            d.wfbkp=[];
            d.databkp=[];
        end
        function x=fitns(wl,g)
            wl=sort(wl);
            n=length(wl)-1:-1:0;
            wavenum=1e7./wl;
            Ryd=109737.316;
            function o=obj(x)
                delta=x(3);
                n=length(wl)-1:-1:0;
                n=n+fix(x(2));
                o=wavenum'-(x(1)-Ryd./(n-delta).^2);
            end
            x=lsqnonlin(@(x)obj(x),[30544.2333070219,g(1),g(2)]);
        end
        function x=fitnsqd(wl,qd,g)
            wl=sort(wl);
            wavenum=1e7./wl;
            Ryd=109737.316;
            function o=obj(x)
                n=length(wl)-1+fix(x(2)):-1:fix(x(2));
                o=wavenum'-(x(1)-Ryd./(n-qd).^2);
            end
            x=lsqnonlin(@(x)obj(x),[30544.2333070219,g]);
        end
        function n=wlton(wl,xx)
            Ryd=1.097373160000000e+05;
            n=sqrt(Ryd./(xx(1)-1e7./wl))+xx(2)-fix(xx(2));
        end
        function n=wltonqd(wl,IP)
            Ryd=1.097373160000000e+05;
            n=sqrt(Ryd./(IP-1e7./wl));
        end
        function wl=ntowl(n,xx)
            Ryd=1.097373160000000e+05;
            % 10 973 731.6
            wl=1e7./(xx(1)-Ryd./(n-xx(2)).^2);
        end
    end
end