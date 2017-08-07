function [RC] = FMconvert(train,libfmname)
%  A script to convert matrix to libFM formats.
%
%  *author: Muhan Zhang, Washington University in St. Louis
%%
datapath = strcat(pwd,'/data/');       % path of the data folder
train = triu(train);
[r,c,v] = find(train);  % store row, col, value of train>0 data to libfmname, for further processing using python
% [r,c] = ind2sub(size(train),[1:numel(train)]);
% r = r'; c = c';
% v = train(:);

RC = [r,c];
a = [v,r-1,c-1];

%% directly process text in MATLAB, slower
% fid = fopen(sprintf('data/%s.libfm',libfmname),'w+');
% for i = 1:size(v,1)
%     b = a(i,:);
%     fprintf(fid,strcat(num2str(b(1)),32,num2str(b(2)),':1',32,num2str(b(3)),':1','\r\n'));
% end
% fclose(fid);

%% call python to process text, faster
dlmwrite(strcat(datapath,libfmname),a,'delimiter',' ');
cd data;
cmd = sprintf('python processFM.py %s',libfmname);     % call python, convert to [v, r, c] to [v, r:1, c:1]
system(cmd);
cd ..;
