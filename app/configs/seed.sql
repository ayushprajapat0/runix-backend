-- =============================================================
--  SEED: 20 Famous LeetCode-style Problems
--  Easy (7) | Medium (8) | Hard (5)
--  Languages: Python 3, C++, JavaScript, Java, C
--  Includes: problems, tags, test_cases, problem_templates
-- =============================================================


-- -------------------------------------------------------------
-- LANGUAGES
-- -------------------------------------------------------------
INSERT INTO languages (id, name, slug, version, is_active) VALUES
  ('a1000000-0000-0000-0000-000000000001', 'Python 3',   'python3',    '3.11',   TRUE),
  ('a1000000-0000-0000-0000-000000000002', 'C++',        'cpp',        '17',     TRUE),
  ('a1000000-0000-0000-0000-000000000003', 'JavaScript', 'javascript', 'ES2022', TRUE),
  ('a1000000-0000-0000-0000-000000000004', 'Java',       'java',       '21',     TRUE),
  ('a1000000-0000-0000-0000-000000000005', 'C',          'c',          'C17',    TRUE);


-- -------------------------------------------------------------
-- TAGS
-- -------------------------------------------------------------
INSERT INTO tags (id, name, slug) VALUES
  ('b1000000-0000-0000-0000-000000000001', 'Array',                'array'),
  ('b1000000-0000-0000-0000-000000000002', 'Hash Table',           'hash-table'),
  ('b1000000-0000-0000-0000-000000000003', 'String',               'string'),
  ('b1000000-0000-0000-0000-000000000004', 'Sliding Window',       'sliding-window'),
  ('b1000000-0000-0000-0000-000000000005', 'Linked List',          'linked-list'),
  ('b1000000-0000-0000-0000-000000000006', 'Two Pointers',         'two-pointers'),
  ('b1000000-0000-0000-0000-000000000007', 'Binary Search',        'binary-search'),
  ('b1000000-0000-0000-0000-000000000008', 'Divide and Conquer',   'divide-and-conquer'),
  ('b1000000-0000-0000-0000-000000000009', 'Stack',                'stack'),
  ('b1000000-0000-0000-0000-000000000010', 'Dynamic Programming',  'dynamic-programming'),
  ('b1000000-0000-0000-0000-000000000011', 'Math',                 'math'),
  ('b1000000-0000-0000-0000-000000000012', 'Recursion',            'recursion'),
  ('b1000000-0000-0000-0000-000000000013', 'Tree',                 'tree'),
  ('b1000000-0000-0000-0000-000000000014', 'Graph',                'graph'),
  ('b1000000-0000-0000-0000-000000000015', 'Greedy',               'greedy'),
  ('b1000000-0000-0000-0000-000000000016', 'Backtracking',         'backtracking'),
  ('b1000000-0000-0000-0000-000000000017', 'Heap / Priority Queue','heap-priority-queue'),
  ('b1000000-0000-0000-0000-000000000018', 'Matrix',               'matrix'),
  ('b1000000-0000-0000-0000-000000000019', 'Monotonic Queue',      'monotonic-queue'),
  ('b1000000-0000-0000-0000-000000000020', 'Bit Manipulation',     'bit-manipulation');


-- =============================================================
--  PROBLEM 1 — Two Sum  [EASY]
-- =============================================================
INSERT INTO problems (
  id, title, slug, difficulty, is_published,
  time_limit_ms, memory_limit_kb, total_submissions, total_accepted, description
) VALUES (
  'c1000000-0000-0000-0000-000000000001',
  'Two Sum', 'two-sum', 'easy', TRUE,
  2000, 262144, 9842301, 5913045,
$$
## Problem

Given an array of integers `nums` and an integer `target`, return **indices** of the two numbers such that they add up to `target`.

You may assume that each input would have **exactly one solution**, and you may **not** use the same element twice. You can return the answer in any order.

---

## Examples

**Example 1:**
```
Input:  nums = [2, 7, 11, 15], target = 9
Output: [0, 1]
Explanation: nums[0] + nums[1] = 2 + 7 = 9
```

**Example 2:**
```
Input:  nums = [3, 2, 4], target = 6
Output: [1, 2]
```

**Example 3:**
```
Input:  nums = [3, 3], target = 6
Output: [0, 1]
```

---

## Constraints

- `2 <= nums.length <= 10^4`
- `-10^9 <= nums[i] <= 10^9`
- `-10^9 <= target <= 10^9`
- Only one valid answer exists.

---

## Follow-up

Can you come up with an algorithm that is less than **O(n²)** time complexity?
$$);

INSERT INTO problem_tags (problem_id, tag_id) VALUES
  ('c1000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000001'),
  ('c1000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000002');

INSERT INTO test_cases (id, problem_id, input, expected_output, is_sample, explanation, order_index) VALUES
  ('d1000000-0000-0000-0000-000000000001','c1000000-0000-0000-0000-000000000001','{"nums":[2,7,11,15],"target":9}','[0,1]',TRUE,'nums[0]+nums[1]=2+7=9',1),
  ('d1000000-0000-0000-0000-000000000002','c1000000-0000-0000-0000-000000000001','{"nums":[3,2,4],"target":6}','[1,2]',TRUE,'nums[1]+nums[2]=2+4=6',2),
  ('d1000000-0000-0000-0000-000000000003','c1000000-0000-0000-0000-000000000001','{"nums":[3,3],"target":6}','[0,1]',FALSE,NULL,3),
  ('d1000000-0000-0000-0000-000000000004','c1000000-0000-0000-0000-000000000001','{"nums":[-1,-2,-3,-4,-5],"target":-8}','[2,4]',FALSE,NULL,4),
  ('d1000000-0000-0000-0000-000000000005','c1000000-0000-0000-0000-000000000001','{"nums":[1000000000,-1000000000,0,1],"target":1}','[2,3]',FALSE,NULL,5);

INSERT INTO problem_templates (id, problem_id, language_id, starter_code, solution_code) VALUES
-- Python
('e1000000-0000-0000-0000-000000000001','c1000000-0000-0000-0000-000000000001','a1000000-0000-0000-0000-000000000001',
$$from typing import List
class Solution:
    def twoSum(self, nums: List[int], target: int) -> List[int]:
        pass$$,
$$from typing import List
class Solution:
    def twoSum(self, nums: List[int], target: int) -> List[int]:
        seen = {}
        for i, n in enumerate(nums):
            diff = target - n
            if diff in seen:
                return [seen[diff], i]
            seen[n] = i$$),
-- C++
('e1000000-0000-0000-0000-000000000002','c1000000-0000-0000-0000-000000000001','a1000000-0000-0000-0000-000000000002',
$$#include <vector>
#include <unordered_map>
using namespace std;
class Solution {
public:
    vector<int> twoSum(vector<int>& nums, int target) {
        // Write your solution here
    }
};$$,
$$#include <vector>
#include <unordered_map>
using namespace std;
class Solution {
public:
    vector<int> twoSum(vector<int>& nums, int target) {
        unordered_map<int,int> seen;
        for (int i = 0; i < (int)nums.size(); i++) {
            int diff = target - nums[i];
            if (seen.count(diff)) return {seen[diff], i};
            seen[nums[i]] = i;
        }
        return {};
    }
};$$),
-- JavaScript
('e1000000-0000-0000-0000-000000000003','c1000000-0000-0000-0000-000000000001','a1000000-0000-0000-0000-000000000003',
$$/**
 * @param {number[]} nums
 * @param {number} target
 * @return {number[]}
 */
var twoSum = function(nums, target) {
    // Write your solution here
};$$,
$$var twoSum = function(nums, target) {
    const seen = new Map();
    for (let i = 0; i < nums.length; i++) {
        const diff = target - nums[i];
        if (seen.has(diff)) return [seen.get(diff), i];
        seen.set(nums[i], i);
    }
};$$),
-- Java
('e1000000-0000-0000-0000-000000000004','c1000000-0000-0000-0000-000000000001','a1000000-0000-0000-0000-000000000004',
$$import java.util.HashMap;
class Solution {
    public int[] twoSum(int[] nums, int target) {
        // Write your solution here
        return new int[]{};
    }
}$$,
$$import java.util.HashMap;
class Solution {
    public int[] twoSum(int[] nums, int target) {
        HashMap<Integer,Integer> seen = new HashMap<>();
        for (int i = 0; i < nums.length; i++) {
            int diff = target - nums[i];
            if (seen.containsKey(diff)) return new int[]{seen.get(diff), i};
            seen.put(nums[i], i);
        }
        return new int[]{};
    }
}$$),
-- C
('e1000000-0000-0000-0000-000000000005','c1000000-0000-0000-0000-000000000001','a1000000-0000-0000-0000-000000000005',
$$#include <stdlib.h>
/**
 * Note: The returned array must be malloced. Set *returnSize = 2.
 */
int* twoSum(int* nums, int numsSize, int target, int* returnSize) {
    // Write your solution here
    return NULL;
}$$,
$$#include <stdlib.h>
int* twoSum(int* nums, int numsSize, int target, int* returnSize) {
    *returnSize = 2;
    int* res = (int*)malloc(2 * sizeof(int));
    for (int i = 0; i < numsSize; i++) {
        for (int j = i + 1; j < numsSize; j++) {
            if (nums[i] + nums[j] == target) {
                res[0] = i; res[1] = j;
                return res;
            }
        }
    }
    return res;
}$$);


-- =============================================================
--  PROBLEM 2 — Valid Parentheses  [EASY]
-- =============================================================
INSERT INTO problems (
  id, title, slug, difficulty, is_published,
  time_limit_ms, memory_limit_kb, total_submissions, total_accepted, description
) VALUES (
  'c1000000-0000-0000-0000-000000000002',
  'Valid Parentheses', 'valid-parentheses', 'easy', TRUE,
  2000, 262144, 7234512, 3901234,
$$
## Problem

Given a string `s` containing just the characters `'('`, `')'`, `'{'`, `'}'`, `'['` and `']'`, determine if the input string is **valid**.

An input string is valid if:
1. Open brackets must be closed by the same type of brackets.
2. Open brackets must be closed in the correct order.
3. Every close bracket has a corresponding open bracket of the same type.

---

## Examples

**Example 1:**
```
Input:  s = "()"
Output: true
```

**Example 2:**
```
Input:  s = "()[]{}"
Output: true
```

**Example 3:**
```
Input:  s = "(]"
Output: false
```

**Example 4:**
```
Input:  s = "([)]"
Output: false
```

---

## Constraints

- `1 <= s.length <= 10^4`
- `s` consists of parentheses only `'()[]{}'`.
$$);

INSERT INTO problem_tags (problem_id, tag_id) VALUES
  ('c1000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000003'),
  ('c1000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000009');

INSERT INTO test_cases (id, problem_id, input, expected_output, is_sample, explanation, order_index) VALUES
  ('d1000000-0000-0000-0000-000000000006','c1000000-0000-0000-0000-000000000002','{"s":"()"}','true',TRUE,'Single matching pair',1),
  ('d1000000-0000-0000-0000-000000000007','c1000000-0000-0000-0000-000000000002','{"s":"()[]{}"}','true',TRUE,'Three matching pairs in sequence',2),
  ('d1000000-0000-0000-0000-000000000008','c1000000-0000-0000-0000-000000000002','{"s":"(]"}','false',TRUE,'Mismatched brackets',3),
  ('d1000000-0000-0000-0000-000000000009','c1000000-0000-0000-0000-000000000002','{"s":"([)]"}','false',FALSE,NULL,4),
  ('d1000000-0000-0000-0000-000000000010','c1000000-0000-0000-0000-000000000002','{"s":"{[]}"}','true',FALSE,NULL,5),
  ('d1000000-0000-0000-0000-000000000011','c1000000-0000-0000-0000-000000000002','{"s":""}','true',FALSE,NULL,6),
  ('d1000000-0000-0000-0000-000000000012','c1000000-0000-0000-0000-000000000002','{"s":"["}','false',FALSE,NULL,7);

INSERT INTO problem_templates (id, problem_id, language_id, starter_code, solution_code) VALUES
('e1000000-0000-0000-0000-000000000006','c1000000-0000-0000-0000-000000000002','a1000000-0000-0000-0000-000000000001',
$$class Solution:
    def isValid(self, s: str) -> bool:
        pass$$,
$$class Solution:
    def isValid(self, s: str) -> bool:
        stack = []
        mapping = {')': '(', '}': '{', ']': '['}
        for ch in s:
            if ch in mapping:
                if not stack or stack[-1] != mapping[ch]:
                    return False
                stack.pop()
            else:
                stack.append(ch)
        return not stack$$),
('e1000000-0000-0000-0000-000000000007','c1000000-0000-0000-0000-000000000002','a1000000-0000-0000-0000-000000000002',
$$#include <string>
#include <stack>
using namespace std;
class Solution {
public:
    bool isValid(string s) {
        // Write your solution here
        return false;
    }
};$$,
$$#include <string>
#include <stack>
using namespace std;
class Solution {
public:
    bool isValid(string s) {
        stack<char> st;
        for (char c : s) {
            if (c=='(' || c=='{' || c=='[') { st.push(c); continue; }
            if (st.empty()) return false;
            if (c==')' && st.top()!='(') return false;
            if (c=='}' && st.top()!='{') return false;
            if (c==']' && st.top()!='[') return false;
            st.pop();
        }
        return st.empty();
    }
};$$),
('e1000000-0000-0000-0000-000000000008','c1000000-0000-0000-0000-000000000002','a1000000-0000-0000-0000-000000000003',
$$/**
 * @param {string} s
 * @return {boolean}
 */
var isValid = function(s) {
    // Write your solution here
};$$,
$$var isValid = function(s) {
    const stack = [];
    const map = {')':'(', '}':'{', ']':'['};
    for (const c of s) {
        if ('({['.includes(c)) { stack.push(c); continue; }
        if (stack.pop() !== map[c]) return false;
    }
    return stack.length === 0;
};$$),
('e1000000-0000-0000-0000-000000000009','c1000000-0000-0000-0000-000000000002','a1000000-0000-0000-0000-000000000004',
$$import java.util.Stack;
class Solution {
    public boolean isValid(String s) {
        // Write your solution here
        return false;
    }
}$$,
$$import java.util.Stack;
class Solution {
    public boolean isValid(String s) {
        Stack<Character> st = new Stack<>();
        for (char c : s.toCharArray()) {
            if (c=='(' || c=='{' || c=='[') { st.push(c); continue; }
            if (st.isEmpty()) return false;
            char top = st.pop();
            if (c==')' && top!='(') return false;
            if (c=='}' && top!='{') return false;
            if (c==']' && top!='[') return false;
        }
        return st.isEmpty();
    }
}$$),
('e1000000-0000-0000-0000-000000000010','c1000000-0000-0000-0000-000000000002','a1000000-0000-0000-0000-000000000005',
$$#include <stdbool.h>
#include <string.h>
bool isValid(char* s) {
    // Write your solution here
    return false;
}$$,
$$#include <stdbool.h>
#include <string.h>
bool isValid(char* s) {
    int n = strlen(s);
    char* stack = (char*)__builtin_alloca(n + 1);
    int top = 0;
    for (int i = 0; s[i]; i++) {
        char c = s[i];
        if (c=='(' || c=='{' || c=='[') { stack[top++] = c; continue; }
        if (top == 0) return false;
        char t = stack[--top];
        if (c==')' && t!='(') return false;
        if (c=='}' && t!='{') return false;
        if (c==']' && t!='[') return false;
    }
    return top == 0;
}$$);


-- =============================================================
--  PROBLEM 3 — Best Time to Buy and Sell Stock  [EASY]
-- =============================================================
INSERT INTO problems (
  id, title, slug, difficulty, is_published,
  time_limit_ms, memory_limit_kb, total_submissions, total_accepted, description
) VALUES (
  'c1000000-0000-0000-0000-000000000003',
  'Best Time to Buy and Sell Stock', 'best-time-to-buy-and-sell-stock', 'easy', TRUE,
  2000, 262144, 8123456, 4567890,
$$
## Problem

You are given an array `prices` where `prices[i]` is the price of a given stock on the `i`th day.

You want to maximize your profit by choosing a **single day** to buy one stock and choosing a **different day in the future** to sell that stock.

Return the **maximum profit** you can achieve from this transaction. If you cannot achieve any profit, return `0`.

---

## Examples

**Example 1:**
```
Input:  prices = [7, 1, 5, 3, 6, 4]
Output: 5
Explanation: Buy on day 2 (price=1), sell on day 5 (price=6). Profit = 6-1 = 5.
```

**Example 2:**
```
Input:  prices = [7, 6, 4, 3, 1]
Output: 0
Explanation: No profitable transaction possible.
```

---

## Constraints

- `1 <= prices.length <= 10^5`
- `0 <= prices[i] <= 10^4`
$$);

INSERT INTO problem_tags (problem_id, tag_id) VALUES
  ('c1000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000001'),
  ('c1000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000010'),
  ('c1000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000015');

INSERT INTO test_cases (id, problem_id, input, expected_output, is_sample, explanation, order_index) VALUES
  ('d1000000-0000-0000-0000-000000000013','c1000000-0000-0000-0000-000000000003','{"prices":[7,1,5,3,6,4]}','5',TRUE,'Buy at 1, sell at 6',1),
  ('d1000000-0000-0000-0000-000000000014','c1000000-0000-0000-0000-000000000003','{"prices":[7,6,4,3,1]}','0',TRUE,'Prices always decline',2),
  ('d1000000-0000-0000-0000-000000000015','c1000000-0000-0000-0000-000000000003','{"prices":[2,4,1]}','2',FALSE,NULL,3),
  ('d1000000-0000-0000-0000-000000000016','c1000000-0000-0000-0000-000000000003','{"prices":[1]}','0',FALSE,NULL,4),
  ('d1000000-0000-0000-0000-000000000017','c1000000-0000-0000-0000-000000000003','{"prices":[3,1,4,8,2,9]}','8',FALSE,NULL,5);

INSERT INTO problem_templates (id, problem_id, language_id, starter_code, solution_code) VALUES
('e1000000-0000-0000-0000-000000000011','c1000000-0000-0000-0000-000000000003','a1000000-0000-0000-0000-000000000001',
$$from typing import List
class Solution:
    def maxProfit(self, prices: List[int]) -> int:
        pass$$,
$$from typing import List
class Solution:
    def maxProfit(self, prices: List[int]) -> int:
        min_price, max_profit = float('inf'), 0
        for p in prices:
            min_price = min(min_price, p)
            max_profit = max(max_profit, p - min_price)
        return max_profit$$),
('e1000000-0000-0000-0000-000000000012','c1000000-0000-0000-0000-000000000003','a1000000-0000-0000-0000-000000000002',
$$#include <vector>
#include <algorithm>
using namespace std;
class Solution {
public:
    int maxProfit(vector<int>& prices) {
        // Write your solution here
        return 0;
    }
};$$,
$$#include <vector>
#include <algorithm>
using namespace std;
class Solution {
public:
    int maxProfit(vector<int>& prices) {
        int minP = INT_MAX, res = 0;
        for (int p : prices) { minP = min(minP, p); res = max(res, p - minP); }
        return res;
    }
};$$),
('e1000000-0000-0000-0000-000000000013','c1000000-0000-0000-0000-000000000003','a1000000-0000-0000-0000-000000000003',
$$/**
 * @param {number[]} prices
 * @return {number}
 */
var maxProfit = function(prices) {
    // Write your solution here
};$$,
$$var maxProfit = function(prices) {
    let minP = Infinity, res = 0;
    for (const p of prices) { minP = Math.min(minP, p); res = Math.max(res, p - minP); }
    return res;
};$$),
('e1000000-0000-0000-0000-000000000014','c1000000-0000-0000-0000-000000000003','a1000000-0000-0000-0000-000000000004',
$$class Solution {
    public int maxProfit(int[] prices) {
        // Write your solution here
        return 0;
    }
}$$,
$$class Solution {
    public int maxProfit(int[] prices) {
        int minP = Integer.MAX_VALUE, res = 0;
        for (int p : prices) { minP = Math.min(minP, p); res = Math.max(res, p - minP); }
        return res;
    }
}$$),
('e1000000-0000-0000-0000-000000000015','c1000000-0000-0000-0000-000000000003','a1000000-0000-0000-0000-000000000005',
$$int maxProfit(int* prices, int pricesSize) {
    // Write your solution here
    return 0;
}$$,
$$int maxProfit(int* prices, int pricesSize) {
    int minP = prices[0], res = 0;
    for (int i = 1; i < pricesSize; i++) {
        if (prices[i] < minP) minP = prices[i];
        else if (prices[i] - minP > res) res = prices[i] - minP;
    }
    return res;
}$$);


-- =============================================================
--  PROBLEM 4 — Climbing Stairs  [EASY]
-- =============================================================
INSERT INTO problems (
  id, title, slug, difficulty, is_published,
  time_limit_ms, memory_limit_kb, total_submissions, total_accepted, description
) VALUES (
  'c1000000-0000-0000-0000-000000000004',
  'Climbing Stairs', 'climbing-stairs', 'easy', TRUE,
  2000, 262144, 6512345, 3987654,
$$
## Problem

You are climbing a staircase. It takes `n` steps to reach the top.

Each time you can either climb `1` or `2` steps. In how many **distinct ways** can you climb to the top?

---

## Examples

**Example 1:**
```
Input:  n = 2
Output: 2
Explanation: There are two ways to climb to the top.
  1. 1 step + 1 step
  2. 2 steps
```

**Example 2:**
```
Input:  n = 3
Output: 3
Explanation: There are three ways.
  1. 1+1+1  2. 1+2  3. 2+1
```

---

## Constraints

- `1 <= n <= 45`

---

## Hint

This problem is essentially the **Fibonacci** sequence.
`f(n) = f(n-1) + f(n-2)`
$$);

INSERT INTO problem_tags (problem_id, tag_id) VALUES
  ('c1000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000010'),
  ('c1000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000011');

INSERT INTO test_cases (id, problem_id, input, expected_output, is_sample, explanation, order_index) VALUES
  ('d1000000-0000-0000-0000-000000000018','c1000000-0000-0000-0000-000000000004','{"n":2}','2',TRUE,'Two ways: 1+1, 2',1),
  ('d1000000-0000-0000-0000-000000000019','c1000000-0000-0000-0000-000000000004','{"n":3}','3',TRUE,'Three ways',2),
  ('d1000000-0000-0000-0000-000000000020','c1000000-0000-0000-0000-000000000004','{"n":1}','1',FALSE,NULL,3),
  ('d1000000-0000-0000-0000-000000000021','c1000000-0000-0000-0000-000000000004','{"n":10}','89',FALSE,NULL,4),
  ('d1000000-0000-0000-0000-000000000022','c1000000-0000-0000-0000-000000000004','{"n":45}','1836311903',FALSE,NULL,5);

INSERT INTO problem_templates (id, problem_id, language_id, starter_code, solution_code) VALUES
('e1000000-0000-0000-0000-000000000016','c1000000-0000-0000-0000-000000000004','a1000000-0000-0000-0000-000000000001',
$$class Solution:
    def climbStairs(self, n: int) -> int:
        pass$$,
$$class Solution:
    def climbStairs(self, n: int) -> int:
        a, b = 1, 1
        for _ in range(n - 1):
            a, b = b, a + b
        return b$$),
('e1000000-0000-0000-0000-000000000017','c1000000-0000-0000-0000-000000000004','a1000000-0000-0000-0000-000000000002',
$$class Solution {
public:
    int climbStairs(int n) {
        // Write your solution here
        return 0;
    }
};$$,
$$class Solution {
public:
    int climbStairs(int n) {
        int a = 1, b = 1;
        for (int i = 1; i < n; i++) { int t = a + b; a = b; b = t; }
        return b;
    }
};$$),
('e1000000-0000-0000-0000-000000000018','c1000000-0000-0000-0000-000000000004','a1000000-0000-0000-0000-000000000003',
$$/**
 * @param {number} n
 * @return {number}
 */
var climbStairs = function(n) {
    // Write your solution here
};$$,
$$var climbStairs = function(n) {
    let [a, b] = [1, 1];
    for (let i = 1; i < n; i++) [a, b] = [b, a + b];
    return b;
};$$),
('e1000000-0000-0000-0000-000000000019','c1000000-0000-0000-0000-000000000004','a1000000-0000-0000-0000-000000000004',
$$class Solution {
    public int climbStairs(int n) {
        // Write your solution here
        return 0;
    }
}$$,
$$class Solution {
    public int climbStairs(int n) {
        int a = 1, b = 1;
        for (int i = 1; i < n; i++) { int t = a + b; a = b; b = t; }
        return b;
    }
}$$),
('e1000000-0000-0000-0000-000000000020','c1000000-0000-0000-0000-000000000004','a1000000-0000-0000-0000-000000000005',
$$int climbStairs(int n) {
    // Write your solution here
    return 0;
}$$,
$$int climbStairs(int n) {
    int a = 1, b = 1, t;
    for (int i = 1; i < n; i++) { t = a + b; a = b; b = t; }
    return b;
}$$);


-- =============================================================
--  PROBLEM 5 — Reverse Linked List  [EASY]
-- =============================================================
INSERT INTO problems (
  id, title, slug, difficulty, is_published,
  time_limit_ms, memory_limit_kb, total_submissions, total_accepted, description
) VALUES (
  'c1000000-0000-0000-0000-000000000005',
  'Reverse Linked List', 'reverse-linked-list', 'easy', TRUE,
  2000, 262144, 5678901, 3456789,
$$
## Problem

Given the `head` of a singly linked list, reverse the list, and return the **reversed list**.

---

## Examples

**Example 1:**
```
Input:  head = [1,2,3,4,5]
Output: [5,4,3,2,1]
```

**Example 2:**
```
Input:  head = [1,2]
Output: [2,1]
```

**Example 3:**
```
Input:  head = []
Output: []
```

---

## Constraints

- The number of nodes in the list is in the range `[0, 5000]`.
- `-5000 <= Node.val <= 5000`

---

## Follow-up

A linked list can be reversed either **iteratively** or **recursively**. Could you implement both?
$$);

INSERT INTO problem_tags (problem_id, tag_id) VALUES
  ('c1000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000005'),
  ('c1000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000012');

INSERT INTO test_cases (id, problem_id, input, expected_output, is_sample, explanation, order_index) VALUES
  ('d1000000-0000-0000-0000-000000000023','c1000000-0000-0000-0000-000000000005','{"head":[1,2,3,4,5]}','[5,4,3,2,1]',TRUE,'Reversed list',1),
  ('d1000000-0000-0000-0000-000000000024','c1000000-0000-0000-0000-000000000005','{"head":[1,2]}','[2,1]',TRUE,'Two nodes reversed',2),
  ('d1000000-0000-0000-0000-000000000025','c1000000-0000-0000-0000-000000000005','{"head":[]}','[]',FALSE,NULL,3),
  ('d1000000-0000-0000-0000-000000000026','c1000000-0000-0000-0000-000000000005','{"head":[1]}','[1]',FALSE,NULL,4);

INSERT INTO problem_templates (id, problem_id, language_id, starter_code, solution_code) VALUES
('e1000000-0000-0000-0000-000000000021','c1000000-0000-0000-0000-000000000005','a1000000-0000-0000-0000-000000000001',
$$from typing import Optional
class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next
class Solution:
    def reverseList(self, head: Optional[ListNode]) -> Optional[ListNode]:
        pass$$,
$$class Solution:
    def reverseList(self, head):
        prev, curr = None, head
        while curr:
            nxt = curr.next
            curr.next = prev
            prev = curr
            curr = nxt
        return prev$$),
('e1000000-0000-0000-0000-000000000022','c1000000-0000-0000-0000-000000000005','a1000000-0000-0000-0000-000000000002',
$$struct ListNode { int val; ListNode *next; };
class Solution {
public:
    ListNode* reverseList(ListNode* head) {
        // Write your solution here
        return nullptr;
    }
};$$,
$$class Solution {
public:
    ListNode* reverseList(ListNode* head) {
        ListNode* prev = nullptr;
        while (head) {
            ListNode* nxt = head->next;
            head->next = prev;
            prev = head;
            head = nxt;
        }
        return prev;
    }
};$$),
('e1000000-0000-0000-0000-000000000023','c1000000-0000-0000-0000-000000000005','a1000000-0000-0000-0000-000000000003',
$$function ListNode(val, next) { this.val = (val===undefined ? 0 : val); this.next = (next===undefined ? null : next); }
/**
 * @param {ListNode} head
 * @return {ListNode}
 */
var reverseList = function(head) {
    // Write your solution here
};$$,
$$var reverseList = function(head) {
    let prev = null, curr = head;
    while (curr) {
        const nxt = curr.next;
        curr.next = prev;
        prev = curr;
        curr = nxt;
    }
    return prev;
};$$),
('e1000000-0000-0000-0000-000000000024','c1000000-0000-0000-0000-000000000005','a1000000-0000-0000-0000-000000000004',
$$class ListNode { int val; ListNode next; ListNode(int x) { val = x; } }
class Solution {
    public ListNode reverseList(ListNode head) {
        // Write your solution here
        return null;
    }
}$$,
$$class Solution {
    public ListNode reverseList(ListNode head) {
        ListNode prev = null;
        while (head != null) {
            ListNode nxt = head.next;
            head.next = prev;
            prev = head;
            head = nxt;
        }
        return prev;
    }
}$$),
('e1000000-0000-0000-0000-000000000025','c1000000-0000-0000-0000-000000000005','a1000000-0000-0000-0000-000000000005',
$$#include <stdlib.h>
struct ListNode { int val; struct ListNode* next; };
struct ListNode* reverseList(struct ListNode* head) {
    // Write your solution here
    return NULL;
}$$,
$$struct ListNode* reverseList(struct ListNode* head) {
    struct ListNode* prev = NULL;
    while (head) {
        struct ListNode* nxt = head->next;
        head->next = prev;
        prev = head;
        head = nxt;
    }
    return prev;
}$$);


-- =============================================================
--  PROBLEM 6 — Palindrome Number  [EASY]
-- =============================================================
INSERT INTO problems (
  id, title, slug, difficulty, is_published,
  time_limit_ms, memory_limit_kb, total_submissions, total_accepted, description
) VALUES (
  'c1000000-0000-0000-0000-000000000006',
  'Palindrome Number', 'palindrome-number', 'easy', TRUE,
  2000, 262144, 7890123, 4567012,
$$
## Problem

Given an integer `x`, return `true` if `x` is a **palindrome**, and `false` otherwise.

An integer is a **palindrome** when it reads the same forward and backward. For example, `121` is a palindrome while `123` is not.

---

## Examples

**Example 1:**
```
Input:  x = 121
Output: true
```

**Example 2:**
```
Input:  x = -121
Output: false
Explanation: From left to right it reads -121. From right to left it reads 121-. Not a palindrome.
```

**Example 3:**
```
Input:  x = 10
Output: false
Explanation: Reads 01 from right to left. Not a palindrome.
```

---

## Constraints

- `-2^31 <= x <= 2^31 - 1`

---

## Follow-up

Could you solve it **without converting the integer to a string**?
$$);

INSERT INTO problem_tags (problem_id, tag_id) VALUES
  ('c1000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000011');

INSERT INTO test_cases (id, problem_id, input, expected_output, is_sample, explanation, order_index) VALUES
  ('d1000000-0000-0000-0000-000000000027','c1000000-0000-0000-0000-000000000006','{"x":121}','true',TRUE,'121 reversed is 121',1),
  ('d1000000-0000-0000-0000-000000000028','c1000000-0000-0000-0000-000000000006','{"x":-121}','false',TRUE,'Negatives are never palindromes',2),
  ('d1000000-0000-0000-0000-000000000029','c1000000-0000-0000-0000-000000000006','{"x":10}','false',TRUE,'10 reversed is 01',3),
  ('d1000000-0000-0000-0000-000000000030','c1000000-0000-0000-0000-000000000006','{"x":0}','true',FALSE,NULL,4),
  ('d1000000-0000-0000-0000-000000000031','c1000000-0000-0000-0000-000000000006','{"x":1221}','true',FALSE,NULL,5),
  ('d1000000-0000-0000-0000-000000000032','c1000000-0000-0000-0000-000000000006','{"x":2147483647}','false',FALSE,NULL,6);

INSERT INTO problem_templates (id, problem_id, language_id, starter_code, solution_code) VALUES
('e1000000-0000-0000-0000-000000000026','c1000000-0000-0000-0000-000000000006','a1000000-0000-0000-0000-000000000001',
$$class Solution:
    def isPalindrome(self, x: int) -> bool:
        pass$$,
$$class Solution:
    def isPalindrome(self, x: int) -> bool:
        if x < 0 or (x % 10 == 0 and x != 0): return False
        rev = 0
        while x > rev:
            rev = rev * 10 + x % 10
            x //= 10
        return x == rev or x == rev // 10$$),
('e1000000-0000-0000-0000-000000000027','c1000000-0000-0000-0000-000000000006','a1000000-0000-0000-0000-000000000002',
$$class Solution {
public:
    bool isPalindrome(int x) {
        // Write your solution here
        return false;
    }
};$$,
$$class Solution {
public:
    bool isPalindrome(int x) {
        if (x < 0 || (x % 10 == 0 && x != 0)) return false;
        int rev = 0;
        while (x > rev) { rev = rev * 10 + x % 10; x /= 10; }
        return x == rev || x == rev / 10;
    }
};$$),
('e1000000-0000-0000-0000-000000000028','c1000000-0000-0000-0000-000000000006','a1000000-0000-0000-0000-000000000003',
$$/**
 * @param {number} x
 * @return {boolean}
 */
var isPalindrome = function(x) {
    // Write your solution here
};$$,
$$var isPalindrome = function(x) {
    if (x < 0 || (x % 10 === 0 && x !== 0)) return false;
    let rev = 0;
    while (x > rev) { rev = rev * 10 + x % 10; x = Math.floor(x / 10); }
    return x === rev || x === Math.floor(rev / 10);
};$$),
('e1000000-0000-0000-0000-000000000029','c1000000-0000-0000-0000-000000000006','a1000000-0000-0000-0000-000000000004',
$$class Solution {
    public boolean isPalindrome(int x) {
        // Write your solution here
        return false;
    }
}$$,
$$class Solution {
    public boolean isPalindrome(int x) {
        if (x < 0 || (x % 10 == 0 && x != 0)) return false;
        int rev = 0;
        while (x > rev) { rev = rev * 10 + x % 10; x /= 10; }
        return x == rev || x == rev / 10;
    }
}$$),
('e1000000-0000-0000-0000-000000000030','c1000000-0000-0000-0000-000000000006','a1000000-0000-0000-0000-000000000005',
$$#include <stdbool.h>
bool isPalindrome(int x) {
    // Write your solution here
    return false;
}$$,
$$#include <stdbool.h>
bool isPalindrome(int x) {
    if (x < 0 || (x % 10 == 0 && x != 0)) return false;
    int rev = 0;
    while (x > rev) { rev = rev * 10 + x % 10; x /= 10; }
    return x == rev || x == rev / 10;
}$$);


-- =============================================================
--  PROBLEM 7 — Majority Element  [EASY]
-- =============================================================
INSERT INTO problems (
  id, title, slug, difficulty, is_published,
  time_limit_ms, memory_limit_kb, total_submissions, total_accepted, description
) VALUES (
  'c1000000-0000-0000-0000-000000000007',
  'Majority Element', 'majority-element', 'easy', TRUE,
  2000, 262144, 5123456, 3678901,
$$
## Problem

Given an array `nums` of size `n`, return the **majority element**.

The majority element is the element that appears **more than** `⌊n / 2⌋` times. You may assume that the majority element always exists in the array.

---

## Examples

**Example 1:**
```
Input:  nums = [3, 2, 3]
Output: 3
```

**Example 2:**
```
Input:  nums = [2, 2, 1, 1, 1, 2, 2]
Output: 2
```

---

## Constraints

- `n == nums.length`
- `1 <= n <= 5 * 10^4`
- `-10^9 <= nums[i] <= 10^9`

---

## Follow-up

Could you solve the problem in linear time and in **O(1)** space? (Boyer-Moore Voting Algorithm)
$$);

INSERT INTO problem_tags (problem_id, tag_id) VALUES
  ('c1000000-0000-0000-0000-000000000007', 'b1000000-0000-0000-0000-000000000001'),
  ('c1000000-0000-0000-0000-000000000007', 'b1000000-0000-0000-0000-000000000002');

INSERT INTO test_cases (id, problem_id, input, expected_output, is_sample, explanation, order_index) VALUES
  ('d1000000-0000-0000-0000-000000000033','c1000000-0000-0000-0000-000000000007','{"nums":[3,2,3]}','3',TRUE,'3 appears twice out of 3',1),
  ('d1000000-0000-0000-0000-000000000034','c1000000-0000-0000-0000-000000000007','{"nums":[2,2,1,1,1,2,2]}','2',TRUE,'2 appears 4 times out of 7',2),
  ('d1000000-0000-0000-0000-000000000035','c1000000-0000-0000-0000-000000000007','{"nums":[1]}','1',FALSE,NULL,3),
  ('d1000000-0000-0000-0000-000000000036','c1000000-0000-0000-0000-000000000007','{"nums":[6,5,5]}','5',FALSE,NULL,4);

INSERT INTO problem_templates (id, problem_id, language_id, starter_code, solution_code) VALUES
('e1000000-0000-0000-0000-000000000031','c1000000-0000-0000-0000-000000000007','a1000000-0000-0000-0000-000000000001',
$$from typing import List
class Solution:
    def majorityElement(self, nums: List[int]) -> int:
        pass$$,
$$class Solution:
    def majorityElement(self, nums):
        count, candidate = 0, 0
        for n in nums:
            if count == 0: candidate = n
            count += 1 if n == candidate else -1
        return candidate$$),
('e1000000-0000-0000-0000-000000000032','c1000000-0000-0000-0000-000000000007','a1000000-0000-0000-0000-000000000002',
$$#include <vector>
using namespace std;
class Solution {
public:
    int majorityElement(vector<int>& nums) {
        // Write your solution here
        return 0;
    }
};$$,
$$class Solution {
public:
    int majorityElement(vector<int>& nums) {
        int count = 0, candidate = 0;
        for (int n : nums) {
            if (count == 0) candidate = n;
            count += (n == candidate) ? 1 : -1;
        }
        return candidate;
    }
};$$),
('e1000000-0000-0000-0000-000000000033','c1000000-0000-0000-0000-000000000007','a1000000-0000-0000-0000-000000000003',
$$/**
 * @param {number[]} nums
 * @return {number}
 */
var majorityElement = function(nums) {
    // Write your solution here
};$$,
$$var majorityElement = function(nums) {
    let count = 0, candidate = 0;
    for (const n of nums) {
        if (count === 0) candidate = n;
        count += n === candidate ? 1 : -1;
    }
    return candidate;
};$$),
('e1000000-0000-0000-0000-000000000034','c1000000-0000-0000-0000-000000000007','a1000000-0000-0000-0000-000000000004',
$$class Solution {
    public int majorityElement(int[] nums) {
        // Write your solution here
        return 0;
    }
}$$,
$$class Solution {
    public int majorityElement(int[] nums) {
        int count = 0, candidate = 0;
        for (int n : nums) {
            if (count == 0) candidate = n;
            count += n == candidate ? 1 : -1;
        }
        return candidate;
    }
}$$),
('e1000000-0000-0000-0000-000000000035','c1000000-0000-0000-0000-000000000007','a1000000-0000-0000-0000-000000000005',
$$int majorityElement(int* nums, int numsSize) {
    // Write your solution here
    return 0;
}$$,
$$int majorityElement(int* nums, int numsSize) {
    int count = 0, candidate = 0;
    for (int i = 0; i < numsSize; i++) {
        if (count == 0) candidate = nums[i];
        count += (nums[i] == candidate) ? 1 : -1;
    }
    return candidate;
}$$);


-- =============================================================
--  PROBLEM 8 — Longest Substring Without Repeating Characters  [MEDIUM]
-- =============================================================
INSERT INTO problems (
  id, title, slug, difficulty, is_published,
  time_limit_ms, memory_limit_kb, total_submissions, total_accepted, description
) VALUES (
  'c1000000-0000-0000-0000-000000000008',
  'Longest Substring Without Repeating Characters',
  'longest-substring-without-repeating-characters', 'medium', TRUE,
  2000, 262144, 6123445, 2701234,
$$
## Problem

Given a string `s`, find the length of the **longest substring** without repeating characters.

---

## Examples

**Example 1:**
```
Input:  s = "abcabcbb"
Output: 3
Explanation: The answer is "abc", with the length of 3.
```

**Example 2:**
```
Input:  s = "bbbbb"
Output: 1
```

**Example 3:**
```
Input:  s = "pwwkew"
Output: 3
Explanation: The answer is "wke".
```

---

## Constraints

- `0 <= s.length <= 5 * 10^4`
- `s` consists of English letters, digits, symbols and spaces.

---

## Hints

> **Hint 1:** Use a sliding window `[left, right]`. Expand right, shrink left on duplicate.

> **Hint 2:** A hash map storing the last-seen index of each character lets you jump `left` directly.
$$);

INSERT INTO problem_tags (problem_id, tag_id) VALUES
  ('c1000000-0000-0000-0000-000000000008', 'b1000000-0000-0000-0000-000000000003'),
  ('c1000000-0000-0000-0000-000000000008', 'b1000000-0000-0000-0000-000000000004'),
  ('c1000000-0000-0000-0000-000000000008', 'b1000000-0000-0000-0000-000000000002');

INSERT INTO test_cases (id, problem_id, input, expected_output, is_sample, explanation, order_index) VALUES
  ('d1000000-0000-0000-0000-000000000037','c1000000-0000-0000-0000-000000000008','{"s":"abcabcbb"}','3',TRUE,'Longest is "abc"',1),
  ('d1000000-0000-0000-0000-000000000038','c1000000-0000-0000-0000-000000000008','{"s":"bbbbb"}','1',TRUE,'Longest is "b"',2),
  ('d1000000-0000-0000-0000-000000000039','c1000000-0000-0000-0000-000000000008','{"s":"pwwkew"}','3',FALSE,NULL,3),
  ('d1000000-0000-0000-0000-000000000040','c1000000-0000-0000-0000-000000000008','{"s":""}','0',FALSE,NULL,4),
  ('d1000000-0000-0000-0000-000000000041','c1000000-0000-0000-0000-000000000008','{"s":"dvdf"}','3',FALSE,NULL,5);

INSERT INTO problem_templates (id, problem_id, language_id, starter_code, solution_code) VALUES
('e1000000-0000-0000-0000-000000000036','c1000000-0000-0000-0000-000000000008','a1000000-0000-0000-0000-000000000001',
$$class Solution:
    def lengthOfLongestSubstring(self, s: str) -> int:
        pass$$,
$$class Solution:
    def lengthOfLongestSubstring(self, s: str) -> int:
        seen = {}; left = res = 0
        for right, ch in enumerate(s):
            if ch in seen and seen[ch] >= left:
                left = seen[ch] + 1
            seen[ch] = right
            res = max(res, right - left + 1)
        return res$$),
('e1000000-0000-0000-0000-000000000037','c1000000-0000-0000-0000-000000000008','a1000000-0000-0000-0000-000000000002',
$$#include <string>
#include <unordered_map>
using namespace std;
class Solution {
public:
    int lengthOfLongestSubstring(string s) {
        // Write your solution here
        return 0;
    }
};$$,
$$class Solution {
public:
    int lengthOfLongestSubstring(string s) {
        unordered_map<char,int> seen;
        int left = 0, res = 0;
        for (int r = 0; r < (int)s.size(); r++) {
            if (seen.count(s[r]) && seen[s[r]] >= left) left = seen[s[r]] + 1;
            seen[s[r]] = r;
            res = max(res, r - left + 1);
        }
        return res;
    }
};$$),
('e1000000-0000-0000-0000-000000000038','c1000000-0000-0000-0000-000000000008','a1000000-0000-0000-0000-000000000003',
$$/**
 * @param {string} s
 * @return {number}
 */
var lengthOfLongestSubstring = function(s) {
    // Write your solution here
};$$,
$$var lengthOfLongestSubstring = function(s) {
    const seen = new Map(); let left = 0, res = 0;
    for (let r = 0; r < s.length; r++) {
        if (seen.has(s[r]) && seen.get(s[r]) >= left) left = seen.get(s[r]) + 1;
        seen.set(s[r], r);
        res = Math.max(res, r - left + 1);
    }
    return res;
};$$),
('e1000000-0000-0000-0000-000000000039','c1000000-0000-0000-0000-000000000008','a1000000-0000-0000-0000-000000000004',
$$import java.util.HashMap;
class Solution {
    public int lengthOfLongestSubstring(String s) {
        // Write your solution here
        return 0;
    }
}$$,
$$import java.util.HashMap;
class Solution {
    public int lengthOfLongestSubstring(String s) {
        HashMap<Character,Integer> seen = new HashMap<>();
        int left = 0, res = 0;
        for (int r = 0; r < s.length(); r++) {
            char c = s.charAt(r);
            if (seen.containsKey(c) && seen.get(c) >= left) left = seen.get(c) + 1;
            seen.put(c, r);
            res = Math.max(res, r - left + 1);
        }
        return res;
    }
}$$),
('e1000000-0000-0000-0000-000000000040','c1000000-0000-0000-0000-000000000008','a1000000-0000-0000-0000-000000000005',
$$int lengthOfLongestSubstring(char* s) {
    // Write your solution here
    return 0;
}$$,
$$int lengthOfLongestSubstring(char* s) {
    int seen[128]; for (int i = 0; i < 128; i++) seen[i] = -1;
    int left = 0, res = 0;
    for (int r = 0; s[r]; r++) {
        if (seen[(int)s[r]] >= left) left = seen[(int)s[r]] + 1;
        seen[(int)s[r]] = r;
        if (r - left + 1 > res) res = r - left + 1;
    }
    return res;
}$$);


-- =============================================================
--  PROBLEM 9 — Add Two Numbers  [MEDIUM]
-- =============================================================
INSERT INTO problems (
  id, title, slug, difficulty, is_published,
  time_limit_ms, memory_limit_kb, total_submissions, total_accepted, description
) VALUES (
  'c1000000-0000-0000-0000-000000000009',
  'Add Two Numbers', 'add-two-numbers', 'medium', TRUE,
  2000, 262144, 5401238, 2234567,
$$
## Problem

You are given two **non-empty** linked lists representing two non-negative integers. Digits are stored in **reverse order**, and each node contains a single digit. Add the two numbers and return the sum as a linked list.

---

## Examples

**Example 1:**
```
Input:  l1 = [2,4,3], l2 = [5,6,4]
Output: [7,0,8]
Explanation: 342 + 465 = 807
```

**Example 2:**
```
Input:  l1 = [0], l2 = [0]
Output: [0]
```

**Example 3:**
```
Input:  l1 = [9,9,9,9,9,9,9], l2 = [9,9,9,9]
Output: [8,9,9,9,0,0,0,1]
```

---

## Constraints

- Number of nodes in each list is in `[1, 100]`.
- `0 <= Node.val <= 9`
$$);

INSERT INTO problem_tags (problem_id, tag_id) VALUES
  ('c1000000-0000-0000-0000-000000000009', 'b1000000-0000-0000-0000-000000000005'),
  ('c1000000-0000-0000-0000-000000000009', 'b1000000-0000-0000-0000-000000000011'),
  ('c1000000-0000-0000-0000-000000000009', 'b1000000-0000-0000-0000-000000000012');

INSERT INTO test_cases (id, problem_id, input, expected_output, is_sample, explanation, order_index) VALUES
  ('d1000000-0000-0000-0000-000000000042','c1000000-0000-0000-0000-000000000009','{"l1":[2,4,3],"l2":[5,6,4]}','[7,0,8]',TRUE,'342+465=807',1),
  ('d1000000-0000-0000-0000-000000000043','c1000000-0000-0000-0000-000000000009','{"l1":[0],"l2":[0]}','[0]',TRUE,'0+0=0',2),
  ('d1000000-0000-0000-0000-000000000044','c1000000-0000-0000-0000-000000000009','{"l1":[9,9,9,9,9,9,9],"l2":[9,9,9,9]}','[8,9,9,9,0,0,0,1]',TRUE,'9999999+9999',3),
  ('d1000000-0000-0000-0000-000000000045','c1000000-0000-0000-0000-000000000009','{"l1":[5],"l2":[5]}','[0,1]',FALSE,NULL,4);

INSERT INTO problem_templates (id, problem_id, language_id, starter_code, solution_code) VALUES
('e1000000-0000-0000-0000-000000000041','c1000000-0000-0000-0000-000000000009','a1000000-0000-0000-0000-000000000001',
$$from typing import Optional
class ListNode:
    def __init__(self, val=0, next=None): self.val = val; self.next = next
class Solution:
    def addTwoNumbers(self, l1: Optional[ListNode], l2: Optional[ListNode]) -> Optional[ListNode]:
        pass$$,
$$class Solution:
    def addTwoNumbers(self, l1, l2):
        dummy = ListNode(); cur, carry = dummy, 0
        while l1 or l2 or carry:
            val = carry
            if l1: val += l1.val; l1 = l1.next
            if l2: val += l2.val; l2 = l2.next
            carry, val = divmod(val, 10)
            cur.next = ListNode(val); cur = cur.next
        return dummy.next$$),
('e1000000-0000-0000-0000-000000000042','c1000000-0000-0000-0000-000000000009','a1000000-0000-0000-0000-000000000002',
$$struct ListNode { int val; ListNode *next; ListNode(int x=0,ListNode*n=nullptr):val(x),next(n){} };
class Solution {
public:
    ListNode* addTwoNumbers(ListNode* l1, ListNode* l2) {
        // Write your solution here
        return nullptr;
    }
};$$,
$$class Solution {
public:
    ListNode* addTwoNumbers(ListNode* l1, ListNode* l2) {
        ListNode dummy; ListNode* cur = &dummy; int carry = 0;
        while (l1 || l2 || carry) {
            int sum = carry;
            if (l1) { sum += l1->val; l1 = l1->next; }
            if (l2) { sum += l2->val; l2 = l2->next; }
            carry = sum / 10;
            cur->next = new ListNode(sum % 10); cur = cur->next;
        }
        return dummy.next;
    }
};$$),
('e1000000-0000-0000-0000-000000000043','c1000000-0000-0000-0000-000000000009','a1000000-0000-0000-0000-000000000003',
$$function ListNode(val,next){this.val=(val===undefined?0:val);this.next=(next===undefined?null:next);}
var addTwoNumbers = function(l1, l2) {
    // Write your solution here
};$$,
$$var addTwoNumbers = function(l1, l2) {
    let dummy = new ListNode(), cur = dummy, carry = 0;
    while (l1 || l2 || carry) {
        let sum = carry;
        if (l1) { sum += l1.val; l1 = l1.next; }
        if (l2) { sum += l2.val; l2 = l2.next; }
        carry = Math.floor(sum / 10);
        cur.next = new ListNode(sum % 10); cur = cur.next;
    }
    return dummy.next;
};$$),
('e1000000-0000-0000-0000-000000000044','c1000000-0000-0000-0000-000000000009','a1000000-0000-0000-0000-000000000004',
$$class ListNode { int val; ListNode next; ListNode(int x){val=x;} }
class Solution {
    public ListNode addTwoNumbers(ListNode l1, ListNode l2) {
        // Write your solution here
        return null;
    }
}$$,
$$class Solution {
    public ListNode addTwoNumbers(ListNode l1, ListNode l2) {
        ListNode dummy = new ListNode(0); ListNode cur = dummy; int carry = 0;
        while (l1 != null || l2 != null || carry != 0) {
            int sum = carry;
            if (l1 != null) { sum += l1.val; l1 = l1.next; }
            if (l2 != null) { sum += l2.val; l2 = l2.next; }
            carry = sum / 10;
            cur.next = new ListNode(sum % 10); cur = cur.next;
        }
        return dummy.next;
    }
}$$),
('e1000000-0000-0000-0000-000000000045','c1000000-0000-0000-0000-000000000009','a1000000-0000-0000-0000-000000000005',
$$#include <stdlib.h>
struct ListNode { int val; struct ListNode* next; };
struct ListNode* addTwoNumbers(struct ListNode* l1, struct ListNode* l2) {
    // Write your solution here
    return NULL;
}$$,
$$struct ListNode* addTwoNumbers(struct ListNode* l1, struct ListNode* l2) {
    struct ListNode dummy; struct ListNode* cur = &dummy; int carry = 0;
    dummy.next = NULL;
    while (l1 || l2 || carry) {
        int sum = carry;
        if (l1) { sum += l1->val; l1 = l1->next; }
        if (l2) { sum += l2->val; l2 = l2->next; }
        carry = sum / 10;
        struct ListNode* node = (struct ListNode*)malloc(sizeof(struct ListNode));
        node->val = sum % 10; node->next = NULL;
        cur->next = node; cur = node;
    }
    return dummy.next;
}$$);


-- =============================================================
--  PROBLEM 10 — 3Sum  [MEDIUM]
-- =============================================================
INSERT INTO problems (
  id, title, slug, difficulty, is_published,
  time_limit_ms, memory_limit_kb, total_submissions, total_accepted, description
) VALUES (
  'c1000000-0000-0000-0000-000000000010',
  '3Sum', 'three-sum', 'medium', TRUE,
  2000, 262144, 4801234, 1890123,
$$
## Problem

Given an integer array `nums`, return all the triplets `[nums[i], nums[j], nums[k]]` such that `i != j`, `i != k`, `j != k`, and `nums[i] + nums[j] + nums[k] == 0`.

The solution set must not contain duplicate triplets.

---

## Examples

**Example 1:**
```
Input:  nums = [-1, 0, 1, 2, -1, -4]
Output: [[-1,-1,2],[-1,0,1]]
```

**Example 2:**
```
Input:  nums = [0, 1, 1]
Output: []
```

**Example 3:**
```
Input:  nums = [0, 0, 0]
Output: [[0,0,0]]
```

---

## Constraints

- `3 <= nums.length <= 3000`
- `-10^5 <= nums[i] <= 10^5`

---

## Hint

Sort the array, then for each element use two pointers on the remainder.
$$);

INSERT INTO problem_tags (problem_id, tag_id) VALUES
  ('c1000000-0000-0000-0000-000000000010', 'b1000000-0000-0000-0000-000000000001'),
  ('c1000000-0000-0000-0000-000000000010', 'b1000000-0000-0000-0000-000000000006');

INSERT INTO test_cases (id, problem_id, input, expected_output, is_sample, explanation, order_index) VALUES
  ('d1000000-0000-0000-0000-000000000046','c1000000-0000-0000-0000-000000000010','{"nums":[-1,0,1,2,-1,-4]}','[[-1,-1,2],[-1,0,1]]',TRUE,'Two unique triplets summing to 0',1),
  ('d1000000-0000-0000-0000-000000000047','c1000000-0000-0000-0000-000000000010','{"nums":[0,1,1]}','[]',TRUE,'No valid triplet',2),
  ('d1000000-0000-0000-0000-000000000048','c1000000-0000-0000-0000-000000000010','{"nums":[0,0,0]}','[[0,0,0]]',TRUE,'Single triplet of zeros',3),
  ('d1000000-0000-0000-0000-000000000049','c1000000-0000-0000-0000-000000000010','{"nums":[-4,-2,-2,-2,0,1,2,2,2,3,3,4,4,6,6]}','[[-4,-2,6],[-4,0,4],[-4,1,3],[-4,2,2],[-2,-2,4],[-2,0,2]]',FALSE,NULL,4);

INSERT INTO problem_templates (id, problem_id, language_id, starter_code, solution_code) VALUES
('e1000000-0000-0000-0000-000000000046','c1000000-0000-0000-0000-000000000010','a1000000-0000-0000-0000-000000000001',
$$from typing import List
class Solution:
    def threeSum(self, nums: List[int]) -> List[List[int]]:
        pass$$,
$$class Solution:
    def threeSum(self, nums):
        nums.sort(); res = []
        for i in range(len(nums) - 2):
            if i > 0 and nums[i] == nums[i-1]: continue
            l, r = i + 1, len(nums) - 1
            while l < r:
                s = nums[i] + nums[l] + nums[r]
                if s == 0:
                    res.append([nums[i], nums[l], nums[r]])
                    while l < r and nums[l] == nums[l+1]: l += 1
                    while l < r and nums[r] == nums[r-1]: r -= 1
                    l += 1; r -= 1
                elif s < 0: l += 1
                else: r -= 1
        return res$$),
('e1000000-0000-0000-0000-000000000047','c1000000-0000-0000-0000-000000000010','a1000000-0000-0000-0000-000000000002',
$$#include <vector>
#include <algorithm>
using namespace std;
class Solution {
public:
    vector<vector<int>> threeSum(vector<int>& nums) {
        // Write your solution here
        return {};
    }
};$$,
$$class Solution {
public:
    vector<vector<int>> threeSum(vector<int>& nums) {
        sort(nums.begin(), nums.end()); vector<vector<int>> res;
        for (int i = 0; i < (int)nums.size()-2; i++) {
            if (i > 0 && nums[i] == nums[i-1]) continue;
            int l = i+1, r = (int)nums.size()-1;
            while (l < r) {
                int s = nums[i]+nums[l]+nums[r];
                if (s == 0) {
                    res.push_back({nums[i],nums[l],nums[r]});
                    while (l<r && nums[l]==nums[l+1]) l++;
                    while (l<r && nums[r]==nums[r-1]) r--;
                    l++; r--;
                } else if (s < 0) l++; else r--;
            }
        }
        return res;
    }
};$$),
('e1000000-0000-0000-0000-000000000048','c1000000-0000-0000-0000-000000000010','a1000000-0000-0000-0000-000000000003',
$$/**
 * @param {number[]} nums
 * @return {number[][]}
 */
var threeSum = function(nums) {
    // Write your solution here
};$$,
$$var threeSum = function(nums) {
    nums.sort((a,b)=>a-b); const res=[];
    for (let i=0;i<nums.length-2;i++) {
        if (i>0 && nums[i]===nums[i-1]) continue;
        let l=i+1, r=nums.length-1;
        while (l<r) {
            const s=nums[i]+nums[l]+nums[r];
            if (s===0) {
                res.push([nums[i],nums[l],nums[r]]);
                while(l<r && nums[l]===nums[l+1]) l++;
                while(l<r && nums[r]===nums[r-1]) r--;
                l++; r--;
            } else if (s<0) l++; else r--;
        }
    }
    return res;
};$$),
('e1000000-0000-0000-0000-000000000049','c1000000-0000-0000-0000-000000000010','a1000000-0000-0000-0000-000000000004',
$$import java.util.*;
class Solution {
    public List<List<Integer>> threeSum(int[] nums) {
        // Write your solution here
        return new ArrayList<>();
    }
}$$,
$$import java.util.*;
class Solution {
    public List<List<Integer>> threeSum(int[] nums) {
        Arrays.sort(nums); List<List<Integer>> res = new ArrayList<>();
        for (int i=0;i<nums.length-2;i++) {
            if (i>0 && nums[i]==nums[i-1]) continue;
            int l=i+1, r=nums.length-1;
            while (l<r) {
                int s=nums[i]+nums[l]+nums[r];
                if (s==0) {
                    res.add(Arrays.asList(nums[i],nums[l],nums[r]));
                    while(l<r && nums[l]==nums[l+1]) l++;
                    while(l<r && nums[r]==nums[r-1]) r--;
                    l++; r--;
                } else if (s<0) l++; else r--;
            }
        }
        return res;
    }
}$$),
('e1000000-0000-0000-0000-000000000050','c1000000-0000-0000-0000-000000000010','a1000000-0000-0000-0000-000000000005',
$$#include <stdlib.h>
/* Returns flat array of triplets; *returnSize = number of triplets, *returnColumnSizes = array of 3s */
int** threeSum(int* nums, int numsSize, int* returnSize, int** returnColumnSizes) {
    // Write your solution here
    *returnSize = 0; return NULL;
}$$,
$$#include <stdlib.h>
int cmp(const void* a,const void* b){return *(int*)a-*(int*)b;}
int** threeSum(int* nums, int numsSize, int* returnSize, int** returnColumnSizes) {
    qsort(nums,numsSize,sizeof(int),cmp);
    int cap=500; int** res=(int**)malloc(cap*sizeof(int*));
    *returnColumnSizes=(int*)malloc(cap*sizeof(int));
    *returnSize=0;
    for (int i=0;i<numsSize-2;i++) {
        if (i>0 && nums[i]==nums[i-1]) continue;
        int l=i+1,r=numsSize-1;
        while(l<r) {
            int s=nums[i]+nums[l]+nums[r];
            if (s==0) {
                int* t=(int*)malloc(3*sizeof(int)); t[0]=nums[i];t[1]=nums[l];t[2]=nums[r];
                res[*returnSize]=t; (*returnColumnSizes)[*returnSize]=3; (*returnSize)++;
                while(l<r && nums[l]==nums[l+1]) l++;
                while(l<r && nums[r]==nums[r-1]) r--;
                l++;r--;
            } else if (s<0) l++; else r--;
        }
    }
    return res;
}$$);


-- =============================================================
--  PROBLEM 11 — Container With Most Water  [MEDIUM]
-- =============================================================
INSERT INTO problems (
  id, title, slug, difficulty, is_published,
  time_limit_ms, memory_limit_kb, total_submissions, total_accepted, description
) VALUES (
  'c1000000-0000-0000-0000-000000000011',
  'Container With Most Water', 'container-with-most-water', 'medium', TRUE,
  2000, 262144, 4012345, 2109876,
$$
## Problem

You are given an integer array `height` of length `n`. There are `n` vertical lines drawn such that the two endpoints of the `i`th line are `(i, 0)` and `(i, height[i])`.

Find two lines that together with the x-axis form a container, such that the container contains the most water.

Return the **maximum amount of water** a container can store.

---

## Examples

**Example 1:**
```
Input:  height = [1,8,6,2,5,4,8,3,7]
Output: 49
```

**Example 2:**
```
Input:  height = [1,1]
Output: 1
```

---

## Constraints

- `n == height.length`
- `2 <= n <= 10^5`
- `0 <= height[i] <= 10^4`
$$);

INSERT INTO problem_tags (problem_id, tag_id) VALUES
  ('c1000000-0000-0000-0000-000000000011', 'b1000000-0000-0000-0000-000000000001'),
  ('c1000000-0000-0000-0000-000000000011', 'b1000000-0000-0000-0000-000000000006'),
  ('c1000000-0000-0000-0000-000000000011', 'b1000000-0000-0000-0000-000000000015');

INSERT INTO test_cases (id, problem_id, input, expected_output, is_sample, explanation, order_index) VALUES
  ('d1000000-0000-0000-0000-000000000050','c1000000-0000-0000-0000-000000000011','{"height":[1,8,6,2,5,4,8,3,7]}','49',TRUE,'Lines 1 and 8 form area min(8,7)*7=49',1),
  ('d1000000-0000-0000-0000-000000000051','c1000000-0000-0000-0000-000000000011','{"height":[1,1]}','1',TRUE,'Only one pair',2),
  ('d1000000-0000-0000-0000-000000000052','c1000000-0000-0000-0000-000000000011','{"height":[4,3,2,1,4]}','16',FALSE,NULL,3),
  ('d1000000-0000-0000-0000-000000000053','c1000000-0000-0000-0000-000000000011','{"height":[1,2,1]}','2',FALSE,NULL,4);

INSERT INTO problem_templates (id, problem_id, language_id, starter_code, solution_code) VALUES
('e1000000-0000-0000-0000-000000000051','c1000000-0000-0000-0000-000000000011','a1000000-0000-0000-0000-000000000001',
$$from typing import List
class Solution:
    def maxArea(self, height: List[int]) -> int:
        pass$$,
$$class Solution:
    def maxArea(self, height):
        l, r, res = 0, len(height)-1, 0
        while l < r:
            res = max(res, min(height[l],height[r])*(r-l))
            if height[l] < height[r]: l += 1
            else: r -= 1
        return res$$),
('e1000000-0000-0000-0000-000000000052','c1000000-0000-0000-0000-000000000011','a1000000-0000-0000-0000-000000000002',
$$#include <vector>
#include <algorithm>
using namespace std;
class Solution {
public:
    int maxArea(vector<int>& height) {
        // Write your solution here
        return 0;
    }
};$$,
$$class Solution {
public:
    int maxArea(vector<int>& h) {
        int l=0,r=(int)h.size()-1,res=0;
        while(l<r){res=max(res,min(h[l],h[r])*(r-l));if(h[l]<h[r])l++;else r--;}
        return res;
    }
};$$),
('e1000000-0000-0000-0000-000000000053','c1000000-0000-0000-0000-000000000011','a1000000-0000-0000-0000-000000000003',
$$var maxArea = function(height) {
    // Write your solution here
};$$,
$$var maxArea = function(height) {
    let l=0,r=height.length-1,res=0;
    while(l<r){res=Math.max(res,Math.min(height[l],height[r])*(r-l));if(height[l]<height[r])l++;else r--;}
    return res;
};$$),
('e1000000-0000-0000-0000-000000000054','c1000000-0000-0000-0000-000000000011','a1000000-0000-0000-0000-000000000004',
$$class Solution {
    public int maxArea(int[] height) {
        // Write your solution here
        return 0;
    }
}$$,
$$class Solution {
    public int maxArea(int[] h) {
        int l=0,r=h.length-1,res=0;
        while(l<r){res=Math.max(res,Math.min(h[l],h[r])*(r-l));if(h[l]<h[r])l++;else r--;}
        return res;
    }
}$$),
('e1000000-0000-0000-0000-000000000055','c1000000-0000-0000-0000-000000000011','a1000000-0000-0000-0000-000000000005',
$$int maxArea(int* height, int heightSize) {
    // Write your solution here
    return 0;
}$$,
$$#define MIN(a,b) ((a)<(b)?(a):(b))
#define MAX(a,b) ((a)>(b)?(a):(b))
int maxArea(int* h, int n) {
    int l=0,r=n-1,res=0;
    while(l<r){res=MAX(res,MIN(h[l],h[r])*(r-l));if(h[l]<h[r])l++;else r--;}
    return res;
}$$);


-- =============================================================
--  PROBLEM 12 — Product of Array Except Self  [MEDIUM]
-- =============================================================
INSERT INTO problems (
  id, title, slug, difficulty, is_published,
  time_limit_ms, memory_limit_kb, total_submissions, total_accepted, description
) VALUES (
  'c1000000-0000-0000-0000-000000000012',
  'Product of Array Except Self', 'product-of-array-except-self', 'medium', TRUE,
  2000, 262144, 3901234, 2456789,
$$
## Problem

Given an integer array `nums`, return an array `answer` such that `answer[i]` is equal to the product of all the elements of `nums` except `nums[i]`.

The product of any prefix or suffix of `nums` is **guaranteed** to fit in a 32-bit integer.

You must write an algorithm that runs in **O(n)** time and without using the division operation.

---

## Examples

**Example 1:**
```
Input:  nums = [1,2,3,4]
Output: [24,12,8,6]
```

**Example 2:**
```
Input:  nums = [-1,1,0,-3,3]
Output: [0,0,9,0,0]
```

---

## Constraints

- `2 <= nums.length <= 10^5`
- `-30 <= nums[i] <= 30`

---

## Follow-up

Can you solve it with **O(1)** extra space (output array excluded)?
$$);

INSERT INTO problem_tags (problem_id, tag_id) VALUES
  ('c1000000-0000-0000-0000-000000000012', 'b1000000-0000-0000-0000-000000000001'),
  ('c1000000-0000-0000-0000-000000000012', 'b1000000-0000-0000-0000-000000000010');

INSERT INTO test_cases (id, problem_id, input, expected_output, is_sample, explanation, order_index) VALUES
  ('d1000000-0000-0000-0000-000000000054','c1000000-0000-0000-0000-000000000012','{"nums":[1,2,3,4]}','[24,12,8,6]',TRUE,'Products excluding each element',1),
  ('d1000000-0000-0000-0000-000000000055','c1000000-0000-0000-0000-000000000012','{"nums":[-1,1,0,-3,3]}','[0,0,9,0,0]',TRUE,'Zero element makes most products 0',2),
  ('d1000000-0000-0000-0000-000000000056','c1000000-0000-0000-0000-000000000012','{"nums":[2,3]}','[3,2]',FALSE,NULL,3),
  ('d1000000-0000-0000-0000-000000000057','c1000000-0000-0000-0000-000000000012','{"nums":[0,0]}','[0,0]',FALSE,NULL,4);

INSERT INTO problem_templates (id, problem_id, language_id, starter_code, solution_code) VALUES
('e1000000-0000-0000-0000-000000000056','c1000000-0000-0000-0000-000000000012','a1000000-0000-0000-0000-000000000001',
$$from typing import List
class Solution:
    def productExceptSelf(self, nums: List[int]) -> List[int]:
        pass$$,
$$class Solution:
    def productExceptSelf(self, nums):
        n=len(nums); res=[1]*n
        prefix=1
        for i in range(n): res[i]=prefix; prefix*=nums[i]
        suffix=1
        for i in range(n-1,-1,-1): res[i]*=suffix; suffix*=nums[i]
        return res$$),
('e1000000-0000-0000-0000-000000000057','c1000000-0000-0000-0000-000000000012','a1000000-0000-0000-0000-000000000002',
$$#include <vector>
using namespace std;
class Solution {
public:
    vector<int> productExceptSelf(vector<int>& nums) {
        // Write your solution here
        return {};
    }
};$$,
$$class Solution {
public:
    vector<int> productExceptSelf(vector<int>& nums) {
        int n=nums.size(); vector<int> res(n,1);
        int pre=1; for(int i=0;i<n;i++){res[i]=pre;pre*=nums[i];}
        int suf=1; for(int i=n-1;i>=0;i--){res[i]*=suf;suf*=nums[i];}
        return res;
    }
};$$),
('e1000000-0000-0000-0000-000000000058','c1000000-0000-0000-0000-000000000012','a1000000-0000-0000-0000-000000000003',
$$var productExceptSelf = function(nums) {
    // Write your solution here
};$$,
$$var productExceptSelf = function(nums) {
    const n=nums.length, res=new Array(n).fill(1);
    let pre=1; for(let i=0;i<n;i++){res[i]=pre;pre*=nums[i];}
    let suf=1; for(let i=n-1;i>=0;i--){res[i]*=suf;suf*=nums[i];}
    return res;
};$$),
('e1000000-0000-0000-0000-000000000059','c1000000-0000-0000-0000-000000000012','a1000000-0000-0000-0000-000000000004',
$$class Solution {
    public int[] productExceptSelf(int[] nums) {
        // Write your solution here
        return new int[]{};
    }
}$$,
$$class Solution {
    public int[] productExceptSelf(int[] nums) {
        int n=nums.length; int[] res=new int[n]; res[0]=1;
        for(int i=1;i<n;i++) res[i]=res[i-1]*nums[i-1];
        int suf=1; for(int i=n-1;i>=0;i--){res[i]*=suf;suf*=nums[i];}
        return res;
    }
}$$),
('e1000000-0000-0000-0000-000000000060','c1000000-0000-0000-0000-000000000012','a1000000-0000-0000-0000-000000000005',
$$#include <stdlib.h>
int* productExceptSelf(int* nums, int numsSize, int* returnSize) {
    // Write your solution here
    *returnSize = numsSize; return NULL;
}$$,
$$int* productExceptSelf(int* nums, int n, int* returnSize) {
    *returnSize=n; int* res=(int*)malloc(n*sizeof(int));
    res[0]=1; for(int i=1;i<n;i++) res[i]=res[i-1]*nums[i-1];
    int suf=1; for(int i=n-1;i>=0;i--){res[i]*=suf;suf*=nums[i];}
    return res;
}$$);


-- =============================================================
--  PROBLEM 13 — Find Minimum in Rotated Sorted Array  [MEDIUM]
-- =============================================================
INSERT INTO problems (
  id, title, slug, difficulty, is_published,
  time_limit_ms, memory_limit_kb, total_submissions, total_accepted, description
) VALUES (
  'c1000000-0000-0000-0000-000000000013',
  'Find Minimum in Rotated Sorted Array', 'find-minimum-in-rotated-sorted-array', 'medium', TRUE,
  2000, 262144, 3456789, 1987654,
$$
## Problem

Suppose an array of length `n` sorted in ascending order is **rotated** between 1 and `n` times. Given the sorted rotated array `nums` of **unique** elements, return the **minimum** element of this array.

You must write an algorithm that runs in **O(log n)** time.

---

## Examples

**Example 1:**
```
Input:  nums = [3,4,5,1,2]
Output: 1
```

**Example 2:**
```
Input:  nums = [4,5,6,7,0,1,2]
Output: 0
```

**Example 3:**
```
Input:  nums = [11,13,15,17]
Output: 11
```

---

## Constraints

- `n == nums.length`
- `1 <= n <= 5000`
- `-5000 <= nums[i] <= 5000`
- All integers in `nums` are **unique**.
$$);

INSERT INTO problem_tags (problem_id, tag_id) VALUES
  ('c1000000-0000-0000-0000-000000000013', 'b1000000-0000-0000-0000-000000000001'),
  ('c1000000-0000-0000-0000-000000000013', 'b1000000-0000-0000-0000-000000000007');

INSERT INTO test_cases (id, problem_id, input, expected_output, is_sample, explanation, order_index) VALUES
  ('d1000000-0000-0000-0000-000000000058','c1000000-0000-0000-0000-000000000013','{"nums":[3,4,5,1,2]}','1',TRUE,'Rotated at index 3',1),
  ('d1000000-0000-0000-0000-000000000059','c1000000-0000-0000-0000-000000000013','{"nums":[4,5,6,7,0,1,2]}','0',TRUE,'Minimum is 0',2),
  ('d1000000-0000-0000-0000-000000000060','c1000000-0000-0000-0000-000000000013','{"nums":[11,13,15,17]}','11',TRUE,'Not rotated',3),
  ('d1000000-0000-0000-0000-000000000061','c1000000-0000-0000-0000-000000000013','{"nums":[1]}','1',FALSE,NULL,4),
  ('d1000000-0000-0000-0000-000000000062','c1000000-0000-0000-0000-000000000013','{"nums":[2,1]}','1',FALSE,NULL,5);

INSERT INTO problem_templates (id, problem_id, language_id, starter_code, solution_code) VALUES
('e1000000-0000-0000-0000-000000000061','c1000000-0000-0000-0000-000000000013','a1000000-0000-0000-0000-000000000001',
$$from typing import List
class Solution:
    def findMin(self, nums: List[int]) -> int:
        pass$$,
$$class Solution:
    def findMin(self, nums):
        lo, hi = 0, len(nums)-1
        while lo < hi:
            mid = (lo+hi)//2
            if nums[mid] > nums[hi]: lo = mid+1
            else: hi = mid
        return nums[lo]$$),
('e1000000-0000-0000-0000-000000000062','c1000000-0000-0000-0000-000000000013','a1000000-0000-0000-0000-000000000002',
$$#include <vector>
using namespace std;
class Solution {
public:
    int findMin(vector<int>& nums) {
        // Write your solution here
        return 0;
    }
};$$,
$$class Solution {
public:
    int findMin(vector<int>& nums) {
        int lo=0,hi=(int)nums.size()-1;
        while(lo<hi){int m=(lo+hi)/2;if(nums[m]>nums[hi])lo=m+1;else hi=m;}
        return nums[lo];
    }
};$$),
('e1000000-0000-0000-0000-000000000063','c1000000-0000-0000-0000-000000000013','a1000000-0000-0000-0000-000000000003',
$$var findMin = function(nums) {
    // Write your solution here
};$$,
$$var findMin = function(nums) {
    let lo=0,hi=nums.length-1;
    while(lo<hi){const m=(lo+hi)>>1;if(nums[m]>nums[hi])lo=m+1;else hi=m;}
    return nums[lo];
};$$),
('e1000000-0000-0000-0000-000000000064','c1000000-0000-0000-0000-000000000013','a1000000-0000-0000-0000-000000000004',
$$class Solution {
    public int findMin(int[] nums) {
        // Write your solution here
        return 0;
    }
}$$,
$$class Solution {
    public int findMin(int[] nums) {
        int lo=0,hi=nums.length-1;
        while(lo<hi){int m=(lo+hi)/2;if(nums[m]>nums[hi])lo=m+1;else hi=m;}
        return nums[lo];
    }
}$$),
('e1000000-0000-0000-0000-000000000065','c1000000-0000-0000-0000-000000000013','a1000000-0000-0000-0000-000000000005',
$$int findMin(int* nums, int numsSize) {
    // Write your solution here
    return 0;
}$$,
$$int findMin(int* nums, int n) {
    int lo=0,hi=n-1;
    while(lo<hi){int m=(lo+hi)/2;if(nums[m]>nums[hi])lo=m+1;else hi=m;}
    return nums[lo];
}$$);


-- =============================================================
--  PROBLEM 14 — Coin Change  [MEDIUM]
-- =============================================================
INSERT INTO problems (
  id, title, slug, difficulty, is_published,
  time_limit_ms, memory_limit_kb, total_submissions, total_accepted, description
) VALUES (
  'c1000000-0000-0000-0000-000000000014',
  'Coin Change', 'coin-change', 'medium', TRUE,
  2000, 262144, 4234567, 1678901,
$$
## Problem

You are given an integer array `coins` representing coins of different denominations and an integer `amount` representing a total amount of money.

Return the **fewest number of coins** that you need to make up that amount. If that amount of money cannot be made up by any combination of the coins, return `-1`.

You may assume that you have an **infinite** number of each kind of coin.

---

## Examples

**Example 1:**
```
Input:  coins = [1,5,10,25], amount = 36
Output: 3
Explanation: 25 + 10 + 1 = 36 → 3 coins
```

**Example 2:**
```
Input:  coins = [2], amount = 3
Output: -1
```

**Example 3:**
```
Input:  coins = [1], amount = 0
Output: 0
```

---

## Constraints

- `1 <= coins.length <= 12`
- `1 <= coins[i] <= 2^31 - 1`
- `0 <= amount <= 10^4`
$$);

INSERT INTO problem_tags (problem_id, tag_id) VALUES
  ('c1000000-0000-0000-0000-000000000014', 'b1000000-0000-0000-0000-000000000001'),
  ('c1000000-0000-0000-0000-000000000014', 'b1000000-0000-0000-0000-000000000010');

INSERT INTO test_cases (id, problem_id, input, expected_output, is_sample, explanation, order_index) VALUES
  ('d1000000-0000-0000-0000-000000000063','c1000000-0000-0000-0000-000000000014','{"coins":[1,5,10,25],"amount":36}','3',TRUE,'25+10+1',1),
  ('d1000000-0000-0000-0000-000000000064','c1000000-0000-0000-0000-000000000014','{"coins":[2],"amount":3}','-1',TRUE,'Cannot make odd amount',2),
  ('d1000000-0000-0000-0000-000000000065','c1000000-0000-0000-0000-000000000014','{"coins":[1],"amount":0}','0',TRUE,'Zero amount needs zero coins',3),
  ('d1000000-0000-0000-0000-000000000066','c1000000-0000-0000-0000-000000000014','{"coins":[1,2,5],"amount":11}','3',FALSE,NULL,4),
  ('d1000000-0000-0000-0000-000000000067','c1000000-0000-0000-0000-000000000014','{"coins":[186,419,83,408],"amount":6249}','20',FALSE,NULL,5);

INSERT INTO problem_templates (id, problem_id, language_id, starter_code, solution_code) VALUES
('e1000000-0000-0000-0000-000000000066','c1000000-0000-0000-0000-000000000014','a1000000-0000-0000-0000-000000000001',
$$from typing import List
class Solution:
    def coinChange(self, coins: List[int], amount: int) -> int:
        pass$$,
$$class Solution:
    def coinChange(self, coins, amount):
        dp=[float('inf')]*(amount+1); dp[0]=0
        for i in range(1,amount+1):
            for c in coins:
                if c<=i: dp[i]=min(dp[i],dp[i-c]+1)
        return dp[amount] if dp[amount]!=float('inf') else -1$$),
('e1000000-0000-0000-0000-000000000067','c1000000-0000-0000-0000-000000000014','a1000000-0000-0000-0000-000000000002',
$$#include <vector>
using namespace std;
class Solution {
public:
    int coinChange(vector<int>& coins, int amount) {
        // Write your solution here
        return 0;
    }
};$$,
$$class Solution {
public:
    int coinChange(vector<int>& coins, int amount) {
        vector<int> dp(amount+1,amount+1); dp[0]=0;
        for(int i=1;i<=amount;i++)
            for(int c:coins) if(c<=i) dp[i]=min(dp[i],dp[i-c]+1);
        return dp[amount]>amount?-1:dp[amount];
    }
};$$),
('e1000000-0000-0000-0000-000000000068','c1000000-0000-0000-0000-000000000014','a1000000-0000-0000-0000-000000000003',
$$var coinChange = function(coins, amount) {
    // Write your solution here
};$$,
$$var coinChange = function(coins, amount) {
    const dp=new Array(amount+1).fill(Infinity); dp[0]=0;
    for(let i=1;i<=amount;i++)
        for(const c of coins) if(c<=i) dp[i]=Math.min(dp[i],dp[i-c]+1);
    return dp[amount]===Infinity?-1:dp[amount];
};$$),
('e1000000-0000-0000-0000-000000000069','c1000000-0000-0000-0000-000000000014','a1000000-0000-0000-0000-000000000004',
$$class Solution {
    public int coinChange(int[] coins, int amount) {
        // Write your solution here
        return 0;
    }
}$$,
$$class Solution {
    public int coinChange(int[] coins, int amount) {
        int[] dp=new int[amount+1]; java.util.Arrays.fill(dp,amount+1); dp[0]=0;
        for(int i=1;i<=amount;i++)
            for(int c:coins) if(c<=i) dp[i]=Math.min(dp[i],dp[i-c]+1);
        return dp[amount]>amount?-1:dp[amount];
    }
}$$),
('e1000000-0000-0000-0000-000000000070','c1000000-0000-0000-0000-000000000014','a1000000-0000-0000-0000-000000000005',
$$int coinChange(int* coins, int coinsSize, int amount) {
    // Write your solution here
    return 0;
}$$,
$$#include <stdlib.h>
int coinChange(int* coins, int coinsSize, int amount) {
    int* dp=(int*)malloc((amount+1)*sizeof(int));
    for(int i=0;i<=amount;i++) dp[i]=amount+1; dp[0]=0;
    for(int i=1;i<=amount;i++)
        for(int j=0;j<coinsSize;j++)
            if(coins[j]<=i && dp[i-coins[j]]+1<dp[i]) dp[i]=dp[i-coins[j]]+1;
    int res=dp[amount]>amount?-1:dp[amount]; free(dp); return res;
}$$);


-- =============================================================
--  PROBLEM 15 — Number of Islands  [MEDIUM]
-- =============================================================
INSERT INTO problems (
  id, title, slug, difficulty, is_published,
  time_limit_ms, memory_limit_kb, total_submissions, total_accepted, description
) VALUES (
  'c1000000-0000-0000-0000-000000000015',
  'Number of Islands', 'number-of-islands', 'medium', TRUE,
  2000, 262144, 3901234, 2012345,
$$
## Problem

Given an `m x n` 2D binary grid which represents a map of `'1'`s (land) and `'0'`s (water), return the **number of islands**.

An **island** is surrounded by water and is formed by connecting adjacent lands horizontally or vertically. You may assume all four edges of the grid are all surrounded by water.

---

## Examples

**Example 1:**
```
Input:
grid = [
  ["1","1","1","1","0"],
  ["1","1","0","1","0"],
  ["1","1","0","0","0"],
  ["0","0","0","0","0"]
]
Output: 1
```

**Example 2:**
```
Input:
grid = [
  ["1","1","0","0","0"],
  ["1","1","0","0","0"],
  ["0","0","1","0","0"],
  ["0","0","0","1","1"]
]
Output: 3
```

---

## Constraints

- `m == grid.length`
- `n == grid[i].length`
- `1 <= m, n <= 300`
- `grid[i][j]` is `'0'` or `'1'`.
$$);

INSERT INTO problem_tags (problem_id, tag_id) VALUES
  ('c1000000-0000-0000-0000-000000000015', 'b1000000-0000-0000-0000-000000000001'),
  ('c1000000-0000-0000-0000-000000000015', 'b1000000-0000-0000-0000-000000000014'),
  ('c1000000-0000-0000-0000-000000000015', 'b1000000-0000-0000-0000-000000000018');

INSERT INTO test_cases (id, problem_id, input, expected_output, is_sample, explanation, order_index) VALUES
  ('d1000000-0000-0000-0000-000000000068','c1000000-0000-0000-0000-000000000015','{"grid":[["1","1","1","1","0"],["1","1","0","1","0"],["1","1","0","0","0"],["0","0","0","0","0"]]}','1',TRUE,'One large island',1),
  ('d1000000-0000-0000-0000-000000000069','c1000000-0000-0000-0000-000000000015','{"grid":[["1","1","0","0","0"],["1","1","0","0","0"],["0","0","1","0","0"],["0","0","0","1","1"]]}','3',TRUE,'Three separate islands',2),
  ('d1000000-0000-0000-0000-000000000070','c1000000-0000-0000-0000-000000000015','{"grid":[["1"]]}','1',FALSE,NULL,3),
  ('d1000000-0000-0000-0000-000000000071','c1000000-0000-0000-0000-000000000015','{"grid":[["0"]]}','0',FALSE,NULL,4);

INSERT INTO problem_templates (id, problem_id, language_id, starter_code, solution_code) VALUES
('e1000000-0000-0000-0000-000000000071','c1000000-0000-0000-0000-000000000015','a1000000-0000-0000-0000-000000000001',
$$from typing import List
class Solution:
    def numIslands(self, grid: List[List[str]]) -> int:
        pass$$,
$$class Solution:
    def numIslands(self, grid):
        def dfs(r,c):
            if r<0 or c<0 or r>=len(grid) or c>=len(grid[0]) or grid[r][c]!='1': return
            grid[r][c]='0'
            for dr,dc in [(1,0),(-1,0),(0,1),(0,-1)]: dfs(r+dr,c+dc)
        count=0
        for r in range(len(grid)):
            for c in range(len(grid[0])):
                if grid[r][c]=='1': dfs(r,c); count+=1
        return count$$),
('e1000000-0000-0000-0000-000000000072','c1000000-0000-0000-0000-000000000015','a1000000-0000-0000-0000-000000000002',
$$#include <vector>
#include <string>
using namespace std;
class Solution {
public:
    int numIslands(vector<vector<char>>& grid) {
        // Write your solution here
        return 0;
    }
};$$,
$$class Solution {
    void dfs(vector<vector<char>>& g, int r, int c) {
        if(r<0||c<0||r>=(int)g.size()||c>=(int)g[0].size()||g[r][c]!='1') return;
        g[r][c]='0';
        dfs(g,r+1,c);dfs(g,r-1,c);dfs(g,r,c+1);dfs(g,r,c-1);
    }
public:
    int numIslands(vector<vector<char>>& grid) {
        int count=0;
        for(int r=0;r<(int)grid.size();r++)
            for(int c=0;c<(int)grid[0].size();c++)
                if(grid[r][c]=='1'){dfs(grid,r,c);count++;}
        return count;
    }
};$$),
('e1000000-0000-0000-0000-000000000073','c1000000-0000-0000-0000-000000000015','a1000000-0000-0000-0000-000000000003',
$$var numIslands = function(grid) {
    // Write your solution here
};$$,
$$var numIslands = function(grid) {
    const dfs=(r,c)=>{
        if(r<0||c<0||r>=grid.length||c>=grid[0].length||grid[r][c]!=='1') return;
        grid[r][c]='0'; dfs(r+1,c);dfs(r-1,c);dfs(r,c+1);dfs(r,c-1);
    };
    let count=0;
    for(let r=0;r<grid.length;r++)
        for(let c=0;c<grid[0].length;c++)
            if(grid[r][c]==='1'){dfs(r,c);count++;}
    return count;
};$$),
('e1000000-0000-0000-0000-000000000074','c1000000-0000-0000-0000-000000000015','a1000000-0000-0000-0000-000000000004',
$$class Solution {
    public int numIslands(char[][] grid) {
        // Write your solution here
        return 0;
    }
}$$,
$$class Solution {
    void dfs(char[][] g,int r,int c){
        if(r<0||c<0||r>=g.length||c>=g[0].length||g[r][c]!='1') return;
        g[r][c]='0'; dfs(g,r+1,c);dfs(g,r-1,c);dfs(g,r,c+1);dfs(g,r,c-1);
    }
    public int numIslands(char[][] grid) {
        int count=0;
        for(int r=0;r<grid.length;r++)
            for(int c=0;c<grid[0].length;c++)
                if(grid[r][c]=='1'){dfs(grid,r,c);count++;}
        return count;
    }
}$$),
('e1000000-0000-0000-0000-000000000075','c1000000-0000-0000-0000-000000000015','a1000000-0000-0000-0000-000000000005',
$$int numIslands(char** grid, int gridSize, int* gridColSize) {
    // Write your solution here
    return 0;
}$$,
$$void dfs(char** g,int r,int c,int rows,int cols){
    if(r<0||c<0||r>=rows||c>=cols||g[r][c]!='1') return;
    g[r][c]='0'; dfs(g,r+1,c,rows,cols);dfs(g,r-1,c,rows,cols);
    dfs(g,r,c+1,rows,cols);dfs(g,r,c-1,rows,cols);
}
int numIslands(char** grid, int gridSize, int* gridColSize) {
    int count=0,cols=gridColSize[0];
    for(int r=0;r<gridSize;r++)
        for(int c=0;c<cols;c++)
            if(grid[r][c]=='1'){dfs(grid,r,c,gridSize,cols);count++;}
    return count;
}$$);


-- =============================================================
--  PROBLEM 16 — Median of Two Sorted Arrays  [HARD]
-- =============================================================
INSERT INTO problems (
  id, title, slug, difficulty, is_published,
  time_limit_ms, memory_limit_kb, total_submissions, total_accepted, description
) VALUES (
  'c1000000-0000-0000-0000-000000000016',
  'Median of Two Sorted Arrays', 'median-of-two-sorted-arrays', 'hard', TRUE,
  2000, 262144, 4123089, 1189023,
$$
## Problem

Given two sorted arrays `nums1` and `nums2` of size `m` and `n`, return the **median** of the two sorted arrays.

The overall run time complexity should be **O(log(m + n))**.

---

## Examples

**Example 1:**
```
Input:  nums1 = [1,3], nums2 = [2]
Output: 2.00000
```

**Example 2:**
```
Input:  nums1 = [1,2], nums2 = [3,4]
Output: 2.50000
```

---

## Constraints

- `0 <= m, n <= 1000`
- `1 <= m + n <= 2000`
- `-10^6 <= nums1[i], nums2[i] <= 10^6`

---

## Key Insight

Binary search the **partition point** of the smaller array. A valid partition satisfies:
```
maxLeft1 <= minRight2  AND  maxLeft2 <= minRight1
```
$$);

INSERT INTO problem_tags (problem_id, tag_id) VALUES
  ('c1000000-0000-0000-0000-000000000016', 'b1000000-0000-0000-0000-000000000001'),
  ('c1000000-0000-0000-0000-000000000016', 'b1000000-0000-0000-0000-000000000007'),
  ('c1000000-0000-0000-0000-000000000016', 'b1000000-0000-0000-0000-000000000008');

INSERT INTO test_cases (id, problem_id, input, expected_output, is_sample, explanation, order_index) VALUES
  ('d1000000-0000-0000-0000-000000000072','c1000000-0000-0000-0000-000000000016','{"nums1":[1,3],"nums2":[2]}','2.00000',TRUE,'Median of [1,2,3]',1),
  ('d1000000-0000-0000-0000-000000000073','c1000000-0000-0000-0000-000000000016','{"nums1":[1,2],"nums2":[3,4]}','2.50000',TRUE,'Median of [1,2,3,4] = (2+3)/2',2),
  ('d1000000-0000-0000-0000-000000000074','c1000000-0000-0000-0000-000000000016','{"nums1":[0,0],"nums2":[0,0]}','0.00000',FALSE,NULL,3),
  ('d1000000-0000-0000-0000-000000000075','c1000000-0000-0000-0000-000000000016','{"nums1":[],"nums2":[1]}','1.00000',FALSE,NULL,4),
  ('d1000000-0000-0000-0000-000000000076','c1000000-0000-0000-0000-000000000016','{"nums1":[1,2,3,4,5],"nums2":[6,7,8,9,10]}','5.50000',FALSE,NULL,5);

INSERT INTO problem_templates (id, problem_id, language_id, starter_code, solution_code) VALUES
('e1000000-0000-0000-0000-000000000076','c1000000-0000-0000-0000-000000000016','a1000000-0000-0000-0000-000000000001',
$$from typing import List
class Solution:
    def findMedianSortedArrays(self, nums1: List[int], nums2: List[int]) -> float:
        pass$$,
$$class Solution:
    def findMedianSortedArrays(self, nums1, nums2):
        if len(nums1) > len(nums2): nums1, nums2 = nums2, nums1
        m, n = len(nums1), len(nums2); lo, hi = 0, m
        while lo <= hi:
            px=(lo+hi)//2; py=(m+n+1)//2-px
            maxL1=nums1[px-1] if px>0 else float('-inf')
            minR1=nums1[px]   if px<m else float('inf')
            maxL2=nums2[py-1] if py>0 else float('-inf')
            minR2=nums2[py]   if py<n else float('inf')
            if maxL1<=minR2 and maxL2<=minR1:
                if (m+n)%2: return float(max(maxL1,maxL2))
                return (max(maxL1,maxL2)+min(minR1,minR2))/2.0
            elif maxL1>minR2: hi=px-1
            else: lo=px+1$$),
('e1000000-0000-0000-0000-000000000077','c1000000-0000-0000-0000-000000000016','a1000000-0000-0000-0000-000000000002',
$$#include <vector>
#include <climits>
using namespace std;
class Solution {
public:
    double findMedianSortedArrays(vector<int>& nums1, vector<int>& nums2) {
        // Write your solution here
        return 0.0;
    }
};$$,
$$class Solution {
public:
    double findMedianSortedArrays(vector<int>& A, vector<int>& B) {
        if(A.size()>B.size()) swap(A,B);
        int m=A.size(),n=B.size(),lo=0,hi=m;
        while(lo<=hi){
            int px=(lo+hi)/2,py=(m+n+1)/2-px;
            int maxL1=px>0?A[px-1]:INT_MIN, minR1=px<m?A[px]:INT_MAX;
            int maxL2=py>0?B[py-1]:INT_MIN, minR2=py<n?B[py]:INT_MAX;
            if(maxL1<=minR2 && maxL2<=minR1){
                if((m+n)%2) return max(maxL1,maxL2);
                return(max(maxL1,maxL2)+min(minR1,minR2))/2.0;
            } else if(maxL1>minR2) hi=px-1; else lo=px+1;
        }
        return 0.0;
    }
};$$),
('e1000000-0000-0000-0000-000000000078','c1000000-0000-0000-0000-000000000016','a1000000-0000-0000-0000-000000000003',
$$var findMedianSortedArrays = function(nums1, nums2) {
    // Write your solution here
};$$,
$$var findMedianSortedArrays = function(nums1, nums2) {
    if(nums1.length>nums2.length)[nums1,nums2]=[nums2,nums1];
    const m=nums1.length,n=nums2.length;
    let lo=0,hi=m;
    while(lo<=hi){
        const px=(lo+hi)>>1,py=(m+n+1)/2-px|0;
        const maxL1=px>0?nums1[px-1]:-Infinity, minR1=px<m?nums1[px]:Infinity;
        const maxL2=py>0?nums2[py-1]:-Infinity, minR2=py<n?nums2[py]:Infinity;
        if(maxL1<=minR2 && maxL2<=minR1){
            if((m+n)%2) return Math.max(maxL1,maxL2);
            return(Math.max(maxL1,maxL2)+Math.min(minR1,minR2))/2;
        } else if(maxL1>minR2) hi=px-1; else lo=px+1;
    }
};$$),
('e1000000-0000-0000-0000-000000000079','c1000000-0000-0000-0000-000000000016','a1000000-0000-0000-0000-000000000004',
$$class Solution {
    public double findMedianSortedArrays(int[] nums1, int[] nums2) {
        // Write your solution here
        return 0.0;
    }
}$$,
$$class Solution {
    public double findMedianSortedArrays(int[] A, int[] B) {
        if(A.length>B.length){int[] t=A;A=B;B=t;}
        int m=A.length,n=B.length,lo=0,hi=m;
        while(lo<=hi){
            int px=(lo+hi)/2,py=(m+n+1)/2-px;
            int maxL1=px>0?A[px-1]:Integer.MIN_VALUE, minR1=px<m?A[px]:Integer.MAX_VALUE;
            int maxL2=py>0?B[py-1]:Integer.MIN_VALUE, minR2=py<n?B[py]:Integer.MAX_VALUE;
            if(maxL1<=minR2 && maxL2<=minR1){
                if((m+n)%2==1) return Math.max(maxL1,maxL2);
                return(Math.max(maxL1,maxL2)+(long)Math.min(minR1,minR2))/2.0;
            } else if(maxL1>minR2) hi=px-1; else lo=px+1;
        }
        return 0.0;
    }
}$$),
('e1000000-0000-0000-0000-000000000080','c1000000-0000-0000-0000-000000000016','a1000000-0000-0000-0000-000000000005',
$$#include <limits.h>
double findMedianSortedArrays(int* nums1, int m, int* nums2, int n) {
    // Write your solution here
    return 0.0;
}$$,
$$#include <limits.h>
double findMedianSortedArrays(int* A, int m, int* B, int n) {
    if(m>n){int*t=A;A=B;B=t;int tmp=m;m=n;n=tmp;}
    int lo=0,hi=m;
    while(lo<=hi){
        int px=(lo+hi)/2,py=(m+n+1)/2-px;
        int maxL1=px>0?A[px-1]:INT_MIN, minR1=px<m?A[px]:INT_MAX;
        int maxL2=py>0?B[py-1]:INT_MIN, minR2=py<n?B[py]:INT_MAX;
        if(maxL1<=minR2 && maxL2<=minR1){
            int L=maxL1>maxL2?maxL1:maxL2;
            int R=minR1<minR2?minR1:minR2;
            if((m+n)%2) return (double)L;
            return(L+R)/2.0;
        } else if(maxL1>minR2) hi=px-1; else lo=px+1;
    }
    return 0.0;
}$$);


-- =============================================================
--  PROBLEM 17 — Trapping Rain Water  [HARD]
-- =============================================================
INSERT INTO problems (
  id, title, slug, difficulty, is_published,
  time_limit_ms, memory_limit_kb, total_submissions, total_accepted, description
) VALUES (
  'c1000000-0000-0000-0000-000000000017',
  'Trapping Rain Water', 'trapping-rain-water', 'hard', TRUE,
  2000, 262144, 3801234, 1723456,
$$
## Problem

Given `n` non-negative integers representing an elevation map where the width of each bar is `1`, compute how much water it can trap after raining.

---

## Examples

**Example 1:**
```
Input:  height = [0,1,0,2,1,0,1,3,2,1,2,1]
Output: 6
```

**Example 2:**
```
Input:  height = [4,2,0,3,2,5]
Output: 9
```

---

## Constraints

- `1 <= n <= 2 * 10^4`
- `0 <= height[i] <= 10^5`

---

## Approaches

| Approach | Time | Space |
|---|---|---|
| Two Pointers *(optimal)* | O(n) | O(1) |
| Precompute prefix/suffix max | O(n) | O(n) |
| Monotonic Stack | O(n) | O(n) |
$$);

INSERT INTO problem_tags (problem_id, tag_id) VALUES
  ('c1000000-0000-0000-0000-000000000017', 'b1000000-0000-0000-0000-000000000001'),
  ('c1000000-0000-0000-0000-000000000017', 'b1000000-0000-0000-0000-000000000006'),
  ('c1000000-0000-0000-0000-000000000017', 'b1000000-0000-0000-0000-000000000009'),
  ('c1000000-0000-0000-0000-000000000017', 'b1000000-0000-0000-0000-000000000010');

INSERT INTO test_cases (id, problem_id, input, expected_output, is_sample, explanation, order_index) VALUES
  ('d1000000-0000-0000-0000-000000000077','c1000000-0000-0000-0000-000000000017','{"height":[0,1,0,2,1,0,1,3,2,1,2,1]}','6',TRUE,'6 units of rain water trapped',1),
  ('d1000000-0000-0000-0000-000000000078','c1000000-0000-0000-0000-000000000017','{"height":[4,2,0,3,2,5]}','9',TRUE,'9 units trapped',2),
  ('d1000000-0000-0000-0000-000000000079','c1000000-0000-0000-0000-000000000017','{"height":[3,0,0,0,3]}','9',FALSE,NULL,3),
  ('d1000000-0000-0000-0000-000000000080','c1000000-0000-0000-0000-000000000017','{"height":[1,2,3,4,5]}','0',FALSE,NULL,4),
  ('d1000000-0000-0000-0000-000000000081','c1000000-0000-0000-0000-000000000017','{"height":[5,2,1,2,1,5]}','14',FALSE,NULL,5);

INSERT INTO problem_templates (id, problem_id, language_id, starter_code, solution_code) VALUES
('e1000000-0000-0000-0000-000000000081','c1000000-0000-0000-0000-000000000017','a1000000-0000-0000-0000-000000000001',
$$from typing import List
class Solution:
    def trap(self, height: List[int]) -> int:
        pass$$,
$$class Solution:
    def trap(self, height):
        l,r=0,len(height)-1; maxL=maxR=water=0
        while l<r:
            if height[l]<height[r]:
                if height[l]>=maxL: maxL=height[l]
                else: water+=maxL-height[l]
                l+=1
            else:
                if height[r]>=maxR: maxR=height[r]
                else: water+=maxR-height[r]
                r-=1
        return water$$),
('e1000000-0000-0000-0000-000000000082','c1000000-0000-0000-0000-000000000017','a1000000-0000-0000-0000-000000000002',
$$#include <vector>
using namespace std;
class Solution {
public:
    int trap(vector<int>& height) {
        // Write your solution here
        return 0;
    }
};$$,
$$class Solution {
public:
    int trap(vector<int>& h) {
        int l=0,r=(int)h.size()-1,maxL=0,maxR=0,water=0;
        while(l<r){
            if(h[l]<h[r]){h[l]>=maxL?maxL=h[l]:water+=maxL-h[l];l++;}
            else{h[r]>=maxR?maxR=h[r]:water+=maxR-h[r];r--;}
        }
        return water;
    }
};$$),
('e1000000-0000-0000-0000-000000000083','c1000000-0000-0000-0000-000000000017','a1000000-0000-0000-0000-000000000003',
$$var trap = function(height) {
    // Write your solution here
};$$,
$$var trap = function(height) {
    let l=0,r=height.length-1,maxL=0,maxR=0,water=0;
    while(l<r){
        if(height[l]<height[r]){height[l]>=maxL?maxL=height[l]:water+=maxL-height[l];l++;}
        else{height[r]>=maxR?maxR=height[r]:water+=maxR-height[r];r--;}
    }
    return water;
};$$),
('e1000000-0000-0000-0000-000000000084','c1000000-0000-0000-0000-000000000017','a1000000-0000-0000-0000-000000000004',
$$class Solution {
    public int trap(int[] height) {
        // Write your solution here
        return 0;
    }
}$$,
$$class Solution {
    public int trap(int[] h) {
        int l=0,r=h.length-1,maxL=0,maxR=0,water=0;
        while(l<r){
            if(h[l]<h[r]){if(h[l]>=maxL)maxL=h[l];else water+=maxL-h[l];l++;}
            else{if(h[r]>=maxR)maxR=h[r];else water+=maxR-h[r];r--;}
        }
        return water;
    }
}$$),
('e1000000-0000-0000-0000-000000000085','c1000000-0000-0000-0000-000000000017','a1000000-0000-0000-0000-000000000005',
$$int trap(int* height, int heightSize) {
    // Write your solution here
    return 0;
}$$,
$$int trap(int* h, int n) {
    int l=0,r=n-1,maxL=0,maxR=0,water=0;
    while(l<r){
        if(h[l]<h[r]){if(h[l]>=maxL)maxL=h[l];else water+=maxL-h[l];l++;}
        else{if(h[r]>=maxR)maxR=h[r];else water+=maxR-h[r];r--;}
    }
    return water;
}$$);


-- =============================================================
--  PROBLEM 18 — Merge k Sorted Lists  [HARD]
-- =============================================================
INSERT INTO problems (
  id, title, slug, difficulty, is_published,
  time_limit_ms, memory_limit_kb, total_submissions, total_accepted, description
) VALUES (
  'c1000000-0000-0000-0000-000000000018',
  'Merge k Sorted Lists', 'merge-k-sorted-lists', 'hard', TRUE,
  2000, 262144, 2901234, 1201234,
$$
## Problem

You are given an array of `k` linked-lists `lists`, each linked-list is sorted in ascending order.

Merge all the linked-lists into one sorted linked-list and return it.

---

## Examples

**Example 1:**
```
Input:  lists = [[1,4,5],[1,3,4],[2,6]]
Output: [1,1,2,3,4,4,5,6]
```

**Example 2:**
```
Input:  lists = []
Output: []
```

**Example 3:**
```
Input:  lists = [[]]
Output: []
```

---

## Constraints

- `k == lists.length`
- `0 <= k <= 10^4`
- `0 <= lists[i].length <= 500`
- `-10^4 <= lists[i][j] <= 10^4`
- Each list is sorted in ascending order.

---

## Hint

Use a **min-heap** of size `k`. Always extract the minimum node and push its next node into the heap.
$$);

INSERT INTO problem_tags (problem_id, tag_id) VALUES
  ('c1000000-0000-0000-0000-000000000018', 'b1000000-0000-0000-0000-000000000005'),
  ('c1000000-0000-0000-0000-000000000018', 'b1000000-0000-0000-0000-000000000017'),
  ('c1000000-0000-0000-0000-000000000018', 'b1000000-0000-0000-0000-000000000008');

INSERT INTO test_cases (id, problem_id, input, expected_output, is_sample, explanation, order_index) VALUES
  ('d1000000-0000-0000-0000-000000000082','c1000000-0000-0000-0000-000000000018','{"lists":[[1,4,5],[1,3,4],[2,6]]}','[1,1,2,3,4,4,5,6]',TRUE,'Three lists merged',1),
  ('d1000000-0000-0000-0000-000000000083','c1000000-0000-0000-0000-000000000018','{"lists":[]}','[]',TRUE,'No lists',2),
  ('d1000000-0000-0000-0000-000000000084','c1000000-0000-0000-0000-000000000018','{"lists":[[]]}','[]',FALSE,NULL,3),
  ('d1000000-0000-0000-0000-000000000085','c1000000-0000-0000-0000-000000000018','{"lists":[[-2,-1,-1,3],[0],[1,2]]}','[-2,-1,-1,0,1,2,3]',FALSE,NULL,4);

INSERT INTO problem_templates (id, problem_id, language_id, starter_code, solution_code) VALUES
('e1000000-0000-0000-0000-000000000086','c1000000-0000-0000-0000-000000000018','a1000000-0000-0000-0000-000000000001',
$$from typing import List, Optional
import heapq
class ListNode:
    def __init__(self, val=0, next=None): self.val=val; self.next=next
class Solution:
    def mergeKLists(self, lists: List[Optional[ListNode]]) -> Optional[ListNode]:
        pass$$,
$$class Solution:
    def mergeKLists(self, lists):
        heap=[]; dummy=ListNode(); cur=dummy
        for i,node in enumerate(lists):
            if node: heapq.heappush(heap,(node.val,i,node))
        while heap:
            val,i,node=heapq.heappop(heap)
            cur.next=node; cur=cur.next
            if node.next: heapq.heappush(heap,(node.next.val,i,node.next))
        return dummy.next$$),
('e1000000-0000-0000-0000-000000000087','c1000000-0000-0000-0000-000000000018','a1000000-0000-0000-0000-000000000002',
$$#include <vector>
#include <queue>
using namespace std;
struct ListNode { int val; ListNode *next; ListNode(int x=0,ListNode*n=nullptr):val(x),next(n){} };
class Solution {
public:
    ListNode* mergeKLists(vector<ListNode*>& lists) {
        // Write your solution here
        return nullptr;
    }
};$$,
$$class Solution {
public:
    ListNode* mergeKLists(vector<ListNode*>& lists) {
        auto cmp=[](ListNode* a,ListNode* b){return a->val>b->val;};
        priority_queue<ListNode*,vector<ListNode*>,decltype(cmp)> pq(cmp);
        for(auto l:lists) if(l) pq.push(l);
        ListNode dummy; ListNode* cur=&dummy;
        while(!pq.empty()){
            cur->next=pq.top(); pq.pop(); cur=cur->next;
            if(cur->next) pq.push(cur->next);
        }
        return dummy.next;
    }
};$$),
('e1000000-0000-0000-0000-000000000088','c1000000-0000-0000-0000-000000000018','a1000000-0000-0000-0000-000000000003',
$$function ListNode(val,next){this.val=(val===undefined?0:val);this.next=(next===undefined?null:next);}
var mergeKLists = function(lists) {
    // Write your solution here
};$$,
$$var mergeKLists = function(lists) {
    const mergeTwoLists=(a,b)=>{
        let dummy=new ListNode(),cur=dummy;
        while(a&&b){if(a.val<=b.val){cur.next=a;a=a.next;}else{cur.next=b;b=b.next;}cur=cur.next;}
        cur.next=a||b; return dummy.next;
    };
    if(!lists.length) return null;
    while(lists.length>1){
        const merged=[];
        for(let i=0;i<lists.length;i+=2) merged.push(mergeTwoLists(lists[i],lists[i+1]||null));
        lists=merged;
    }
    return lists[0];
};$$),
('e1000000-0000-0000-0000-000000000089','c1000000-0000-0000-0000-000000000018','a1000000-0000-0000-0000-000000000004',
$$import java.util.PriorityQueue;
class ListNode { int val; ListNode next; ListNode(int x){val=x;} }
class Solution {
    public ListNode mergeKLists(ListNode[] lists) {
        // Write your solution here
        return null;
    }
}$$,
$$class Solution {
    public ListNode mergeKLists(ListNode[] lists) {
        PriorityQueue<ListNode> pq=new PriorityQueue<>((a,b)->a.val-b.val);
        for(ListNode l:lists) if(l!=null) pq.add(l);
        ListNode dummy=new ListNode(0),cur=dummy;
        while(!pq.isEmpty()){
            cur.next=pq.poll(); cur=cur.next;
            if(cur.next!=null) pq.add(cur.next);
        }
        return dummy.next;
    }
}$$),
('e1000000-0000-0000-0000-000000000090','c1000000-0000-0000-0000-000000000018','a1000000-0000-0000-0000-000000000005',
$$#include <stdlib.h>
struct ListNode { int val; struct ListNode* next; };
struct ListNode* mergeKLists(struct ListNode** lists, int listsSize) {
    // Write your solution here (divide & conquer approach)
    return NULL;
}$$,
$$struct ListNode* mergeTwoL(struct ListNode* a, struct ListNode* b){
    struct ListNode dummy; struct ListNode* cur=&dummy; dummy.next=NULL;
    while(a&&b){if(a->val<=b->val){cur->next=a;a=a->next;}else{cur->next=b;b=b->next;}cur=cur->next;}
    cur->next=a?a:b; return dummy.next;
}
struct ListNode* mergeKLists(struct ListNode** lists, int n) {
    if(n==0) return NULL;
    while(n>1){
        for(int i=0;i<n/2;i++) lists[i]=mergeTwoL(lists[i],lists[n-1-i]);
        n=(n+1)/2;
    }
    return lists[0];
}$$);


-- =============================================================
--  PROBLEM 19 — Longest Valid Parentheses  [HARD]
-- =============================================================
INSERT INTO problems (
  id, title, slug, difficulty, is_published,
  time_limit_ms, memory_limit_kb, total_submissions, total_accepted, description
) VALUES (
  'c1000000-0000-0000-0000-000000000019',
  'Longest Valid Parentheses', 'longest-valid-parentheses', 'hard', TRUE,
  2000, 262144, 2501234, 987654,
$$
## Problem

Given a string containing just the characters `'('` and `')'`, return the length of the **longest valid (well-formed) parentheses substring**.

---

## Examples

**Example 1:**
```
Input:  s = "(()"
Output: 2
Explanation: The longest valid parentheses substring is "()".
```

**Example 2:**
```
Input:  s = ")()())"
Output: 4
Explanation: The longest valid parentheses substring is "()()".
```

**Example 3:**
```
Input:  s = ""
Output: 0
```

---

## Constraints

- `0 <= s.length <= 3 * 10^4`
- `s[i]` is `'('` or `')'`.

---

## Hint

Use a **stack** storing indices. Initialize with `-1` as a base. For `'('` push index; for `')'` pop — if stack empty push current index as new base, else update max length.
$$);

INSERT INTO problem_tags (problem_id, tag_id) VALUES
  ('c1000000-0000-0000-0000-000000000019', 'b1000000-0000-0000-0000-000000000003'),
  ('c1000000-0000-0000-0000-000000000019', 'b1000000-0000-0000-0000-000000000009'),
  ('c1000000-0000-0000-0000-000000000019', 'b1000000-0000-0000-0000-000000000010');

INSERT INTO test_cases (id, problem_id, input, expected_output, is_sample, explanation, order_index) VALUES
  ('d1000000-0000-0000-0000-000000000086','c1000000-0000-0000-0000-000000000019','{"s":"(()"}','2',TRUE,'Valid: "()"',1),
  ('d1000000-0000-0000-0000-000000000087','c1000000-0000-0000-0000-000000000019','{"s":")()())"}','4',TRUE,'Valid: "()()"',2),
  ('d1000000-0000-0000-0000-000000000088','c1000000-0000-0000-0000-000000000019','{"s":""}','0',TRUE,'Empty string',3),
  ('d1000000-0000-0000-0000-000000000089','c1000000-0000-0000-0000-000000000019','{"s":"()(()"}','2',FALSE,NULL,4),
  ('d1000000-0000-0000-0000-000000000090','c1000000-0000-0000-0000-000000000019','{"s":"(()())"}','6',FALSE,NULL,5),
  ('d1000000-0000-0000-0000-000000000091','c1000000-0000-0000-0000-000000000019','{"s":"()()"}','4',FALSE,NULL,6);

INSERT INTO problem_templates (id, problem_id, language_id, starter_code, solution_code) VALUES
('e1000000-0000-0000-0000-000000000091','c1000000-0000-0000-0000-000000000019','a1000000-0000-0000-0000-000000000001',
$$class Solution:
    def longestValidParentheses(self, s: str) -> int:
        pass$$,
$$class Solution:
    def longestValidParentheses(self, s):
        stack=[-1]; res=0
        for i,c in enumerate(s):
            if c=='(': stack.append(i)
            else:
                stack.pop()
                if not stack: stack.append(i)
                else: res=max(res,i-stack[-1])
        return res$$),
('e1000000-0000-0000-0000-000000000092','c1000000-0000-0000-0000-000000000019','a1000000-0000-0000-0000-000000000002',
$$#include <string>
#include <stack>
using namespace std;
class Solution {
public:
    int longestValidParentheses(string s) {
        // Write your solution here
        return 0;
    }
};$$,
$$class Solution {
public:
    int longestValidParentheses(string s) {
        stack<int> st; st.push(-1); int res=0;
        for(int i=0;i<(int)s.size();i++){
            if(s[i]=='(') st.push(i);
            else{
                st.pop();
                if(st.empty()) st.push(i);
                else res=max(res,i-(int)st.top());
            }
        }
        return res;
    }
};$$),
('e1000000-0000-0000-0000-000000000093','c1000000-0000-0000-0000-000000000019','a1000000-0000-0000-0000-000000000003',
$$var longestValidParentheses = function(s) {
    // Write your solution here
};$$,
$$var longestValidParentheses = function(s) {
    const stack=[-1]; let res=0;
    for(let i=0;i<s.length;i++){
        if(s[i]==='(') stack.push(i);
        else{
            stack.pop();
            if(!stack.length) stack.push(i);
            else res=Math.max(res,i-stack[stack.length-1]);
        }
    }
    return res;
};$$),
('e1000000-0000-0000-0000-000000000094','c1000000-0000-0000-0000-000000000019','a1000000-0000-0000-0000-000000000004',
$$import java.util.Stack;
class Solution {
    public int longestValidParentheses(String s) {
        // Write your solution here
        return 0;
    }
}$$,
$$import java.util.Stack;
class Solution {
    public int longestValidParentheses(String s) {
        Stack<Integer> st=new Stack<>(); st.push(-1); int res=0;
        for(int i=0;i<s.length();i++){
            if(s.charAt(i)=='(') st.push(i);
            else{
                st.pop();
                if(st.isEmpty()) st.push(i);
                else res=Math.max(res,i-st.peek());
            }
        }
        return res;
    }
}$$),
('e1000000-0000-0000-0000-000000000095','c1000000-0000-0000-0000-000000000019','a1000000-0000-0000-0000-000000000005',
$$int longestValidParentheses(char* s) {
    // Write your solution here
    return 0;
}$$,
$$#include <string.h>
#include <stdlib.h>
int longestValidParentheses(char* s) {
    int n=strlen(s); if(n==0) return 0;
    int* st=(int*)malloc((n+1)*sizeof(int)); int top=0; st[top++]=-1;
    int res=0;
    for(int i=0;i<n;i++){
        if(s[i]=='(') st[top++]=i;
        else{
            top--;
            if(top==0) st[top++]=i;
            else { int len=i-st[top-1]; if(len>res) res=len; }
        }
    }
    free(st); return res;
}$$);


-- =============================================================
--  PROBLEM 20 — Sliding Window Maximum  [HARD]
-- =============================================================
INSERT INTO problems (
  id, title, slug, difficulty, is_published,
  time_limit_ms, memory_limit_kb, total_submissions, total_accepted, description
) VALUES (
  'c1000000-0000-0000-0000-000000000020',
  'Sliding Window Maximum', 'sliding-window-maximum', 'hard', TRUE,
  2000, 262144, 2301234, 901234,
$$
## Problem

You are given an array of integers `nums`, there is a sliding window of size `k` which is moving from the very left of the array to the very right. You can only see the `k` numbers in the window. Each time the sliding window moves right by one position.

Return the **max sliding window** — an array of the maximum element in each window position.

---

## Examples

**Example 1:**
```
Input:  nums = [1,3,-1,-3,5,3,6,7], k = 3
Output: [3,3,5,5,6,7]
```

**Example 2:**
```
Input:  nums = [1], k = 1
Output: [1]
```

---

## Constraints

- `1 <= nums.length <= 10^5`
- `-10^4 <= nums[i] <= 10^4`
- `1 <= k <= nums.length`

---

## Hint

Use a **monotonic deque** (double-ended queue) that stores indices. The front always holds the index of the maximum element in the current window. Remove indices that fall out of the window and those whose values are smaller than the current element from the back.
$$);

INSERT INTO problem_tags (problem_id, tag_id) VALUES
  ('c1000000-0000-0000-0000-000000000020', 'b1000000-0000-0000-0000-000000000001'),
  ('c1000000-0000-0000-0000-000000000020', 'b1000000-0000-0000-0000-000000000004'),
  ('c1000000-0000-0000-0000-000000000020', 'b1000000-0000-0000-0000-000000000019');

INSERT INTO test_cases (id, problem_id, input, expected_output, is_sample, explanation, order_index) VALUES
  ('d1000000-0000-0000-0000-000000000092','c1000000-0000-0000-0000-000000000020','{"nums":[1,3,-1,-3,5,3,6,7],"k":3}','[3,3,5,5,6,7]',TRUE,'Six windows of size 3',1),
  ('d1000000-0000-0000-0000-000000000093','c1000000-0000-0000-0000-000000000020','{"nums":[1],"k":1}','[1]',TRUE,'Single element',2),
  ('d1000000-0000-0000-0000-000000000094','c1000000-0000-0000-0000-000000000020','{"nums":[1,-1],"k":1}','[1,-1]',FALSE,NULL,3),
  ('d1000000-0000-0000-0000-000000000095','c1000000-0000-0000-0000-000000000020','{"nums":[9,11],"k":2}','[11]',FALSE,NULL,4),
  ('d1000000-0000-0000-0000-000000000096','c1000000-0000-0000-0000-000000000020','{"nums":[4,-2,7,3,8,1,2,9,1,5],"k":4}','[7,8,8,8,9,9,9]',FALSE,NULL,5);

INSERT INTO problem_templates (id, problem_id, language_id, starter_code, solution_code) VALUES
('e1000000-0000-0000-0000-000000000096','c1000000-0000-0000-0000-000000000020','a1000000-0000-0000-0000-000000000001',
$$from typing import List
from collections import deque
class Solution:
    def maxSlidingWindow(self, nums: List[int], k: int) -> List[int]:
        pass$$,
$$from collections import deque
class Solution:
    def maxSlidingWindow(self, nums, k):
        dq=deque(); res=[]
        for i,n in enumerate(nums):
            while dq and nums[dq[-1]]<=n: dq.pop()
            dq.append(i)
            if dq[0]<i-k+1: dq.popleft()
            if i>=k-1: res.append(nums[dq[0]])
        return res$$),
('e1000000-0000-0000-0000-000000000097','c1000000-0000-0000-0000-000000000020','a1000000-0000-0000-0000-000000000002',
$$#include <vector>
#include <deque>
using namespace std;
class Solution {
public:
    vector<int> maxSlidingWindow(vector<int>& nums, int k) {
        // Write your solution here
        return {};
    }
};$$,
$$class Solution {
public:
    vector<int> maxSlidingWindow(vector<int>& nums, int k) {
        deque<int> dq; vector<int> res;
        for(int i=0;i<(int)nums.size();i++){
            while(!dq.empty()&&nums[dq.back()]<=nums[i]) dq.pop_back();
            dq.push_back(i);
            if(dq.front()<i-k+1) dq.pop_front();
            if(i>=k-1) res.push_back(nums[dq.front()]);
        }
        return res;
    }
};$$),
('e1000000-0000-0000-0000-000000000098','c1000000-0000-0000-0000-000000000020','a1000000-0000-0000-0000-000000000003',
$$var maxSlidingWindow = function(nums, k) {
    // Write your solution here
};$$,
$$var maxSlidingWindow = function(nums, k) {
    const dq=[], res=[];
    for(let i=0;i<nums.length;i++){
        while(dq.length && nums[dq[dq.length-1]]<=nums[i]) dq.pop();
        dq.push(i);
        if(dq[0]<i-k+1) dq.shift();
        if(i>=k-1) res.push(nums[dq[0]]);
    }
    return res;
};$$),
('e1000000-0000-0000-0000-000000000099','c1000000-0000-0000-0000-000000000020','a1000000-0000-0000-0000-000000000004',
$$import java.util.ArrayDeque;
class Solution {
    public int[] maxSlidingWindow(int[] nums, int k) {
        // Write your solution here
        return new int[]{};
    }
}$$,
$$import java.util.ArrayDeque;
class Solution {
    public int[] maxSlidingWindow(int[] nums, int k) {
        int n=nums.length; int[] res=new int[n-k+1];
        ArrayDeque<Integer> dq=new ArrayDeque<>();
        for(int i=0;i<n;i++){
            while(!dq.isEmpty()&&nums[dq.peekLast()]<=nums[i]) dq.pollLast();
            dq.addLast(i);
            if(dq.peekFirst()<i-k+1) dq.pollFirst();
            if(i>=k-1) res[i-k+1]=nums[dq.peekFirst()];
        }
        return res;
    }
}$$),
('e1000000-0000-0000-0000-000000000100','c1000000-0000-0000-0000-000000000020','a1000000-0000-0000-0000-000000000005',
$$#include <stdlib.h>
int* maxSlidingWindow(int* nums, int numsSize, int k, int* returnSize) {
    // Write your solution here
    *returnSize = numsSize - k + 1; return NULL;
}$$,
$$#include <stdlib.h>
int* maxSlidingWindow(int* nums, int n, int k, int* returnSize) {
    *returnSize=n-k+1;
    int* res=(int*)malloc(*returnSize*sizeof(int));
    int* dq=(int*)malloc(n*sizeof(int)); int front=0,back=0;
    for(int i=0;i<n;i++){
        while(front<back && nums[dq[back-1]]<=nums[i]) back--;
        dq[back++]=i;
        if(dq[front]<i-k+1) front++;
        if(i>=k-1) res[i-k+1]=nums[dq[front]];
    }
    free(dq); return res;
}$$);

-- =============================================================
-- END OF SEED
-- 5 Languages | 20 Problems | 96 Test Cases | 100 Templates
-- =============================================================