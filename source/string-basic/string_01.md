# 字串處理

## Who am I ?

下降 資工所一年級

## 什麼是字串?

"Hi你好"

"ATCGATCGGGGGG"

"asdff;lkjsadflkj"

## 正式的定義

給定字元集 $\Sigma$ ，長度為 $n$ 的字串 $A$，

$A = a_0 a_1 \dots a_{n-1}$

## 一些名詞定義

給訂一字串
$A = a_0 a_1 \dots a_{n-1}$

- 子字串
  
	$A[i,j] = a_{i} a_{i+1} \dots a_{j}$

- 子序列

	$B = a_{q_1} a_{q_2} \dots a_{q_m}$

	$0 \le q_1 < q_2 < \dots q_m < n$

## 一些名詞定義

- 前綴 (Prefix)

	$P_A(i) = A[0,i]$

- 後綴 (Suffix)

	$S_A(i) = A[i,n-1]$

## 例子

舉例來說，如果$A = \texttt{abcbbab}$，那 $\texttt{bcb}$ 是他的子字串， $\texttt{acb}$ 是他的子序列，而 $\texttt{bbab}$ 是他的一個後綴。


## 字串的儲存

## Trie

通常最基本的儲存方式就是用一個陣列依序將字串的每一個字元存下來。

不過當我們要同時儲存許多字串時，可能就要花點巧思了。
而這邊要介紹一個可以同時儲存多個字串的資料結構 ─ *字典樹* 或*Trie*。


## Trie (cont.)

Trie的道理非常簡單，其實就是用一棵樹來儲存字串。

在這棵樹上，每個點上(除了根節點之外)都有一個字元，而從根節點一路走到某個節點，依序經過的字元串起來就是那個點代表的字串。

最後我們再記錄哪些點是一個字串的最後一個字元即可！

##

如下圖就是一個儲存$\{A_1 = \texttt{abc}, A_2 =\texttt{abde}, A_3 = \texttt{bc}, A_4 = \texttt{bcd}\}$的trie

![](image/string-01.png)

##

> 給定一個字典樹Trie \  $T = \{V, E\}$，我們定義$P_T(v)$為從根節點走到$v$所得出的字串。

而Trie的基本操作也都很簡單，如要新增一個字串$A$，我們就從根節點開始，依照字串$A$的第$0, 1, 2, \cdots, n-1$個字元，
如果此字元在當前節點的子節點中就繼續走下去，否則就新增一個節點。

## 字串匹配

在處理字串問題時，會很常處理字串匹配問題。

* 請問這篇文章中出現多少次 `歐巴馬` ？
* 請問這段 DNA 序列中出現多少次 `AAA` ？
* 很常在文件使用的 _ctrl+f_ 搜尋

##
正式一點來說，字串匹配是個這樣的問題

> 給你兩個字串 $A$, $B$，找出所有 $B$ 出現在 $A$ 中的位置。

## 簡單的做法

~~~{.cpp}
for (int st = 0; st + lenB <= lenA; st++) {
    int mat = 0;
    while (mat < lenB && A[st + mat] == B[mat]) mat++;
    if (mat == lenB) output(st);
}
~~~

這份 code 有兩的部分，一個是枚舉 $B$ 可能出現的位置，

接著是一個 `while` 從這個位置判斷 $B$ 跟 $A$ 是否一樣。

這邊也可以使用 `strcmp(A+st,B) == 0`。

##

這樣寫好不好呢？

其實可以證明這樣的 *期望複雜度* 是 $O(|A|)$。

可惜的是，最差的情況可以到$O(|A||B|)$！

更糟的是很容易構造出例子。

##

如$A = \texttt{AAAAA} \dots \texttt{AA}, B = \texttt{AAA} \dots \texttt{B}$，

這樣雖然$B$從來沒有出現在$A$中，

但是每個位置我們都必需匹配到 $B$ 的最後一個字元才能確定匹配失敗！

##

說是這樣說，如果題目生測資太過於隨機的話，

其實好好寫個樸素的解法很容易過 OAO，

生測資很困難啊QA Q。

## 怎樣加速呢？

讓我們再看一次這份 code。

~~~{.cpp}
for (int st = 0; st + lenB <= lenA; st++) {
    int mat = 0;
    while (mat < lenB && A[st + mat] == B[mat]) mat++;
    if (mat == lenB) output(st);
}
~~~

如果可以讓 `while` 的部分變成接近 $O(1)$，

我們就可以加速到 $O(|A|)$ 判斷兩個字串的長度。
