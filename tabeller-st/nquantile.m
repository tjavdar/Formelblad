% N(0,1)-quantiles

pkg load statistics

alpha = [ .1 .05 .025 .01 .005 .001 .0005]; ncol = size(alpha,2);

FMT_begin_table = "\\begin{tabular}{r|";
FMT_p_header    = "$\\alpha$"; 
FMT_data        = "$\\Tr{z}{\\lambda}_\\alpha$ ";
for i=1:ncol
  FMT_begin_table = [FMT_begin_table,"c"];
  FMT_p_header    = [FMT_p_header," & %6.4g"];
  FMT_data        = [FMT_data," & %7.4f"];
end
FMT_begin_table=[FMT_begin_table,"}\n"];
FMT_p_header=[FMT_p_header,"\\cr\\hline\n"]; FMT_data=[FMT_data,"\\\\\n"];

printf(FMT_begin_table);
printf(FMT_p_header,alpha);
printf(FMT_data,norminv(1-alpha));
printf("\n\\end{tabular}\n\n");
