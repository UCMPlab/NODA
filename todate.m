function str = todate
str = datestr(now());
str = strrep(strrep(strrep(str,'-','_'),' ','_'),':','_');
