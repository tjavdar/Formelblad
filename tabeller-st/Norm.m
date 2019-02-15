pkg load statistics

% Normalfördelningen

clear;

function tbl=table_Phi(x,y)
  [xx,yy] =  meshgrid(y,x);
  tbl=[x',normcdf(xx+yy)];
endfunction


x(1,:)=0:0.1:2.9;
% x(2,:)=1:0.1:1.9;
% x(3,:)=2:0.1:2.9;
last_x=size(x,1);
dec=0:0.01:0.09; ncol  =size(dec,2);

FMT_begin_table = "\n\\begin{tabular}{c|";
FMT_p_header    = "$x\\;$";
FMT_data        = "%3.1f";
for i=1:ncol
  FMT_begin_table = [FMT_begin_table,"c"];
  FMT_p_header    = [FMT_p_header,"&$x\\!+\\!%4.2f$"];
  FMT_data        = [FMT_data,"&%7.5f"];
end
FMT_begin_table=[FMT_begin_table,"}\n"];
FMT_p_header=[FMT_p_header,"\\\\\\hline\n"]; FMT_data=[FMT_data,"\\\\\n"];

%printf("\\subsection*{Normalfördelningen}\n\n")
%printf("Tabell för $\\Phi(x)=P(\\xi\\le x)=\\int_{-\\infty}^x e^{-t^2/2}\\,dt$, ")
%printf(" $\\xi\\in N(0,1)$. För $x<0$, använd att $\\Phi(-x)=1-\\Phi(x)$.")
for i=1:last_x
  printf(FMT_begin_table);
  printf(FMT_p_header,dec);
  table = table_Phi(x(i,:),dec);
  printf(FMT_data,table');
  printf("\n\\end{tabular}\n\n");
end
