# KMP


## 想法

當我們在做最普通的匹配時...

![](image/string-05.png)

## 定義
對於一個字串$B = b_0 b_1 \cdots b_{m-1}$，我們定義

- $F_B(i) = \max \{ k: P_B(k) = B[0, k] = B[i-k, i] \}$ 

	$\quad\quad\quad \quad \text{if } i \neq 0 \text{ and at least a $k$ exists}$

- $\quad \quad= -1$, else

-  $F(i)+1$也稱作在第$i$個位置的*共同前後綴*長度


## 例子

舉個長一點的例子，如果$S = \texttt{ababaabababaababa}$，
那麼$F_{S}(j)$會是：

![](image/string-06.png)


##
由上面的推論,我們總結 $F(j)$ 的一個非常重要的性質:

$F_B(j)$ 告訴我們在拿 $B$ 去 匹配 $A$ 的過程中，如果 $B[0, j]$ 已經匹配成功，

但在第 $j + 1$ 個位置匹配失敗了，
應該要把 $B$ 的第 $F(j)$ 個字元對齊原本 $B[j]$ 的位置繼續匹配!

再舉個例子,容易 知道如果 $B = \texttt{aabaabd}$,則 $F(j) = \{−1, 0, −1, 0, 1, 2, −1\}$。

##
假設我們已經匹配 $B[0, 4]$，但在第 5 個字元出問題了，

~~~
    01234567
A = aabaaa?????
    |||||*        Matching failed at position 5
B = aabaabd         
       ||*        F(4) = 1, Matching failed at position 2
       aabaabd
        |*        F(1) = 0
        aabaabd
~~~

- 這樣我們一次可能往前一大步，而不用每次位移一格重新匹配了!
- F 可以說是個快速重新對齊的的function ！

## 怎樣計算 F 呢？

假設我們已經求出了 $F(i),\forall 0 \le i \le n$，現在要求 $F(n + 1)$，

- 根據定義相當於要求最大的 $k = k′ + 1$ 使 $B[0,k] = B[n+1−k,n+1]$。

- 而$B[0,k] = B[n+1−k,n+1]$

	$\Leftrightarrow B[0,k′] = B[n−k′,n]∧B[k′ +1] = B[n+1]$

##
由失敗函數的定義我們知道 $k′$ 最大只能是 $F(n)$，如果此時 $B[F(n) + 1] = B[n + 1]$，
我們立刻便知道 $F(n + 1) = F(n) + 1$。

但如果不是怎麼辦?
難道必需 $k′ = F(n) − 1,F(n) − 2··· ,0$ 一直試下去嗎?不要忘記我們已經算出所有 $j \le n$ 的 $F(j)$ 了,

##
我們便把當前位置 $n$ 對齊 B[F(F(n))]。

也就是下一個要試的 k′ 是 $F(F(n))$！

如果又失敗,我們便再試 $F^{3}(n),F^4(n), \cdots$，

直到終於成功或是確認沒有 $k$ 存在 ($F(n + 1) = −1$)。

## 計算 F 的 code
~~~{.cpp}
void build_fail_function(string B, int *fail) {
    int len = B.length(), current_pos;
    current_pos = fail[0] = -1; //Specially fail[0] = -1
    for( int i = 1 ; i < len ; i ++ ) {
        while( current_pos != -1
               && B[current_pos + 1] != B[i] ) {
            current_pos = fail[current_pos];
        }
        if( B[ current_pos + 1 ] == B[i] ) current_pos ++;
        fail[i] = current_pos;
    }
}
~~~

## 匹配的 code
~~~{.cpp}
void match(string A, string B, int *fail) {
    int lenA = A.length(), lenB = B.length();
    int current_pos = -1;
    for( int i = 0 ; i < lenA ; i ++ ) {
        while( current_pos != -1 
               && B[current_pos + 1] != A[i] ) {
            current_pos = fail[current_pos];
        }
        if( B[current_pos + 1] == A[i] ) current_pos ++;
        if( current_pos == lenB - 1 ) {
            // Match !
			// A[i - lenB + 1, i] = B
            current_pos = fail[current_pos];
        }
    }
}
~~~

##

$B[0, F(i)]$是$B$最長的一個前綴使得$B[0, F(i)] = B[i - F(i), i]$，但 $F(i) \neq i$

令$F^k(i) = \overbrace{f \circ f \circ \cdots \circ f}^{k} (i)$，則：

$\exists n, \; F^n(i) = -1$

$F^{k+1}(i) < F^{k}(i) \quad \text{if} \quad F^k(i) \neq -1$

令$K = \{ i, F(i), F^2(i) , \cdots , F^{n-1}(i), F^n(i) = -1\}$，

則 $B[0, k] = B[i-k, i] \; \Leftrightarrow \; k \in K$

$-1 \leq F(i+1) \leq F(i) + 1$


## 
最後我們分析一下KMP的時間複雜度，參考範例程式碼，
可以發現不管在計算 $F$ 或是在匹配，對於每一次的匹配，

當前$B$的匹配位置(current\_pos)會

- (a).被疊代入 $F$ 若干次。
- (b).如果匹配成功，便加$1$。

- 但我們知道每次疊代current\_pos至少會減$1$，並且疊代到$-1$時便會停止，

	因此(a)中疊代的次數不會超過(b)被執行的次數！

- 而(b)又不會超過字串的長度，

	所以KMP的時間複雜度是$O(|A| + |B|)$，線性！

