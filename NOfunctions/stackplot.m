function [outnorm,EFm,ym,EFmean] = stackplot(varargin)
type='raw';
shift=0.0;
Eshift=125;
dist=4.55;
if nargin>=1
    pfi=varargin{1};
end
if nargin>=2
    type=varargin{2};
end
if nargin>=3
    ps=varargin{3};
end
if nargin>=4
    shift=varargin{4};
end
if nargin>=5
    Eshift=varargin{5};
end
if nargin>=6
    dist=varargin{6};
end
try
    del=(pfi.wl-pfi.wl(1))*1e6;
catch
    del=pfi.del-pfi.del(1);
end
t=pfi.t;
ind=t>t(1)+shift;
EF=(feval(ps.cf,t(ind)-shift)-Eshift)/dist;
EFF = EF;
inde=EF>=0 & EF<=400;
EF=EF(inde);
outnorm = zeros(length(del),1);
for j=2:1:length(del)
    switch type
        case 'raw'
            a=0.5;
            y=smooth(pfi.data(j,:)*a,17)+log10(exp(-del(j)/0.25));
        case 'norm'
            a=0.8;
            norm=max(pfi.data(j,:));
            if norm<0.22
                norm=0.22;
            end
            outnorm(j) = norm;
            y=smooth(pfi.data(j,:)*a/norm,17)+log10(exp(-del(j)/0.25));
        case 'normbyfirst'
            a=0.8;
            try
                norm=pfi.norm(j);
            catch
                norm=1;
            end
            if norm<0.22
                norm=0.22;
            end
            y=smooth(pfi.data(j,:)*a/norm,17)+log10(exp(-del(j)/0.25));
        case 'manualnorm'
            try
                norm=pfi.norm(j);
            catch
                norm=1;
            end
            y=smooth(pfi.data(j,:)/norm,17)+log10(exp(-del(j)/0.25));
        case 'normbyden'
            a=.02;
            norm=exp(-del(j)/0.25);
            y=smooth(pfi.data(j,:)*a/norm,17)+log10(exp(-del(j)/0.25));
    end
    y=y(ind);
    y=y(inde);
    if j==2
        [ym,indmax]=max(y);
        EFm = EF(indmax);
        indnew = EF<50 & EF>0;
        EFmean = sum(EF(indnew).*y(indnew))/sum(y(indnew));
    end
    plot(EF,y,'color',[1 1 1]*.3);
end
xlim([-5 300]);
xlabel('Field (V/cm)','fontsize',12);
ylabel('log of relative density (cm^{-3})');
set(gca,'YAxisLocation','right');
ylim([-2.5 1]);
pbaspect([1 1 1]);
try
    title(['t = ' num2str(pfi.fielddelay,'%2.2f') ' (\mus)']);
catch
end

