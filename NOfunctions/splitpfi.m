function d=splitpfi(pfi)
% del=(pfi.wl(:,1)-pfi.wl(1,1))*1e6;
del=(pfi.wl(:,1)-min(pfi.wl(:,1)))*1e6;
inds=find(del==0);
for i=1:length(inds)-1
    d(i).del=del(inds(i):inds(i+1)-1);
    d(i).data=pfi.data(inds(i):inds(i+1)-1,:);
    d(i).t=pfi.t;
end
i=length(inds);
d(i).del=del(inds(i):end);
d(i).data=pfi.data(inds(i):end,:);
d(i).t=pfi.t;
start=1;
for i=1:length(d);
    d(i).del=d(i).del(start:end);
    d(i).data=d(i).data(start:end,:);
end

