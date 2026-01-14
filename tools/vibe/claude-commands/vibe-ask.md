---
description: Analyze the vibe screenshot and recommend fixes
---

Please read the screenshot at `.vibedbg/region.png` and help me analyze the issue shown.

First, check if the screenshot exists and gather context:

```bash
ls -la .vibedbg/
cat .vibedbg/region.json 2>/dev/null
git status --porcelain=v1
git diff --stat 2>/dev/null
tail -n 200 .vibedbg/terminal.log 2>/dev/null
echo "Screenshot path: $(pwd)/.vibedbg/region.png"
```

Then:
1. Read the screenshot at the absolute path shown above (use the `echo` output)
2. Identify any errors, bugs, or issues visible in the image
3. Search the codebase for relevant files
4. Provide analysis and recommended action items

---

**Your task:** Read the screenshot and analyze the issue. Follow this process:

1. **Facts Observed**: List visible error messages, status codes, stack traces, filenames, line numbers, URLs
2. **Hypotheses**: Rank 2-4 possible causes and what evidence would confirm
3. **Evidence Gathered**: Search codebase, open relevant files, run minimal commands
4. **Recommended Actions**: List specific changes to make, with file paths and line numbers

**IMPORTANT:** Do NOT make any changes to files. Only provide analysis and recommendations.

**Do NOT:**
- Make any edits to files
- Run any commands that modify the codebase
- Assume the screenshot is from a browser without evidence
- Hallucinate screenshot content - if unreadable, say so
- Suggest large refactors
- Recommend adding new dependencies unless absolutely necessary
