% Bin(n,p), 2019-02-14, IvTj@ju.se
%--------------------------------------------------------------------------

pkg load statistics 

%--------------------------------------------------------------------------
% The sub which does the real job
% Returns the binomial CDF Bin(n,p_array) as a 2D-array (n+1) x size(p,2)
% Typical usage:   n=5;  p_array = 0.1:0.1:1; binocdf_table( n , p_array)
%--------------------------------------------------------------------------
clear;
function tbl=table_bin(n,p)
  k  = 0:n; [pp,kk]=meshgrid(p,k);
  tbl=[k',binocdf(kk,n,pp)];
end

%--------------------------------------------------------------------------
% Tabulates the binomial CDF Bin(n_range,p) for all n in nrange, for 
% at the values specified in the p-vector. Uses the external f-n table_bin 
%--------------------------------------------------------------------------
p=[5:5:50]/100; p(3)=1/6; p(7)=1/3; printf("%% p(3)=%f; p(7)=%f\n\n",p(3),p(7))
n_range=[6:9,10,12,15]; % n_range=[4:9,10:2:20];

FMT_begin_table="\\begin{tabular}{@{\\extracolsep{-2pt}}c|";
FMT_p_header="  Bin(%d,$p$)   "; FMT_data="  $x=%2d$";
for i=1:size(p,2)
  FMT_begin_table=[FMT_begin_table,"c"];
  FMT_p_header=[FMT_p_header,"\n  & $p=%g$"];
  FMT_data=[FMT_data,"&%7.5f"];
end
FMT_begin_table=[FMT_begin_table,"}\n"];
FMT_data=[FMT_data," \\cr\n"];

for n=n_range
  printf(FMT_begin_table);
  HEADROW=sprintf(FMT_p_header,n,p);
  HEADROW = [regexprep(HEADROW,"0.166667","1/6")];
  HEADROW = [regexprep(HEADROW,"0.333333","1/3"),' \\cr\\hline\n'];
  printf(HEADROW)
  table=table_bin(n,p);
  printf(FMT_data,table');

  printf("\n\\end{tabular}\n\n\\vspace{8pt minus 6pt}\n");

end
