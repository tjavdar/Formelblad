% t-fördelningen qvantiler; reproduktion av tabellen  i Vännmans bok i LaTeX

pkg load statistics

alpha = [ .1 .05 .025 .01 .005 .001 .0005]; ncol = size(alpha,2);

f = [1:30 40:20:120];         % Antalet frihetsgrader
b = 14;                       % <- breakpoint (set to size(f,2) for non-break output)

function tbl=table_t_quantile(a,f)
  [xx,yy] =  meshgrid(1.0-a,f);
  tbl=[f',tinv(xx,yy)];
endfunction


FMT_begin_table = "\n\\begin{tabular}{c|";
FMT_p_header    = "$t$-mark"; 
FMT_data        = "$f=%3d$";
for i=1:ncol
  FMT_begin_table = [FMT_begin_table,"c"];
  FMT_p_header    = [FMT_p_header,"\t& $\\alpha=%6.4g$\n"];
  FMT_data        = [FMT_data," &%7.4f"];
end
FMT_begin_table=[FMT_begin_table,"}\n"];
FMT_p_header=[FMT_p_header,"\\cr\\hline\n"]; FMT_data=[FMT_data,"\\\\\n"];

for i=1:2                        % set to 1:1 for non-break output
  printf(FMT_begin_table);
  printf(FMT_p_header,alpha);
  if ( i == 1 )
    table = table_t_quantile(alpha,f(1:b));
  else
    table = table_t_quantile(alpha,f(b+1:size(f,2)));
  end
  printf(FMT_data,table');
  printf("\n\\end{tabular}\n\n");
end
