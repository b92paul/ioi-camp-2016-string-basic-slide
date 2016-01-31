if [[ $# -eq 1 ]];
then
	pandoc -t revealjs -s source/$1/*.md -i  --section-divs --variable theme="black"  --variable transition="slide" --mathjax="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML" --highlight-style=zenburn -o $1.html
fi
if [[ $# -eq 2 ]];
then
	pandoc -t revealjs -s source/$1/$2*.md -i --section-divs --variable theme="black" --variable transition="slide" --mathjax="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML" --highlight-style=zenburn -o $1.html
fi
