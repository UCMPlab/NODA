function imagepfi(varargin)
if nargin>=1
    pfi=varargin{1};
if nargin>=2
    k=varargin{2};
else
    k=1;
end
dd=pfi(k);

d=dd.data;
t=dd.t;
wl=dd.wl(:,1);
if nargin==3
    ind = varargin{3};
else
    ind = 1:length(t);
end

flag=true;
try
    wl2=dd.wl(:,2);
catch
    flag=false;
end
if mean(wl)>100
    type='wavelength';
else
    type='delay';
    wl=(wl-min(wl))*1e6;
    if flag
        wl2=(wl2-min(wl2))*1e6;
    end
end
clf;clc;imagesc(d(:,ind));
title(preptitle(dd.name));
end
