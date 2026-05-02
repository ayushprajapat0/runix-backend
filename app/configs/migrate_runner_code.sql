-- =============================================================
--  MIGRATION: Add runner_code to problem_templates
--  Run this once against the live database.
-- =============================================================

ALTER TABLE problem_templates ADD COLUMN IF NOT EXISTS runner_code TEXT;


-- =============================================================
--  Two Sum — runner harnesses  (one per language)
--  Placeholder: {{USER_CODE}} is replaced at request-time
--  with the user's submitted function body.
-- =============================================================

-- ── Python 3 ──────────────────────────────────────────────────
UPDATE problem_templates
SET runner_code = $$import sys
import json

{{USER_CODE}}

data   = json.loads(sys.stdin.read().strip())
nums   = data['nums']
target = data['target']
sol    = Solution()
print(sol.twoSum(nums, target))
$$
WHERE problem_id  = 'c1000000-0000-0000-0000-000000000001'
  AND language_id = 'a1000000-0000-0000-0000-000000000001';


-- ── C++ ───────────────────────────────────────────────────────
UPDATE problem_templates
SET runner_code = $$#include <bits/stdc++.h>
using namespace std;

{{USER_CODE}}

int main() {
    string json;
    {
        ostringstream ss;
        ss << cin.rdbuf();
        json = ss.str();
    }
    // parse "nums"
    auto numsStart = json.find('[', json.find("\"nums\""));
    auto numsEnd   = json.find(']', numsStart);
    string numsStr = json.substr(numsStart + 1, numsEnd - numsStart - 1);
    vector<int> nums;
    stringstream ss(numsStr);
    string tok;
    while (getline(ss, tok, ',')) {
        tok.erase(remove_if(tok.begin(), tok.end(), ::isspace), tok.end());
        if (!tok.empty()) nums.push_back(stoi(tok));
    }
    // parse "target"
    auto ti = json.find("\"target\"");
    auto ci = json.find(':', ti);
    int target = stoi(json.substr(ci + 1));

    Solution sol;
    auto res = sol.twoSum(nums, target);
    cout << "[" << res[0] << "," << res[1] << "]" << endl;
    return 0;
}
$$
WHERE problem_id  = 'c1000000-0000-0000-0000-000000000001'
  AND language_id = 'a1000000-0000-0000-0000-000000000002';


-- ── JavaScript ────────────────────────────────────────────────
UPDATE problem_templates
SET runner_code = $${{USER_CODE}}

const data   = JSON.parse(require('fs').readFileSync('/dev/stdin', 'utf8').trim());
const result = twoSum(data.nums, data.target);
console.log(JSON.stringify(result));
$$
WHERE problem_id  = 'c1000000-0000-0000-0000-000000000001'
  AND language_id = 'a1000000-0000-0000-0000-000000000003';


-- ── Java ──────────────────────────────────────────────────────
UPDATE problem_templates
SET runner_code = $$import java.util.*;
import java.io.*;
public class Solution {
    public static void main(String[] args) throws Exception {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) sb.append(line);
        String json = sb.toString().trim();
        int numsStart = json.indexOf("[", json.indexOf("\"nums\""));
        int numsEnd   = json.indexOf("]", numsStart);
        String numsStr = json.substring(numsStart + 1, numsEnd).trim();
        int[] nums = Arrays.stream(numsStr.split(","))
                           .map(String::trim)
                           .mapToInt(Integer::parseInt)
                           .toArray();
        int targetIdx = json.indexOf("\"target\"");
        String afterTarget = json.substring(targetIdx + "\"target\"".length()).trim();
        int target = Integer.parseInt(afterTarget.replaceFirst("^\\s*:\\s*(-?\\d+).*", "$1"));
        System.out.println(Arrays.toString(twoSum(nums, target)));
    }

    {{USER_CODE}}
}
$$
WHERE problem_id  = 'c1000000-0000-0000-0000-000000000001'
  AND language_id = 'a1000000-0000-0000-0000-000000000004';


-- ── C ─────────────────────────────────────────────────────────
UPDATE problem_templates
SET runner_code = $$#include <stdio.h>
#include <stdlib.h>
#include <string.h>

{{USER_CODE}}

int main() {
    char buf[4096] = {0};
    fread(buf, 1, sizeof(buf) - 1, stdin);
    /* parse nums array */
    char *p = strstr(buf, "\"nums\"");
    p = strchr(p, '[') + 1;
    int nums[1024], numsSize = 0;
    while (*p && *p != ']') {
        while (*p == ' ' || *p == ',') p++;
        if (*p == ']') break;
        nums[numsSize++] = (int)strtol(p, &p, 10);
    }
    /* parse target */
    p = strstr(buf, "\"target\"");
    p = strchr(p, ':') + 1;
    int target = (int)strtol(p, NULL, 10);

    int returnSize = 0;
    int *res = twoSum(nums, numsSize, target, &returnSize);
    printf("[%d,%d]\n", res[0], res[1]);
    free(res);
    return 0;
}
$$
WHERE problem_id  = 'c1000000-0000-0000-0000-000000000001'
  AND language_id = 'a1000000-0000-0000-0000-000000000005';
