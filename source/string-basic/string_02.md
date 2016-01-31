# Hashing

## 基本想法

想辦法幫一個字串算出它的「特徵」，

就像你在找東西前會先觀察它的顏色、大小等等，利用這個快速判斷他在不在視線範圍之內，
說穿了就是定義一種分類方式。

*Hash* 就是個這樣的做法，利用分類加速你的搜尋速度。 


## Hash 函數

- 找到一個分類函數，即是一個$f: \mathbb{S}(\Sigma) \mapsto \mathbb{Z}$，把所有可能的字串打到有界的整數，不妨說$f(s) \in [0, M-1] \; \forall s$吧！
- 這個函數最好是均勻分部在$[0, M-1]$上。
- 計算這個函數最好不需花太多時間！
-	>
	> 一個滿足以上條件的函數我們就稱作「好的」 *Hash function*


## 之後呢?

有了Hash function後有什麼用呢？

雖然我們*無法保證*$A \neq B \; \Rightarrow f(A) \neq f(B)$，

因為$f$把有無窮多個元素的字串集合打到有限個整數上，

當然會有許多字串被打到同一個整數！

## 
但至少我們會知道

<center>
$f(A) \neq f(B) \quad \Rightarrow \quad A \neq B$
</center>

也就是說如果兩個字串的Hash value不一樣，那我們連匹配都不需要了，他們鐵定不相等！

至於Hash function要怎麼找呢？


## Rabin-Karp rolling hash function
這是個常用的方法，
給定$p, q$ 跟長度為 $n$ 字串 $A$，令
  
$f(A) = a_0 p^{n-1} + a_1 p^{n-2} + \cdots + a_{n-2} p + a_{n-1} \mod{q}$

$=\sum_{0}^{n-1} a_i p^{n-i-1} \mod{q}$


## 
看起來很複雜，其實就是字串$A$在$p$進位制代表的值模$q$而已！

- 那這個函數有符合我們的需求嗎？

- 首先他把每個字串打到$[0, q-1]$，

	可以想成他把所有字串分成$q$類。

- 另外數學家跟我們說，如果$p,q$取兩個不同的質數，通常結果會不錯，非常均勻！

## Sliding Window
另外計算這個函數只需要$O(|A|)$，並且他還有一些很好的性質！

- 遞迴性

	$f(A) \equiv f(A[0, n-2]) \times p + a_{n-1} \pmod{q}$

- 子字串的 hash value 與前綴的關係

	$f(A[i, j]) \equiv f(A[0, j]) - p^{j-i+1} f(A[0, i-1]) \pmod{q}$

##
所以對於一個字串 $A$，
可以先利用*遞迴性*在
$O(|A|)$ 的時間內算出所有前綴的hash，$f(P_A(i))$。

對於任何一個子字串$A[i,j]$，我們可以利用前綴預處理完的 hash 值 $O(1)$算出結果。

##
簡單的寫個 code，

~~~{.cpp}
typedef long long LL;
char a[N]; LL hsa[N];
int p,q;
LL mul(LL a, LL b, int mod){return a*b%mod;}
LL add(LL a, LL b, int mod){return (a+b)%mod;}
void init(string a){
	pw[0] = 1;
	for(int i=1; i<N; i++)
		pw[i] = mul(pw[i-1], q);

	for(int i=0; i<(int)a.length(); i++)
		hsa[i] = add((i==0?0:hsa[i-1])*p, (int)a[i]);
}
int hsf(int l,int r){
	return hsa[r] - ((l==0)?0:mul(hsa[l-1], pw[r-l+1],q));
}
~~~

這樣我們就有任意子字串的 hash value 可以用了。

##

- 回到我們字串匹配的問題，我們只需要事先算出 $A$ 所有前綴的hash value和$f(B)$，

- 再枚舉$A$所有長度為$|B|$的子字串(差不多$O(A)$個，

- 最後計算這些子字串的 hash value 是不是等於$f(B)$，總共只需要$O(N)$。

## 會不會壞掉呢？

等等！回想我們剛剛說的：我們知道$f(A) \neq f(B) \Rightarrow A \neq B$，

但卻無法保證$f(A) = f(B) \Rightarrow A = B$啊？

- 有人可能會想說：「相等時重新檢查一次」，

- 但如果$A = \texttt{AAA} \dots \texttt{AAA}, B = \texttt{AA} \dots \texttt{AA}$，就又會又退化成$O(|A||B|)$了！

	那怎麼辦呢？

- 答案是：把$q$取大一點，然後就相信 $f(A) = f(B)$的機率很小，不會發生！

## 

事實上如果$f$是均勻的，那$f(A) = k$的機率差不多是$1/q$！

只要$q$取夠大，比如一個 `long long` 的質數，差不多$10^{15}$，那麼兩個不同的字串*碰撞*的機率是$10^{-15}$，

是一個人被閃電打到兩次的機率(一次機率差不多是$8 \times 10^{-7}$)，不太可能啦！

## 如果碰撞了？
- 有些常用的質數有人會故意構造會碰撞的測資

	像是大家很愛用的 $10^9+7$ 或是 $10^9+9$，

- 或是真的很衰就是被雷打到了，不管怎樣反正就是你因為碰撞WA了。

	要怎辦呢？

##

![](image/lightening_safety.jpg)

##
這時候可以嘗試使用兩組不同的 $(p_1, q_1), (p_2, q_2)$ 湊出的兩個hash function $f_1(x), f_2(x)$，
並使用數對 $(H_1 = f_1(S),H_2 = f_2(S))$ 當作你的hash value，

也就是

$f_1(A) \neq f_1(B) \quad or \quad  f_2(A) \neq f_2(B) \Rightarrow A \neq B$

這樣碰撞的機率就會大大減少，再WA...你有其他bug機率可能還比較高(?)。
