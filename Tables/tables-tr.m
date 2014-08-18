% Generate Bin(n,p), Po(lambda), Exp(lambda), Phi(x)  LaTeX tables
% Feb-March 2008, IvTj@jth.hj.se
%--------------------------------------------------------------------------
%

%% Poissonfördelningen/*<<<*/


%--------------------------------------------------------------------------
% Tabulates the binomial CDF Bin(n_range,p) for all n in nrange, for 
% at the values specified in the p-vector. Uses the external f-n table_bin 
%--------------------------------------------------------------------------
clear;
function tbl=table_Po(x,lambda)
  [xx,ll] =  meshgrid(x,lambda);
  tbl=[x',poisscdf(xx,ll)'];
endfunction

x(1) =  5;  lambda(1,:) = 0.1:0.1:0.9;
x(2) =  8;  lambda(2,:) = 1.0:0.1:1.8;
x(3) = 12;  lambda(3,:) = [1.9,2:0.2:3.4];
x(4) = 17;  lambda(4,:) = [3.6:0.2:5.0,6.0];
x(5) = 30;  lambda(5,:) = 7:15;
last=size(x,2);

FMT_begin_table="\\begin{tabular}{|r";
FMT_p_header="$Po(\\lambda)$: $x$\n   "; FMT_data="%3d";
for i=1:size(lambda,2)
  FMT_begin_table=[FMT_begin_table,"|c"];
  FMT_p_header=[FMT_p_header,"& $\\lambda=%g$ "];
  FMT_data=[FMT_data,"&%7.5f"];
end
FMT_begin_table=[FMT_begin_table,"|}\n\\hline\n"];
FMT_p_header=[FMT_p_header,"\\\\\\hline\n"]; FMT_data=[FMT_data,"\\\\\n"];

printf("\\subsection*{Poissonfördelningen}\n\n")
printf("Tabell för $P(\\xi\\le x)$ då $\\xi\\in Po(\\lambda)$.")
printf("\n\n\\medskip")
for i=1:last
  printf(FMT_begin_table); printf(FMT_p_header,lambda(i,:));
  table=table_Po(0:x(i),lambda(i,:));
  printf(FMT_data,table');
  
  printf("\\hline\n\\end{tabular}\n\n\\vspace{8pt minus 6pt}\n");

end
%% /*>>>*/

%% Binomialfördelningen/*<<<*/
%--------------------------------------------------------------------------
% The sub which does the real job
% Returns the binomial CDF Bin(n,p_array) as a 2D-array (n+1) x size(p,2)
% Typical usage:   n=5;  p_array = 0.1:0.1:1; binocdf_table( n , p_array)
%--------------------------------------------------------------------------
clear;
function tbl=table_bin(n,p)
 
  nn = n*ones(n+1,size(p,2));
  k  = 0:n; [pp,kk]=meshgrid(p,k);
  tbl=[k',binocdf(kk,nn,pp)];
end

%--------------------------------------------------------------------------
% Tabulates the binomial CDF Bin(n_range,p) for all n in nrange, for 
% at the values specified in the p-vector. Uses the external f-n table_bin 
%--------------------------------------------------------------------------
p=0.05:0.05:0.5; n_range=[2:20]; % n_range=[2:9,10:2:16,20];

FMT_begin_table="\\begin{tabular}{@{\\extracolsep{-2pt}}|r";
FMT_p_header="Bin(%d,p): $x$\n   "; FMT_data="%3d";
for i=1:size(p,2)
  FMT_begin_table=[FMT_begin_table,"|c"];
  FMT_p_header=[FMT_p_header,"& $p\\!=\\!%g$"];
  FMT_data=[FMT_data,"&%7.5f"];
end
FMT_begin_table=[FMT_begin_table,"|}\n\\hline\n"];
FMT_p_header=[FMT_p_header,"\\\\\\hline\n"]; FMT_data=[FMT_data,"\\\\\n"];

printf("\\subsection*{Binomialfördelningen}\n\n")
printf("Tabell för $P(\\xi\\le x)$ då $\\xi\\in B in(n,p)$.\n")
printf("För $p>0.5$, använd att ")
printf("$P(\\xi\\le x)=P(\\eta\\ge n-x)$,  $\\eta\\in B in(n,1-p)$")
printf("\n\n\\medskip")
for n=n_range
  printf(FMT_begin_table); printf(FMT_p_header,n,p);
  table=table_bin(n,p);
  printf(FMT_data,table');
  
  printf("\\hline\n\\end{tabular}\n\n\\vspace{8pt minus 6pt}\n");

end
%% /*>>>*/

%% Normalfördelningen/*<<<*/

clear;

function tbl=table_Phi(x,y)
  [xx,yy] =  meshgrid(y,x);
  tbl=[x',normcdf(xx+yy)];
endfunction


x(1,:)=0:0.1:0.9;     
x(2,:)=1:0.1:1.9;     
x(3,:)=2:0.1:2.9;     
last_x=size(x,1);
dec=0:0.01:0.09; ncol  =size(dec,2);

FMT_begin_table = "\\begin{tabular}{|c";
FMT_p_header    = "$x\\;$"; 
FMT_data        = "%3.1f";
for i=1:ncol
  FMT_begin_table = [FMT_begin_table,"|c"];
  FMT_p_header    = [FMT_p_header,"&$x\\!+\\!%4.2f$"];
  FMT_data        = [FMT_data,"&%7.5f"];
end
FMT_begin_table=[FMT_begin_table,"|}\n\\hline\n"];
FMT_p_header=[FMT_p_header,"\\\\\\hline\n"]; FMT_data=[FMT_data,"\\\\\n"];

printf("\\subsection*{Normalfördelningen}\n\n")
printf("Tabell för $\\Phi(x)=P(\\xi\\le x)=\\int_{-\\infty}^x e^{-t^2/2}\\,dt$, ")
printf(" $\\xi\\in N(0,1)$. För $x<0$, använd att $\\Phi(-x)=1-\\Phi(x)$.")
printf("\n\n\\def\\myskip{\\vspace{8pt minus 6pt}}\n\\medskip")
for i=1:last_x
  printf(FMT_begin_table);
  printf(FMT_p_header,dec);
  table = table_Phi(x(i,:),dec);
  printf(FMT_data,table');
  printf("\\hline\n\\end{tabular}\n\n\\myskip\n");
end

%% /*>>>*/
