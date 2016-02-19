% Set date.  Determine path
clear;clc;
originaldate='06-Feb-2016';
path='D:\data\2016\02feb\06';
pfi=DA.readspec([path 'pfi\']); % pfi; pfi_1kV; pfi_2kV; pfi_3kV
ps=DA.readPS([path 'psretake\'], 19); % 1.5/3/2/1kV ramp. "19" is the number of top rows to be ommited (header stuff)
% 
% Look at first complete pfi
clf;
imagesc(pfi(3).data);
%% 
% Split pfi according to ramp delays ... d(i) for i=1 to #ramp delays.
% Step through values of j to choose different pfi data files
%    del = ramp delay (delay between w2 and start of ramp) 
%    del2 = density delay (delay between w1 and w2)
j=3;  
d=splitpfi(pfi(j));
del=unique(pfi(j).wl(: ,2));  % Select unique ramp delay values
del=del-min(del);del=del*1e6; % Relative to absolute delay. Scale change.
del2=d(j).del;
% 
% pcolor plots of raw data 
% Step through ramp delays
for k=1:length(del)
    clf;
    pcolor(d(k).data);
%     s1='d(';
%     s2=sprintf('%.0f',k);
%     s3=').dat';
%     s=[s1 s2 s3];
%     title(s);
    title(['d(' num2str(k) ').dat']);
    shading interp;
    pause(1);
end
%% 
% change axis units
%
dist=4.55; %distance between G1 and G2 
% ishift=round(length(d(1).t)*0.04287/2);  % 40ns arrival time for electrons at G2.
%
% devided by 2 because the scope has a total of 2 microseconds 
%(unless different settings are used which require this number to be changed too)

%vv=ps.EF;
% index=length(d(1).t)-length(vv); 
% if index>0
%     vv=[vv zeros(1,index)];
% end gg=[vv zeros(1,ishift)]; vv=gg(ishift+1:end);
%vv=vv./dist;
t=d(1).t;
EF = feval(ps(1).cf,t-0.042)/dist;
ind = 900:length(EF);% Here we ignore the first 1000 points to see the 
%plasma peak around zero. This number may need to change.  
%
% t=d(1).t; ind=t>t(1)+0.04287;% 0.04287 historical shift
% EF = feval(ps.cf,t(ind)-0.04287)/4.55;% 4.55 cm inde=EF>=-1000 & EF<=4000;
% EF = EF(inde); 
%surf(vv,d(1).del,d(1).data);
clf;
pcolor(EF(ind),d(1).del,d(1).data(:,ind));
shading interp;
% axis([0 450 0 1.5]);
%%
clf;
pcolor(ps.EF);
shading interp;
%%
klist=(1:length(del));
klist=[klist,1];
for k=klist
    t=d(k).t;
    y=d(k).del;
    y=log10(exp(-d(k).del/0.25));
    clf;
    surf(vv,y,d(k).data);
    camproj('perspective');
%     axis([0 250 -1.5 0 -0.1 3.0]);  % Adjust last number as needed  
    view(5,75);  % OR TRY view(5,75)
%     camproj('perspective'); view(0,90); % TOP VIEW
    xlabel('Ramp field (V/cm)','fontsize',12);
    ylabel('Log of relative density', 'fontsize',12);
    set(gca,'ZTick',[]);
    set(gca,'ZColor','white');
    s3=sprintf('%.0f',del(k)*1000);
    s4=' ns';
    s=[s3 s4];
    title(s);
%     caxis([-0.2,2.8]);
    shading interp;
    box off;
    pause(1);
end
%%
clf; hold on;
stackplot(d(1),'norm',ps,0.04287,0,4.55);
xlim([-5 300]);
ylim([-2.5 3]);
pbaspect([1 1 1]);
%
%% 
%path=['C:\UCP-data\images\' originaldate '\'];
%if ~exist(path,'dir')
%    mkdir(path);
%end
for i=1:length(d)
   clf; hold on;
   stackplot(d(i),'norm',ps,0.04287,0,4.55);
   xlim([-5 300]);
   ylim([-2.5 3]);
   pbaspect([1 1 1]); 
   pause;
end
%%  
% clf;
% life=0.185;
% a=0.30;
% z=zeros(71,8000);
% for k=1:71
%     norm=exp(-del2(k)/life)
%     z(k,:)=d(1).data(k,:).*a;
%     z(k,:)=z(k,:)./norm;
% end
% y=d(1).del;
% y=log10(exp(-d(1).del/life));
% surf(vv,y,d(1).data);
% shading interp;
% view(5,75);
% caxis([-0.2,3.0]);
% axis([0 250 -1.9 0 -0.1 4.0]);
% %% 
% %
% clf;
% surf(vv,y,z);
% shading interp;
% view(5,75);
% caxis([-0.2,3.0]);
% axis([0 250 -1.9 0 -0.1 4.0]);
%% 
%
clf;
life=0.185;
a=0.30;                               % for density normalization
z=zeros(71,8000);
for k=11:11
    y=d(k).del;
    y=log10(exp(-d(k).del/life));
    for kk=1:71                       % loop for density normalization
        norm=exp(-del2(kk)/life);
        z(kk,:)=d(k).data(kk,:).*a;
        z(kk,:)=z(kk,:)./norm;
    end        
    clf;
    surf(vv,y,z);                     % for density normalized
%     surf(vv,y,d(k).data);
    camproj('perspective'); 
    view(10,65);
    axis([0 250 -1.2 0 -0.1 2.8]);    % for density normalized run
    caxis([-0.25,3.45]);              % for density normalized run
%     axis([0 250 -1.2 0 -0.1 4.7]);
%     caxis([-0.25,3.45]);
    xlabel('Ramp field (V/cm)','fontsize',16);
    set(gca,'YTick',[-1 -0.5 0]);
    set(gca,'ZTick',[]);
    set(gca,'ZColor','white');
    s3=sprintf('%.0f',del(k)*1000);
    s4=' ns';
    s=[s3 s4];
    handle=title(s,'fontsize',18); 
    set(handle,'Position',[220 .2 .1]);
    shading interp;
    box off;
    F(k)=getframe(gcf);
    pause (0.5);
end
%%
%
dist=4.55;
ishift=round(8000*0.04287/2);  % 40ns electronic delay for ramp pulse
vv=ps.EF;
gg=padarray(vv,[0 ishift],'pre');
vv=gg(1:8000);
vv=vv./dist
%
a=0.5;
y=smooth(d(1).data(18,:)*a,15);    % 170ns density delay
h=plot(vv,y,'color',[1 1 1]*.3);    % black lines on plot
get(h,'XData');
get(h,'YData');
axis square;
axis([0 250 0 1]);
xlabel('Field (V/cm)');
set(gca,'YTick',[0 0.5 1]);
s1='n49-3kVramp-170nsDelay';
title(s1);
