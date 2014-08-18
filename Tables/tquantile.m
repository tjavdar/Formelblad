%% t-fördelningen qvantiler; reproduktion av tabellen  i Vännmans bok i LaTeX
%% Tabellen anger P(\xi > x) = \alpha givet antalet frihetsgrader
%% Rudimentary usage:  table_t_quantile(alpha,f)
%%                                                2009-09, IvTj@jth.hj.se
%--------------------------------------------------------------------------


clear;
alpha = [ .1 .05 .025 .01 .005 .001 .0005]; ncol = size(alpha,2);

% Antalet frihetsgrader, delade i grupper om 5 
% for n = [0:5]
%    f(n+1,:)  = [5*n+1:5*n+5];  
% end
% f(7,:) = [40:20:120];
f     = [1:30 40:20:120];         % Antalet frihetsgrader
last_f = size(f,1);

function tbl=table_t_quantile(a,f)
  [xx,yy] =  meshgrid(1.0-a,f);
  tbl=[f',tinv(xx,yy)];
endfunction


FMT_begin_table = "\\begin{tabular}{|c";
FMT_p_header    = "$f / \\alpha$ "; 
FMT_data        = "%3d";
for i=1:ncol
  FMT_begin_table = [FMT_begin_table,"|r"];
  FMT_p_header    = [FMT_p_header,"& %5.4g "];
  FMT_data        = [FMT_data,"&%7.3f"];
end
FMT_begin_table=[FMT_begin_table,"|}\n\\hline\n"];
FMT_p_header=[FMT_p_header,"\\\\\\hline\n"]; FMT_data=[FMT_data,"\\\\\n"];

printf("\\subsection*{$t$-fördelningen}\n\n")
printf("Tabellen ger det $x$ för vilket $P(\\xi > x)=\\alpha$ ")
printf("givet antalet frihetsgrader $f$.\n\n\\medskip")
printf("\\def\\myskip{\\vspace{8pt minus 6pt}}")
for i=1:last_f
  printf(FMT_begin_table);
  printf(FMT_p_header,alpha);
  table = table_t_quantile(alpha,f(i,:));
  printf(FMT_data,table');
  printf("\\hline\n\\end{tabular}\n\n\\myskip\n");
end
