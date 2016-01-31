# AC 自動機

## What this is?

- 就是...傳上去你就會AC了(?)

- 不...那是自動 AC 機。

- 我第一次看到覺得名字很帥就是了。

	他的全名是 Aho-Corasick Algorithm 
	
## 內容簡介

可以說是 KMP 的強化板。

如果今天我們要在字串$A$上搜尋很多字串 $B_1, B_2, \cdots B_n$要怎麼做？

- 當然我們可以做 $n$ 次KMP得到一個$O(n|A| + \sum|B| )$的方法，

- 但信不信由你，其實我們可以在 $O(|A| + \sum |B| )$ 的時間完成

## 做法簡介

- 先用  $B_1, B_2, \cdots B_n$ 建出一顆 trie

- 對於 trie上的每個節點 $v$，建一個類似kmp 的 failure function 的 *failure link*，

	$f(v)$ 是指到樹上的另外一個點，

	並且把所有 $B_i$ 的節點標記起來。

##

用`a`, `c`, `ab`, `cc`,`cca`, `bab`, `caa` 建出的 AC 自動機，藍線是 failure link。

![](image/string-07.png)


##
- 要尋找 $B_i$ 在 $A$ 上匹配的時候每次就會在 trie 上走，每次 $A[i]$ 會嘗試匹配，

	如果失敗就會往回走到 $f(v)$ 繼續嘗試匹配，

	如果走到標記的點就幫 $B_i$ 的 count++


## 看看 code ?

~~~{.cpp}
root->fail = NULL;
queue<Node*> que;
que.push_back(root);
while ( !que.empty() ) {
    Node *fa = que.front(); que.pop_front();
    for (auto it = fa->child.begin(); it != fa->child.end(); it++) {
        Node *cur = it->second, *ptr = fa->fail;
        while ( ptr && !ptr->child.count(it->first) ) ptr = ptr->fail;
        cur->fail = ptr ? ptr->child[it->first] : root;
        que.push(cur);
    }
}
~~~

##

演算法其他詳細內容或用法，
請見進階字串的章節。
