%% chi2-fördelningen qvantiler; reproduktion av tabellen  i Vännmans bok i LaTeX
%% Tabellen anger P(\xi > x) = \alpha givet antalet frihetsgrader
%% Rudimentary usage:  table_chi2_quantile(alpha,f)
%%                                                2009-09, IvTj@jth.hj.se
%--------------------------------------------------------------------------


clear;
alpha = [ .99 .975 .95 .90 .10 .05 .025 .01 ]; ncol = size(alpha,2);

% Antalet frihetsgrader, delade i grupper om 5 
% for n = [0:5]
%    f(n+1,:)  = [5*n+1:5*n+5];  
% end
f     = [1:30];         % Antalet frihetsgrader
last_f = size(f,1);

function tbl=table_chi2_quantile(a,f)
  [xx,yy] =  meshgrid(1.0-a,f);
  tbl=[f',chi2inv(xx,yy)];
endfunction


FMT_p_header    = "$f / \\alpha$ "; 
FMT_data        = "%3d ";
for i=1:ncol
  FMT_p_header    = [FMT_p_header,"& %5.4g "];
  FMT_data        = [FMT_data,"&%7.3f "];
end
FMT_p_header=[FMT_p_header,"\\\\\\hline\n"]; FMT_data=[FMT_data,"\\\\\n"];

for i=1:last_f
  printf(FMT_p_header,alpha);
  table = table_chi2_quantile(alpha,f(i,:));
  printf(FMT_data,table');
end
