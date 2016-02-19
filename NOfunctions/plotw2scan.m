function plotw2scan(wl,s,sz)
s=s-min(s);
s=s/max(s);
plot(wl,s,'linewidth',1.5,'color','k')
if numel(sz)>1
    set(gcf,'papersize',sz,'paperposition',[0,0,sz(1),sz(2)]);
end
xlabel('Wavelength (nm)','fontsize',11,'fontweight','bold');
set(gca,'fontsize',11,'fontweight','bold','ytick',[]);
xlim([min(wl) max(wl)]);
% pbaspect([2,1,1]);

