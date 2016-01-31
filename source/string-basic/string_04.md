# Z-value

## Z-value
在計算一個答案時，如果能妥善利用已知的資訊，便可以加速計算所需的時間。

而Z Algorithm ( Z-value ) 便是充分的利用這一點。

現在我們就來介紹這個名字很帥氣的演算法。

## 算法內容
Z function 的核心概念在建出一個 $Z$ 陣列，
$Z[i]$ 代表從第 $i$ 個字元開始所形成的後綴與原字串的共同最長前綴有多長，
唯一的例外是 $Z[0]$ 通常強制被設成 $0$ 。

首先我們定義Z function

對於一個字串$A = a_0 a_1 \cdots a_{n-1}$，定義

> $Z_A(i) = 0, \quad \text{if } i = 0 \text{ or } A[i] \neq A[0]$
>
> $\max \{ k : A[0, k-1] = A[i, i+k-1] \},\text{else}$


##
看起來和失敗函數$F(i)$有點像，

但不一樣的是$Z(i)$表示$A$的後綴$S_A(i)$，

也就是從$A[i]$開始的字串，可以和$A$自已匹配多長。

## 看個例子

舉例而言，對於字串$S = \texttt{"ababaabababaababa"}$來說，Z function的值為：

![](image/string-02.png)

##
現在我們需要一個快速求出所有 $Z(i)$ 的方法，假設我們已經知道了 $Z(i) = z$，
也就是 $A[0, z-1] = A[i, i+z-1]$。

那麼 $Z(i+1), Z(i+2), \cdots , Z(i+z-1)$ 是否會和 $Z(1), Z(2), \cdots, Z(z-1)$ 有關係呢？

##
事實上Z function有一個很重要的性質是
對於一個字串$A = a_0 a_1 \cdots a_{n-1}$，如果$Z(i) = z$，則

- $A[k] = A[i+k], \quad \text{if } \; 0 \leq k < z$.

- $A[z] \neq A[i+z]$. \listeqn \label{eq:z-0}

- 令$L = i, R = i + z - 1$，現在假設$L \leq j \leq R, j' = j - L$，則：
	- 如果 $j' + Z(j') < z$，則 $Z(j) = Z(j')$
    - 如果 $j' + Z(j') > z$， 則 $Z(j) = R - j + 1$
    - 如果 $j' + Z(j') = z$， 則 $Z(j) \geq R - j + 1 = Z(j')$

## Case 1

如果 $j' + Z(j') < z$，則 $Z(j) = Z(j')$

![](image/string-03.png)


## Case 2

如果 $j' + Z(j') > z$， 則 $Z(j) = R - j + 1$

![](image/string-04.png)

## Case 3

如果 $j' + Z(j') = z$， 則 $Z(j) \geq R - j + 1 = Z(j')$

最後一種情況雖然我們無法直接得出 $Z(j)$，但我們至少會知道$Z(j) ≥ Z(j′)$，

因此我們繼續從 R 下去匹配就可以了!

## 讓我們來看看 code
~~~{.cpp}
char A[MXN]; int Z[MXN];
Z[0] = 0;
int L = 0, R = 0;
for ( int i = 1 ; i < len ; i ++ ) {
    if ( i > R ) Z[i] = 0;
    else {
        int ip = i - L;
        if ( ip + Z[ip] < Z[L] ) Z[i] = Z[ip]; // Case 1
        else Z[i] = R - i + 1; // Case 2, 3
    }
    while ( i + Z[i] < len && A[ i + Z[i] ] == A[ Z[i] ] ) Z[i] ++;
    if ( i + Z[i] - 1 > R ) {
        L = i;
        R = i + Z[i] - 1;
    }
}
~~~

##
不過這和字串匹配有什麼關係呢？
假設我們要拿 $B$ 匹配 $A$ ，
只要令 $C = B \phi A$，其中 $\phi$ 是從來沒有在 $A, B$ 間出現過的字元，

這樣如果 $A[i, i+k-1] = B, \: k = |B|$ ，必有 $C[k+i+1, 2k+i] = C[0, k-1]$ ， 也就是
$Z_C(k+i+1) = k$。

