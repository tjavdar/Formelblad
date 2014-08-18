%--------------------------------------------------------------------
% Tabulates the N(0,1) CDF Phi(x+y) on dim(x,2) times dim (y,2)-grid;
% x and y are row vectors, y is usually the least significant digit,
% typically x=0:3, y=0:0.1:0.9  --> LaTeX
% IvTj 2008, 2009, 2012
%----------------------------------------------------------------


%% Normalfördelningen

n = 29;
x = meshgrid(0:n,0:9)'/10 + meshgrid(0:9,0:n)/100;
ndist = normcdf(x);

FMT="%3.1f "; HEAD = "$x$";
for i = 0:9
  FMT = [FMT,"& %7.5f "];
  HEAD = [HEAD," & ${}+.0%1d$"];
end
FMT = [FMT," \\\\\n"];

printf(HEAD,[0:9]); printf(" \\\\\n\\hline\n");
for i = 1:n+1 
  printf(FMT,x(i,1),ndist(i,:))
end

