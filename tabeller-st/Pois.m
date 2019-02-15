% Poissonfördelningen
pkg load statistics

clear;
function tbl=table_Po(x,mu)
  [xx,ll] =  meshgrid(x,mu);
  tbl=[x',poisscdf(xx,ll)'];
endfunction

x(1) =  5;  mu(1,:) = 0.1:0.1:0.9;
x(2) =  8;  mu(2,:) = 1.0:0.1:1.8;
x(3) = 12;  mu(3,:) = [1.9,2:0.2:3.4];
x(4) = 15;  mu(4,:) = [3.6:0.2:5.0,6.0];
x(5) = 22;  mu(5,:) = 7:15;
last=size(x,2);

FMT_begin_table="\\begin{tabular}{r|";
FMT_p_header="Po($\\mu$)"; FMT_data="$x=%2d$";
for i=1:size(mu,2)
  FMT_begin_table=[FMT_begin_table,"c"];
  FMT_p_header=[FMT_p_header,"& $\\mu=%g$ "];
  FMT_data=[FMT_data,"&%7.5f"];
end
FMT_begin_table=[FMT_begin_table,"}\n"];
FMT_p_header=[FMT_p_header,"\\\\\\hline\n"]; FMT_data=[FMT_data,"\\\\\n"];

for i=1:last
  printf(FMT_begin_table); printf(FMT_p_header,mu(i,:));
  table=table_Po(0:x(i),mu(i,:));
  printf(FMT_data,table');
  
  printf("\n\\end{tabular}\n\n\\vspace{8pt minus 6pt}\n");

end
%% 
