---
name: requirement-analysis
description: "Use when Codex needs to perform Chinese product requirement analysis before prototyping: clarify rough business ideas, organize meeting notes/screenshots/old-system issues, analyze competitor app/page screenshots, infer visible fields and interactions, extract business rules, fields with traceable sources, functional buttons, PC/mobile differences, page lists, page transitions, and open questions for Axure-style prototype design. Trigger on requests for 需求分析, 需求梳理, 竞品分析, 截图反推, 业务规则整理, 字段规则, 原型前置材料, 产品需求分析, or preparing inputs for Axure 原型设计."
---

# 需求分析

## Compatibility Role

Use this skill when the user only wants requirement analysis, requirement cleanup, competitor screenshot analysis, field-rule extraction, or prototype-preparation material.

Do not generate prototypes here. If the user asks for both analysis and an Axure-style clickable HTML prototype, route to `requirements-to-axure-html-prototype` after producing or confirming the analysis.

Read these references when producing a full analysis:

- `references/需求分析_输出规范_v1_20260621.md`
- `/Users/xuyunfeng/.codex/skills/requirements-to-axure-html-prototype/references/需求原型合并规范_v1_20260702.md`

## Output Contract

Produce concise Chinese product analysis with these sections:

```markdown
# 需求分析

## 1. 背景与范围
## 2. 业务规则
## 3. 字段说明
## 4. 功能按钮与操作说明
## 5. PC/移动端差异
## 6. 页面内容说明
## 7. 页面与跳转逻辑
## 8. 待确认问题
## 9. 原型设计输入
```

## Workflow

1. Identify the input type: rough idea, meeting notes, screenshots, old-system issues, competitor screenshots, or existing partial requirements.
2. Extract business rules first, then fields, buttons, pages, states, permissions, PC/mobile scope, transitions, and unclear points.
3. Separate visible facts from inferred assumptions, especially for screenshots and competitor analysis.
4. Keep fields and buttons separate. Fields are data; buttons are actions with trigger, result, jump/popup/refresh behavior, and display condition.
5. For row actions, name the operated record and carry key row fields into the target page or popup.
6. Mark unclear field sources, permissions, page jumps, button results, status changes, and PC/mobile scope as **待确认问题**.
7. End with **原型设计输入** so `axure-prototype-design` or `requirements-to-axure-html-prototype` can continue without re-analysis.

## Guardrails

- Use business language, not API/database/component implementation language.
- Do not invent field sources or button results. Mark unknowns as pending.
- Do not turn backend rules, calculations, or reviewer notes into user-visible UI content.
- Every page must explain visible content, fields, buttons, default state, empty/exception/no-permission states, and action results.
- Page hierarchy is product information. Define page ownership and navigation structure before prototype design.
- States do not belong in navigation hierarchy; put them under related page notes.
