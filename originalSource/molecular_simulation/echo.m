function echo(varargin)
%print an vector 
str = '';
for k=1:length(varargin)
    str = [str ' ' num2str(varargin{k})];
end 
disp(str)