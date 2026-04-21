-- =============================================================
--  SEED: 5 LeetCode-style Problems
--  1 Easy | 2 Medium | 2 Hard
--  Compatible with the provided schema
-- =============================================================

-- -------------------------------------------------------------
-- LANGUAGES
-- -------------------------------------------------------------
INSERT INTO languages (id, name, slug, version, is_active) VALUES
  ('a1000000-0000-0000-0000-000000000001', 'Python 3',   'python3',     '3.11', TRUE),
  ('a1000000-0000-0000-0000-000000000002', 'C++',        'cpp',         '17',   TRUE),
  ('a1000000-0000-0000-0000-000000000003', 'JavaScript', 'javascript',  'ES2022', TRUE),
  ('a1000000-0000-0000-0000-000000000004', 'Java',       'java',        '21',   TRUE);

-- -------------------------------------------------------------
-- TAGS
-- -------------------------------------------------------------
INSERT INTO tags (id, name, slug) VALUES
  ('b1000000-0000-0000-0000-000000000001', 'Array',                 'array'),
  ('b1000000-0000-0000-0000-000000000002', 'Hash Table',            'hash-table'),
  ('b1000000-0000-0000-0000-000000000003', 'String',                'string'),
  ('b1000000-0000-0000-0000-000000000004', 'Sliding Window',        'sliding-window'),
  ('b1000000-0000-0000-0000-000000000005', 'Linked List',           'linked-list'),
  ('b1000000-0000-0000-0000-000000000006', 'Two Pointers',          'two-pointers'),
  ('b1000000-0000-0000-0000-000000000007', 'Binary Search',         'binary-search'),
  ('b1000000-0000-0000-0000-000000000008', 'Divide and Conquer',    'divide-and-conquer'),
  ('b1000000-0000-0000-0000-000000000009', 'Stack',                 'stack'),
  ('b1000000-0000-0000-0000-000000000010', 'Dynamic Programming',   'dynamic-programming'),
  ('b1000000-0000-0000-0000-000000000011', 'Math',                  'math'),
  ('b1000000-0000-0000-0000-000000000012', 'Recursion',             'recursion');


-- =============================================================
--  PROBLEM 1 — Two Sum  [EASY]
-- =============================================================
INSERT INTO problems (
  id, title, slug, difficulty, is_published,
  time_limit_ms, memory_limit_kb,
  total_submissions, total_accepted,
  description
) VALUES (
  'c1000000-0000-0000-0000-000000000001',
  'Two Sum', 'two-sum', 'easy', TRUE,
  2000, 262144, 9842301, 5913045,
$$
## Problem

Given an array of integers `nums` and an integer `target`, return **indices** of the two numbers such that they add up to `target`.

You may assume that each input would have **exactly one solution**, and you may **not** use the same element twice.

You can return the answer in any order.

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
$$
);

-- Tags
INSERT INTO problem_tags (problem_id, tag_id) VALUES
  ('c1000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000001'),
  ('c1000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000002');

-- Test Cases
INSERT INTO test_cases (id, problem_id, input, expected_output, is_sample, explanation, order_index) VALUES
  ('d1000000-0000-0000-0000-000000000001',
   'c1000000-0000-0000-0000-000000000001',
   '{"nums": [2, 7, 11, 15], "target": 9}',
   '[0, 1]',
   TRUE,
   'nums[0] + nums[1] = 2 + 7 = 9, so the answer is [0, 1].',
   1),

  ('d1000000-0000-0000-0000-000000000002',
   'c1000000-0000-0000-0000-000000000001',
   '{"nums": [3, 2, 4], "target": 6}',
   '[1, 2]',
   TRUE,
   'nums[1] + nums[2] = 2 + 4 = 6.',
   2),

  ('d1000000-0000-0000-0000-000000000003',
   'c1000000-0000-0000-0000-000000000001',
   '{"nums": [3, 3], "target": 6}',
   '[0, 1]',
   FALSE, NULL, 3),

  ('d1000000-0000-0000-0000-000000000004',
   'c1000000-0000-0000-0000-000000000001',
   '{"nums": [-1, -2, -3, -4, -5], "target": -8}',
   '[2, 4]',
   FALSE, NULL, 4),

  ('d1000000-0000-0000-0000-000000000005',
   'c1000000-0000-0000-0000-000000000001',
   '{"nums": [1000000000, -1000000000, 0, 1], "target": 1}',
   '[2, 3]',
   FALSE, NULL, 5);

-- Templates
INSERT INTO problem_templates (id, problem_id, language_id, starter_code, solution_code) VALUES
  ('e1000000-0000-0000-0000-000000000001',
   'c1000000-0000-0000-0000-000000000001',
   'a1000000-0000-0000-0000-000000000001',
$$
from typing import List

class Solution:
    def twoSum(self, nums: List[int], target: int) -> List[int]:
        # Write your solution here
        pass
$$,
$$
from typing import List

class Solution:
    def twoSum(self, nums: List[int], target: int) -> List[int]:
        seen = {}
        for i, n in enumerate(nums):
            diff = target - n
            if diff in seen:
                return [seen[diff], i]
            seen[n] = i
$$),

  ('e1000000-0000-0000-0000-000000000002',
   'c1000000-0000-0000-0000-000000000001',
   'a1000000-0000-0000-0000-000000000002',
$$
#include <vector>
#include <unordered_map>
using namespace std;

class Solution {
public:
    vector<int> twoSum(vector<int>& nums, int target) {
        // Write your solution here
    }
};
$$,
$$
#include <vector>
#include <unordered_map>
using namespace std;

class Solution {
public:
    vector<int> twoSum(vector<int>& nums, int target) {
        unordered_map<int, int> seen;
        for (int i = 0; i < nums.size(); i++) {
            int diff = target - nums[i];
            if (seen.count(diff)) return {seen[diff], i};
            seen[nums[i]] = i;
        }
        return {};
    }
};
$$),

  ('e1000000-0000-0000-0000-000000000003',
   'c1000000-0000-0000-0000-000000000001',
   'a1000000-0000-0000-0000-000000000003',
$$
/**
 * @param {number[]} nums
 * @param {number} target
 * @return {number[]}
 */
var twoSum = function(nums, target) {
    // Write your solution here
};
$$,
$$
var twoSum = function(nums, target) {
    const seen = new Map();
    for (let i = 0; i < nums.length; i++) {
        const diff = target - nums[i];
        if (seen.has(diff)) return [seen.get(diff), i];
        seen.set(nums[i], i);
    }
};
$$);


-- =============================================================
--  PROBLEM 2 — Longest Substring Without Repeating Characters  [MEDIUM]
-- =============================================================
INSERT INTO problems (
  id, title, slug, difficulty, is_published,
  time_limit_ms, memory_limit_kb,
  total_submissions, total_accepted,
  description
) VALUES (
  'c1000000-0000-0000-0000-000000000002',
  'Longest Substring Without Repeating Characters',
  'longest-substring-without-repeating-characters',
  'medium', TRUE,
  2000, 262144, 6123445, 2701234,
$$
## Problem

Given a string `s`, find the length of the **longest substring** without repeating characters.

A **substring** is a contiguous sequence of characters within a string.

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
Explanation: The answer is "b", with the length of 1.
```

**Example 3:**
```
Input:  s = "pwwkew"
Output: 3
Explanation: The answer is "wke", with the length of 3.
             Note that "pwke" is a subsequence and not a substring.
```

---

## Constraints

- `0 <= s.length <= 5 * 10^4`
- `s` consists of English letters, digits, symbols and spaces.

---

## Hints

> **Hint 1:** Use a sliding window. Maintain a window `[left, right]` and expand it to the right. If a duplicate is encountered, shrink from the left.

> **Hint 2:** A hash map storing the last seen index of each character lets you jump `left` pointer directly instead of moving it one step at a time.
$$
);

INSERT INTO problem_tags (problem_id, tag_id) VALUES
  ('c1000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000003'),
  ('c1000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000004'),
  ('c1000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000002');

INSERT INTO test_cases (id, problem_id, input, expected_output, is_sample, explanation, order_index) VALUES
  ('d1000000-0000-0000-0000-000000000006',
   'c1000000-0000-0000-0000-000000000002',
   '{"s": "abcabcbb"}', '3',
   TRUE, 'The longest substring without repeating characters is "abc", length 3.', 1),

  ('d1000000-0000-0000-0000-000000000007',
   'c1000000-0000-0000-0000-000000000002',
   '{"s": "bbbbb"}', '1',
   TRUE, 'Every character repeats; longest is "b", length 1.', 2),

  ('d1000000-0000-0000-0000-000000000008',
   'c1000000-0000-0000-0000-000000000002',
   '{"s": "pwwkew"}', '3',
   FALSE, NULL, 3),

  ('d1000000-0000-0000-0000-000000000009',
   'c1000000-0000-0000-0000-000000000002',
   '{"s": ""}', '0',
   FALSE, NULL, 4),

  ('d1000000-0000-0000-0000-000000000010',
   'c1000000-0000-0000-0000-000000000002',
   '{"s": " "}', '1',
   FALSE, NULL, 5),

  ('d1000000-0000-0000-0000-000000000011',
   'c1000000-0000-0000-0000-000000000002',
   '{"s": "dvdf"}', '3',
   FALSE, NULL, 6);

INSERT INTO problem_templates (id, problem_id, language_id, starter_code, solution_code) VALUES
  ('e1000000-0000-0000-0000-000000000004',
   'c1000000-0000-0000-0000-000000000002',
   'a1000000-0000-0000-0000-000000000001',
$$
class Solution:
    def lengthOfLongestSubstring(self, s: str) -> int:
        # Write your solution here
        pass
$$,
$$
class Solution:
    def lengthOfLongestSubstring(self, s: str) -> int:
        seen = {}
        left = res = 0
        for right, ch in enumerate(s):
            if ch in seen and seen[ch] >= left:
                left = seen[ch] + 1
            seen[ch] = right
            res = max(res, right - left + 1)
        return res
$$),

  ('e1000000-0000-0000-0000-000000000005',
   'c1000000-0000-0000-0000-000000000002',
   'a1000000-0000-0000-0000-000000000002',
$$
#include <string>
#include <unordered_map>
using namespace std;

class Solution {
public:
    int lengthOfLongestSubstring(string s) {
        // Write your solution here
    }
};
$$,
$$
#include <string>
#include <unordered_map>
using namespace std;

class Solution {
public:
    int lengthOfLongestSubstring(string s) {
        unordered_map<char, int> seen;
        int left = 0, res = 0;
        for (int r = 0; r < s.size(); r++) {
            if (seen.count(s[r]) && seen[s[r]] >= left)
                left = seen[s[r]] + 1;
            seen[s[r]] = r;
            res = max(res, r - left + 1);
        }
        return res;
    }
};
$$),

  ('e1000000-0000-0000-0000-000000000006',
   'c1000000-0000-0000-0000-000000000002',
   'a1000000-0000-0000-0000-000000000003',
$$
/**
 * @param {string} s
 * @return {number}
 */
var lengthOfLongestSubstring = function(s) {
    // Write your solution here
};
$$,
$$
var lengthOfLongestSubstring = function(s) {
    const seen = new Map();
    let left = 0, res = 0;
    for (let r = 0; r < s.length; r++) {
        if (seen.has(s[r]) && seen.get(s[r]) >= left)
            left = seen.get(s[r]) + 1;
        seen.set(s[r], r);
        res = Math.max(res, r - left + 1);
    }
    return res;
};
$$);


-- =============================================================
--  PROBLEM 3 — Add Two Numbers  [MEDIUM]
-- =============================================================
INSERT INTO problems (
  id, title, slug, difficulty, is_published,
  time_limit_ms, memory_limit_kb,
  total_submissions, total_accepted,
  description
) VALUES (
  'c1000000-0000-0000-0000-000000000003',
  'Add Two Numbers',
  'add-two-numbers',
  'medium', TRUE,
  2000, 262144, 5401238, 2234567,
$$
## Problem

You are given two **non-empty** linked lists representing two non-negative integers.
The digits are stored in **reverse order**, and each of their nodes contains a single digit.

Add the two numbers and return the sum as a linked list (also in reverse order).

You may assume the two numbers do not contain any leading zero, except the number `0` itself.

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
Explanation: 9999999 + 9999 = 10009998
```

---

## Constraints

- The number of nodes in each linked list is in the range `[1, 100]`.
- `0 <= Node.val <= 9`
- It is guaranteed that the list represents a number that does not have leading zeros.

---

## Definition for singly-linked list:
```python
class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next
```

---

## Hints

> **Hint 1:** Traverse both lists simultaneously, adding digits along with the carry.

> **Hint 2:** Don't forget to handle the carry after the last pair of digits — it may create an extra node.
$$
);

INSERT INTO problem_tags (problem_id, tag_id) VALUES
  ('c1000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000005'),
  ('c1000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000011'),
  ('c1000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000012');

INSERT INTO test_cases (id, problem_id, input, expected_output, is_sample, explanation, order_index) VALUES
  ('d1000000-0000-0000-0000-000000000012',
   'c1000000-0000-0000-0000-000000000003',
   '{"l1": [2,4,3], "l2": [5,6,4]}', '[7,0,8]',
   TRUE, '342 + 465 = 807, stored in reverse as [7, 0, 8].', 1),

  ('d1000000-0000-0000-0000-000000000013',
   'c1000000-0000-0000-0000-000000000003',
   '{"l1": [0], "l2": [0]}', '[0]',
   TRUE, '0 + 0 = 0.', 2),

  ('d1000000-0000-0000-0000-000000000014',
   'c1000000-0000-0000-0000-000000000003',
   '{"l1": [9,9,9,9,9,9,9], "l2": [9,9,9,9]}', '[8,9,9,9,0,0,0,1]',
   TRUE, '9999999 + 9999 = 10009998, stored reversed.', 3),

  ('d1000000-0000-0000-0000-000000000015',
   'c1000000-0000-0000-0000-000000000003',
   '{"l1": [1], "l2": [9,9]}', '[0,0,1]',
   FALSE, NULL, 4),

  ('d1000000-0000-0000-0000-000000000016',
   'c1000000-0000-0000-0000-000000000003',
   '{"l1": [5], "l2": [5]}', '[0,1]',
   FALSE, NULL, 5);

INSERT INTO problem_templates (id, problem_id, language_id, starter_code, solution_code) VALUES
  ('e1000000-0000-0000-0000-000000000007',
   'c1000000-0000-0000-0000-000000000003',
   'a1000000-0000-0000-0000-000000000001',
$$
from typing import Optional

class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next

class Solution:
    def addTwoNumbers(self, l1: Optional[ListNode], l2: Optional[ListNode]) -> Optional[ListNode]:
        # Write your solution here
        pass
$$,
$$
class Solution:
    def addTwoNumbers(self, l1, l2):
        dummy = ListNode(0)
        cur, carry = dummy, 0
        while l1 or l2 or carry:
            val = carry
            if l1: val += l1.val; l1 = l1.next
            if l2: val += l2.val; l2 = l2.next
            carry, val = divmod(val, 10)
            cur.next = ListNode(val)
            cur = cur.next
        return dummy.next
$$),

  ('e1000000-0000-0000-0000-000000000008',
   'c1000000-0000-0000-0000-000000000003',
   'a1000000-0000-0000-0000-000000000002',
$$
struct ListNode {
    int val;
    ListNode *next;
    ListNode() : val(0), next(nullptr) {}
    ListNode(int x) : val(x), next(nullptr) {}
    ListNode(int x, ListNode *next) : val(x), next(next) {}
};

class Solution {
public:
    ListNode* addTwoNumbers(ListNode* l1, ListNode* l2) {
        // Write your solution here
    }
};
$$,
$$
class Solution {
public:
    ListNode* addTwoNumbers(ListNode* l1, ListNode* l2) {
        ListNode dummy(0);
        ListNode* cur = &dummy;
        int carry = 0;
        while (l1 || l2 || carry) {
            int sum = carry;
            if (l1) { sum += l1->val; l1 = l1->next; }
            if (l2) { sum += l2->val; l2 = l2->next; }
            carry = sum / 10;
            cur->next = new ListNode(sum % 10);
            cur = cur->next;
        }
        return dummy.next;
    }
};
$$);


-- =============================================================
--  PROBLEM 4 — Median of Two Sorted Arrays  [HARD]
-- =============================================================
INSERT INTO problems (
  id, title, slug, difficulty, is_published,
  time_limit_ms, memory_limit_kb,
  total_submissions, total_accepted,
  description
) VALUES (
  'c1000000-0000-0000-0000-000000000004',
  'Median of Two Sorted Arrays',
  'median-of-two-sorted-arrays',
  'hard', TRUE,
  2000, 262144, 4123089, 1189023,
$$
## Problem

Given two sorted arrays `nums1` and `nums2` of size `m` and `n` respectively, return the **median** of the two sorted arrays.

The overall run time complexity should be **O(log(m + n))**.

---

## Examples

**Example 1:**
```
Input:  nums1 = [1,3], nums2 = [2]
Output: 2.00000
Explanation: merged array = [1,2,3], median = 2.0
```

**Example 2:**
```
Input:  nums1 = [1,2], nums2 = [3,4]
Output: 2.50000
Explanation: merged array = [1,2,3,4], median = (2 + 3) / 2 = 2.5
```

---

## Constraints

- `nums1.length == m`
- `nums2.length == n`
- `0 <= m, n <= 1000`
- `1 <= m + n <= 2000`
- `-10^6 <= nums1[i], nums2[i] <= 10^6`

---

## Key Insight

The naive approach (merge both arrays, pick middle element) runs in **O(m + n)**.
To achieve **O(log(m + n))**, think about binary search on the **partition point** of the smaller array.

A valid partition satisfies:
```
maxLeft1 <= minRight2  AND  maxLeft2 <= minRight1
```
where Left/Right refer to elements on each side of the partition in each array.

---

## Hints

> **Hint 1:** Always binary search on the shorter array to keep complexity minimal.

> **Hint 2:** Think about what "median" means in terms of partitioning both arrays simultaneously — the left half of the combined array has `(m + n + 1) / 2` elements.

> **Hint 3:** Use `float('-inf')` and `float('inf')` as guards when a partition is at the edge of an array.
$$
);

INSERT INTO problem_tags (problem_id, tag_id) VALUES
  ('c1000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000001'),
  ('c1000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000007'),
  ('c1000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000008');

INSERT INTO test_cases (id, problem_id, input, expected_output, is_sample, explanation, order_index) VALUES
  ('d1000000-0000-0000-0000-000000000017',
   'c1000000-0000-0000-0000-000000000004',
   '{"nums1": [1,3], "nums2": [2]}', '2.00000',
   TRUE, 'Merged: [1,2,3]. Median = 2.0', 1),

  ('d1000000-0000-0000-0000-000000000018',
   'c1000000-0000-0000-0000-000000000004',
   '{"nums1": [1,2], "nums2": [3,4]}', '2.50000',
   TRUE, 'Merged: [1,2,3,4]. Median = (2+3)/2 = 2.5', 2),

  ('d1000000-0000-0000-0000-000000000019',
   'c1000000-0000-0000-0000-000000000004',
   '{"nums1": [0,0], "nums2": [0,0]}', '0.00000',
   FALSE, NULL, 3),

  ('d1000000-0000-0000-0000-000000000020',
   'c1000000-0000-0000-0000-000000000004',
   '{"nums1": [], "nums2": [1]}', '1.00000',
   FALSE, NULL, 4),

  ('d1000000-0000-0000-0000-000000000021',
   'c1000000-0000-0000-0000-000000000004',
   '{"nums1": [2], "nums2": []}', '2.00000',
   FALSE, NULL, 5),

  ('d1000000-0000-0000-0000-000000000022',
   'c1000000-0000-0000-0000-000000000004',
   '{"nums1": [1,2,3,4,5], "nums2": [6,7,8,9,10]}', '5.50000',
   FALSE, NULL, 6),

  ('d1000000-0000-0000-0000-000000000023',
   'c1000000-0000-0000-0000-000000000004',
   '{"nums1": [100000], "nums2": [100001]}', '100000.50000',
   FALSE, NULL, 7);

INSERT INTO problem_templates (id, problem_id, language_id, starter_code, solution_code) VALUES
  ('e1000000-0000-0000-0000-000000000009',
   'c1000000-0000-0000-0000-000000000004',
   'a1000000-0000-0000-0000-000000000001',
$$
from typing import List

class Solution:
    def findMedianSortedArrays(self, nums1: List[int], nums2: List[int]) -> float:
        # Write your solution here
        pass
$$,
$$
from typing import List

class Solution:
    def findMedianSortedArrays(self, nums1: List[int], nums2: List[int]) -> float:
        if len(nums1) > len(nums2):
            nums1, nums2 = nums2, nums1
        m, n = len(nums1), len(nums2)
        lo, hi = 0, m
        while lo <= hi:
            px = (lo + hi) // 2
            py = (m + n + 1) // 2 - px
            maxL1 = nums1[px - 1] if px > 0 else float('-inf')
            minR1 = nums1[px]     if px < m else float('inf')
            maxL2 = nums2[py - 1] if py > 0 else float('-inf')
            minR2 = nums2[py]     if py < n else float('inf')
            if maxL1 <= minR2 and maxL2 <= minR1:
                if (m + n) % 2:
                    return float(max(maxL1, maxL2))
                return (max(maxL1, maxL2) + min(minR1, minR2)) / 2.0
            elif maxL1 > minR2:
                hi = px - 1
            else:
                lo = px + 1
$$),

  ('e1000000-0000-0000-0000-000000000010',
   'c1000000-0000-0000-0000-000000000004',
   'a1000000-0000-0000-0000-000000000002',
$$
#include <vector>
#include <climits>
using namespace std;

class Solution {
public:
    double findMedianSortedArrays(vector<int>& nums1, vector<int>& nums2) {
        // Write your solution here
    }
};
$$,
$$
#include <vector>
#include <climits>
#include <algorithm>
using namespace std;

class Solution {
public:
    double findMedianSortedArrays(vector<int>& A, vector<int>& B) {
        if (A.size() > B.size()) swap(A, B);
        int m = A.size(), n = B.size();
        int lo = 0, hi = m;
        while (lo <= hi) {
            int px = (lo + hi) / 2;
            int py = (m + n + 1) / 2 - px;
            int maxL1 = px > 0 ? A[px-1] : INT_MIN;
            int minR1 = px < m ? A[px]   : INT_MAX;
            int maxL2 = py > 0 ? B[py-1] : INT_MIN;
            int minR2 = py < n ? B[py]   : INT_MAX;
            if (maxL1 <= minR2 && maxL2 <= minR1) {
                if ((m+n) % 2) return max(maxL1, maxL2);
                return (max(maxL1,maxL2) + min(minR1,minR2)) / 2.0;
            } else if (maxL1 > minR2) hi = px - 1;
            else lo = px + 1;
        }
        return 0.0;
    }
};
$$);


-- =============================================================
--  PROBLEM 5 — Trapping Rain Water  [HARD]
-- =============================================================
INSERT INTO problems (
  id, title, slug, difficulty, is_published,
  time_limit_ms, memory_limit_kb,
  total_submissions, total_accepted,
  description
) VALUES (
  'c1000000-0000-0000-0000-000000000005',
  'Trapping Rain Water',
  'trapping-rain-water',
  'hard', TRUE,
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

```
Elevation map (# = wall, ~ = water):

        #
    # ~ # ~ ~ # ~ ~ # #
# ~ # # # # # # # # # #
```

Water trapped = 6 units.

**Example 2:**
```
Input:  height = [4,2,0,3,2,5]
Output: 9
```

---

## Constraints

- `n == height.length`
- `1 <= n <= 2 * 10^4`
- `0 <= height[i] <= 10^5`

---

## Approaches

| Approach | Time | Space |
|---|---|---|
| Brute Force | O(n²) | O(1) |
| Precompute prefix/suffix max | O(n) | O(n) |
| **Two Pointers** *(optimal)* | **O(n)** | **O(1)** |
| Monotonic Stack | O(n) | O(n) |

---

## Hints

> **Hint 1:** For each position `i`, the water above it is `min(maxLeft[i], maxRight[i]) - height[i]`. Can you precompute these arrays?

> **Hint 2:** For the O(1) space solution, use two pointers — `left` and `right`. The side with the smaller max height is the bottleneck; process that side and move inward.

> **Hint 3:** At any point if `maxLeft < maxRight`, then for the left pointer we already know the effective ceiling (it's `maxLeft`). Water at that index = `maxLeft - height[left]`. Move `left` forward.
$$
);

INSERT INTO problem_tags (problem_id, tag_id) VALUES
  ('c1000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000001'),
  ('c1000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000006'),
  ('c1000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000009'),
  ('c1000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000010');

INSERT INTO test_cases (id, problem_id, input, expected_output, is_sample, explanation, order_index) VALUES
  ('d1000000-0000-0000-0000-000000000024',
   'c1000000-0000-0000-0000-000000000005',
   '{"height": [0,1,0,2,1,0,1,3,2,1,2,1]}', '6',
   TRUE,
   'The elevation map traps 6 units of rain water total (1+1+0+1+2+1 from different columns).',
   1),

  ('d1000000-0000-0000-0000-000000000025',
   'c1000000-0000-0000-0000-000000000005',
   '{"height": [4,2,0,3,2,5]}', '9',
   TRUE,
   'Water fills: 2 at index 1, 4 at index 2, 1 at index 3, 2 at index 4 = 9.',
   2),

  ('d1000000-0000-0000-0000-000000000026',
   'c1000000-0000-0000-0000-000000000005',
   '{"height": [1,0,1]}', '1',
   FALSE, NULL, 3),

  ('d1000000-0000-0000-0000-000000000027',
   'c1000000-0000-0000-0000-000000000005',
   '{"height": [3,0,0,0,3]}', '9',
   FALSE, NULL, 4),

  ('d1000000-0000-0000-0000-000000000028',
   'c1000000-0000-0000-0000-000000000005',
   '{"height": [1,2,3,4,5]}', '0',
   FALSE, NULL, 5),

  ('d1000000-0000-0000-0000-000000000029',
   'c1000000-0000-0000-0000-000000000005',
   '{"height": [5,4,3,2,1]}', '0',
   FALSE, NULL, 6),

  ('d1000000-0000-0000-0000-000000000030',
   'c1000000-0000-0000-0000-000000000005',
   '{"height": [5,2,1,2,1,5]}', '14',
   FALSE, NULL, 7);

INSERT INTO problem_templates (id, problem_id, language_id, starter_code, solution_code) VALUES
  ('e1000000-0000-0000-0000-000000000011',
   'c1000000-0000-0000-0000-000000000005',
   'a1000000-0000-0000-0000-000000000001',
$$
from typing import List

class Solution:
    def trap(self, height: List[int]) -> int:
        # Write your solution here
        pass
$$,
$$
from typing import List

class Solution:
    def trap(self, height: List[int]) -> int:
        left, right = 0, len(height) - 1
        maxL = maxR = water = 0
        while left < right:
            if height[left] < height[right]:
                if height[left] >= maxL:
                    maxL = height[left]
                else:
                    water += maxL - height[left]
                left += 1
            else:
                if height[right] >= maxR:
                    maxR = height[right]
                else:
                    water += maxR - height[right]
                right -= 1
        return water
$$),

  ('e1000000-0000-0000-0000-000000000012',
   'c1000000-0000-0000-0000-000000000005',
   'a1000000-0000-0000-0000-000000000002',
$$
#include <vector>
using namespace std;

class Solution {
public:
    int trap(vector<int>& height) {
        // Write your solution here
    }
};
$$,
$$
#include <vector>
#include <algorithm>
using namespace std;

class Solution {
public:
    int trap(vector<int>& height) {
        int left = 0, right = height.size() - 1;
        int maxL = 0, maxR = 0, water = 0;
        while (left < right) {
            if (height[left] < height[right]) {
                height[left] >= maxL ? maxL = height[left] : water += maxL - height[left];
                left++;
            } else {
                height[right] >= maxR ? maxR = height[right] : water += maxR - height[right];
                right--;
            }
        }
        return water;
    }
};
$$),

  ('e1000000-0000-0000-0000-000000000013',
   'c1000000-0000-0000-0000-000000000005',
   'a1000000-0000-0000-0000-000000000003',
$$
/**
 * @param {number[]} height
 * @return {number}
 */
var trap = function(height) {
    // Write your solution here
};
$$,
$$
var trap = function(height) {
    let left = 0, right = height.length - 1;
    let maxL = 0, maxR = 0, water = 0;
    while (left < right) {
        if (height[left] < height[right]) {
            height[left] >= maxL ? (maxL = height[left]) : (water += maxL - height[left]);
            left++;
        } else {
            height[right] >= maxR ? (maxR = height[right]) : (water += maxR - height[right]);
            right--;
        }
    }
    return water;
};
$$);

-- =============================================================
-- END OF SEED
-- =============================================================