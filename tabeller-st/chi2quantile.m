% chi2-fördelningen qvantiler; reproduktion av tabellen  i Vännmans bok i LaTeX

pkg load statistics
alpha = [ .99 .975 .95 .90 .10 .05 .025 .01 ]; ncol = size(alpha,2);

f     = [1:30];         % Antalet frihetsgrader
b = size(f,2);             % <-- breakpoint

function tbl=table_chi2_quantile(a,f)
  [xx,yy] =  meshgrid(1.0-a,f);
  tbl=[f',chi2inv(xx,yy)];
endfunction

FMT_begin_table="\\begin{tabular}{c|";
FMT_p_header    = "$\\xi$-mark"; 
FMT_data        = "  $f=%3d$";
for i=1:ncol
  FMT_begin_table=[FMT_begin_table,"c"];
  FMT_p_header    = [FMT_p_header,"  & $\\alpha=%5.4g$\n"];
  FMT_data        = [FMT_data,"&%7.3f "];
end
FMT_begin_table=[FMT_begin_table,"}\n"];
FMT_p_header=[FMT_p_header,"\\cr\\hline\n"]; FMT_data=[FMT_data,"\\cr\n"];

for i=1:1           % 1:2 with breakpoint
  printf(FMT_begin_table);
  printf(FMT_p_header,alpha);
  if ( i == 1)
    table = table_chi2_quantile(alpha,f(1:b));
  else
    table = table_chi2_quantile(alpha,f(b+1:size(f,2)));
  end
  printf(FMT_data,table');
  printf("\\end{tabular}\n\n")
end
