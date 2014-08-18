FILE=tables-tr
FIGFILES="approx"

if [ ! -f $FILE.tex -o  $FILE.m -nt $FILE.tex ]; then  # must remake
  echo -n "$0: Executing octave -q $FILE.m > $FILE.tex ... "
                         octave -q $FILE.m > $FILE.tex
  echo Done.
else
  echo "$0: $FILE.tex newer than $FILE.m, skip."
fi

for F in $FIGFILES; do
  if [ ! -f $F.eps -o $F.fig -nt $F.eps ]; then
      rm -f $F.eps
      echo -n $0: Executing: "fig2dev $F.fig > $F.eps ... "
       fig2dev -L eps $F.fig > $F.eps
      echo Done.
  else
     echo $0: File $F.eps up to date.
  fi
done
